import 'package:flutter/material.dart';
import 'package:scet_check/api/api.dart';
import 'package:scet_check/api/request.dart';
import 'package:scet_check/components/generalduty/time_select.dart';
import 'package:scet_check/components/generalduty/toast_widget.dart';
import 'package:scet_check/page/module_steward/check/hiddenParame/components/rectify_components.dart';
import 'package:scet_check/page/module_steward/check/statisticAnaly/components/form_check.dart';
import 'package:scet_check/page/module_steward/law/components/law_components.dart';
import 'package:scet_check/utils/screen/screen.dart';
import 'package:scet_check/utils/time/utc_tolocal.dart';

import 'abarbeitung_pdf.dart';


///企业清单详情
/// arguments:{'uuid':清单id，或者问题id,'company':true}
class EnterprisInventory extends StatefulWidget {
  Map arguments;
  EnterprisInventory({Key? key,required this.arguments,}) : super(key: key);

  @override
  _EnterprisInventoryState createState() => _EnterprisInventoryState();
}

class _EnterprisInventoryState extends State<EnterprisInventory> {
  /// 状态；-1：未处理;0:处理完；1：处理中
  int type = 1;
  bool tidy = true; //展开/收起
  Map repertoire = {};//清单
  Map argumentMap = {};//传递的参数
  List problemList = [];//企业下的问题
  List pdfList = [];//清单报告
  String uuid = '';//清单id
  String area = '';//归属片区
  String location = '';//区域位置
  String stewardCheck = '';//检查人
  String checkDate = '';//排查日期
  String abarbeitungDate = '';//整改日期
  String sceneReviewDate = '';//现场复查日期
  String checkType = '管家排查';//检查类型
  String companyId = '';//企业用户id
  bool uploading = false;//判断是否可以上传
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  /// 获取清单详情
  /// id:清单id
  void _getCompany() async {
    var response = await Request().get(Api.url['inventory']+'/$uuid',);
    if(response['statusCode'] == 200 && response['data'] != null) {
      setState(() {
        repertoire = response['data'] ;
        stewardCheck = repertoire['checkPersonnel'];
        location = repertoire['company']['region']['name'];
        area = repertoire['company']['district']['name'];
        checkDate = RectifyComponents.formatTime(repertoire['createdAt']);
        abarbeitungDate = repertoire['solvedAt'] != null ? RectifyComponents.formatTime(repertoire['solvedAt']) : '';
        sceneReviewDate = repertoire['reviewedAt'] != null ? RectifyComponents.formatTime(repertoire['reviewedAt']) : '';
        argumentMap = {
          'declare':true,//申报
          'uuid': uuid,//清单ID
          'districtId': repertoire['company']['districtId'],//片区id
          'companyId': repertoire['company']['id'],//企业id
          'industryId': repertoire['company']['industryId'],//行业ID
        };
        pdfList = repertoire['inventoryReports'];
      });
    }
  }

  /// 获取清单下的问题
  ///companyId:公司id
  ///page:第几页
  ///size:每页多大
  ///andWhere:查询的条件
  ///isCompanyRead:判断该是否企业可以看
  ///uploading:判断该是否整改完成
  void _getProblem() async {
    Map<String,dynamic> data = {
      'inventory.id':uuid
    };
    var response = await Request().get(Api.url['problemList'],data: data,);
    if(response['statusCode'] == 200 && response['data'] != null) {
      setState(() {
       for(var i=0; i<response['data']['list'].length; i++){
          if(response['data']['list'][i]['isCompanyRead'] == true){
            problemList.add(response['data']['list'][i]);
          }
        }
        for(var i=0; i<problemList.length; i++){
          if(problemList[i]['status'] == 2 || problemList[i]['status'] == 3){
            uploading = true;
          }else{
            uploading = false;
          }
        }
      });
    }
  }
  /// 签到清单
  /// id: uuid
  /// solvedAt: 整改期限
  /// reviewedAt: 复查期限
  void _setInventory(Map<String, dynamic> _data) async {
    var response = await Request().post(
        Api.url['inventory'],
        data: _data
    );
    if(response['statusCode'] == 200) {
      ToastWidget.showToastMsg('修改日期成功');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    uuid = widget.arguments['uuid'];
    _getCompany();
    _getProblem();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Column(
        children: [
          topBar(
              '排查问题详情'
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.only(top: 0),
              children: [
                repertoire.isNotEmpty ?
                survey():
                Container(),
                concerns(),
                rectification(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ///头部
  Widget topBar(String title){
    return Container(
      color: Colors.white,
      height: px(88),
      margin: EdgeInsets.only(top: Adapt.padTopH()),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            child: Container(
              height: px(40),
              width: px(41),
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(left: px(20)),
              child: Image.asset('lib/assets/icons/other/chevronLeft.png',fit: BoxFit.fill,),
            ),
            onTap: ()async{
              Navigator.pop(context);
            },
          ),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              child: Text(title,style: TextStyle(color: Color(0xff323233),fontSize: sp(32),fontFamily: 'M'),),
            ),
          ),
          // Container(
          //   height: px(28),
          //   width: px(28),
          //   margin: EdgeInsets.only(bottom: px(15),left: px(12)),
          //   child: Icon(Icons.star,color: Color(0xffE65C5C),),
          // ),
          // Spacer(),
        ],
      ),
    );
  }

  ///排查概况
  Widget survey(){
    return Container(
      padding: EdgeInsets.only(left: px(24),right: px(24)),
      color: Colors.white,
      child: Visibility(
        visible: tidy,
        child: FormCheck.dataCard(
            children: [
              FormCheck.formTitle(
                  '排查概况',
                  showUp: true,
                  tidy: tidy,
                  onTaps: (){
                    tidy = !tidy;
                    setState(() {});
                  }
              ),
              surveyItem('归属片区',area),
              surveyItem('区域位置',location),
              surveyItem('检查人',stewardCheck),
              surveyItem('检查类型',checkType),
              surveyItem('排查日期',checkDate.substring(0,10)),
              Container(
                margin: EdgeInsets.only(top: px(24)),
                child: FormCheck.rowItem(
                  title: '整改截至日期',
                  expandedLeft: true,
                  child: uploading ?
                  Text(abarbeitungDate,style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),textAlign: TextAlign.right,):
                  TimeSelect(
                    scaffoldKey: _scaffoldKey,
                    hintText: "请选择排查时间",
                    time: abarbeitungDate.isNotEmpty ? DateTime.parse(abarbeitungDate) :null,
                    callBack: (time) {
                      abarbeitungDate = formatTime(time);
                      _setInventory(
                          {
                            'id':uuid,
                            'solvedAt': abarbeitungDate,
                          }
                      );
                      setState(() {});
                    },
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: px(24)),
                child: FormCheck.rowItem(
                  title: '现场复查日期',
                  expandedLeft: true,
                  child: uploading ?
                  Text(sceneReviewDate,style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),textAlign: TextAlign.right,):
                  TimeSelect(
                    scaffoldKey: _scaffoldKey,
                    hintText: "请选择排查时间",
                    time: sceneReviewDate.isNotEmpty ? DateTime.parse(sceneReviewDate) :null,
                    callBack: (time) {
                      sceneReviewDate = formatTime(time);
                      _setInventory(
                          {
                            'id':uuid,
                            'reviewedAt': sceneReviewDate,
                          }
                      );
                      setState(() {});
                    },
                  ),
                ),
              ),
            ]
        ),
        replacement: SizedBox(
          height: px(88),
          child: FormCheck.formTitle(
              '排查概况',
              showUp: true,
              tidy: tidy,
              onTaps: (){
                tidy = !tidy;
                setState(() {});
              }
          ),
        ),
      ),
    );
  }

  ///概况列表
  ///title: 左标题
  ///data: 右数据
  Widget surveyItem(String title,String data){
    return Container(
      margin: EdgeInsets.only(top: px(24)),
      child: FormCheck.rowItem(
        title: title,
        expandedLeft: true,
        child: Text(data,style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),textAlign: TextAlign.right,),
      ),
    );
  }

  ///隐患问题
  ///res:问题提交完成，
  Widget concerns(){
    return Container(
      margin: EdgeInsets.only(top: px(4)),
      color: Colors.white,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(top: px(20),left: px(32),),
                  height: px(55),
                  child: FormCheck.formTitle(
                    '整改问题',
                  ),
                ),
              ),
            ],
          ),
          Column(
            children: [
              Column(
                children: List.generate(problemList.length, (i) => RectifyComponents.rectifyRow(
                    company: problemList[i],
                    i: i,
                    review: false,
                    callBack:()async{
                      Navigator.pushNamed(context, '/abarbeitungFrom',arguments: {'id':problemList[i]['id']});
                    }
                )),
              ),
            ],
          ),
        ],
      ),
    );
  }

  ///整改报告
  Widget rectification(){
    return Container(
      margin: EdgeInsets.only(top: px(4),bottom: px(20)),
      color: Colors.white,
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: px(20),left: px(32),),
            child: FormCheck.formTitle(
              '整改报告',
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: px(20),left: px(20),right: px(20)),
            padding: EdgeInsets.only(left: px(16),bottom: px(20)),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(px(4.0))),
            ),
            child: Column(
              children: [
                Column(
                  children: List.generate(pdfList.length, (i) => report(i)),
                ),
                Container(
                  margin: EdgeInsets.only(top: px(24)),
                  child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: px(24)),
                        child: Text('上传PDF',style: TextStyle(fontSize: sp(28)),),
                      ),
                      Expanded(
                        child: AbarbeitungPdf(
                          url: Api.baseUrlApp + 'file/upload?savePath=清单报告/',
                          inventoryId: uuid,
                          uploading:uploading,
                          callback: (val){
                            if(val){
                              _getCompany();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  //报告
  Widget report(int i){
    return Column(
      children: [
        InkWell(
          child: Row(
            children: [
              Container(
                width: px(30),
                height: px(30),
                margin: EdgeInsets.only(right: px(8)),
                child: Image.asset('lib/assets/icons/check/PDF.png'),
              ),
              Expanded(
                child: Text(pdfList[i]['name'],style: TextStyle(color: Color(0xff323233),fontSize: sp(26)),),
              ),
              Container(
                height: px(40),
                width: px(41),
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(left: px(20)),
                child: Image.asset('lib/assets/icons/other/right.png',color: Colors.grey,),
              ),
            ],
          ),
          onTap: (){
            Navigator.pushNamed(context, '/PDFView',arguments: Api.baseUrlApp+pdfList[i]['file']?.replaceAll('\\', '/'));
          },
        ),
        Container(
          margin: EdgeInsets.only(top: px(20)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(left: px(12)),
                child: Text('提交时间:',style: TextStyle(color: Color(0xffC8C9CC),fontSize: sp(24)),),
              ),
              Container(
                margin: EdgeInsets.only(left: px(12)),
                child: Text(formatTime(pdfList[i]['createdAt']),style: TextStyle(color: Color(0xffC8C9CC),fontSize: sp(24)),),
              ),
            ],
          ),
        ),
      ],
    );
  }
  ///日期转换
  String formatTime(time) {
    return utcToLocal(time.toString()).substring(0,10);
  }
}
