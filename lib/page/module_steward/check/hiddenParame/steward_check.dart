import 'package:flutter/material.dart';
import 'package:scet_check/api/api.dart';
import 'package:scet_check/api/request.dart';
import 'package:scet_check/components/generalduty/time_select.dart';
import 'package:scet_check/components/generalduty/toast_widget.dart';
import 'package:scet_check/page/module_enterprise/abarbeitung/abarbeitung_pdf.dart';
import 'package:scet_check/page/module_steward/check/statisticAnaly/components/form_check.dart';
import 'package:scet_check/page/module_steward/law/components/law_components.dart';
import 'package:scet_check/utils/screen/screen.dart';
import 'package:scet_check/utils/time/utc_tolocal.dart';

import 'components/rectify_components.dart';



///管家排查
///arguments:{companyId:公司id，companyName：公司名称,uuid:清单id}
class StewardCheck extends StatefulWidget {
  Map? arguments;
  StewardCheck({Key? key,this.arguments, }) : super(key: key);

  @override
  _StewardCheckState createState() => _StewardCheckState();
}

class _StewardCheckState extends State<StewardCheck> {
  /// 1,未整改;2,已整改;3,整改已通过;4,整改未通过
  int type = 1;
  bool tidy = true; //展开/收起
  Map repertoire = {};//清单
  Map argumentMap = {};//传递的参数
  List problemList = [];//企业下的问题
  String uuid = '';//清单id
  String area = '';//归属片区
  String location = '';//区域位置
  String stewardCheck = '';//检查人 
  String checkDate = '';//排查日期
  String abarbeitungDates = '';//整改日期
  String sceneReviewDate = '';//现场复查日期
  String checkType = '';//检查类型
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Map<String,dynamic> data = {};//查询问题的参数

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
        abarbeitungDates = repertoire['solvedAt'] != null ? RectifyComponents.formatTime(repertoire['solvedAt']) : '';
        sceneReviewDate = repertoire['reviewedAt'] != null ? RectifyComponents.formatTime(repertoire['reviewedAt']) : '';
        checkType = repertoire['checkType'] == 1 ? '管家排查': '管家排查';
        argumentMap = {
          'declare':true,//申报
          'uuid': uuid,//清单ID
          'districtId': repertoire['company']['districtId'],//片区id
          'companyId': repertoire['company']['id'],//企业id
          'industryId': repertoire['company']['industryId'],//行业ID
        };
      });
    }
  }

  /// 获取问题
  ///companyId:公司id
  ///page:第几页
  ///size:每页多大
  ///andWhere:查询的条件
  void _getProblem() async {
    var response = await Request().get(Api.url['problemList'],data: data,);
    if(response['statusCode'] == 200 && response['data'] != null) {
      setState(() {
        problemList = response['data']['list'];
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
    uuid = widget.arguments?['uuid'].toString() ?? '';
    //查询清单下的问题
    data = {
      'page':1,
      'size':50,
      'inventory.id':uuid
    };
    _getProblem();
    _getCompany();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Column(
        children: [
          topBar(
              '管家排查'
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.only(top: 0),
              children: [
                repertoire.isNotEmpty ?
                survey():
                Container(),
                concerns(),
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
          Container(
            height: px(28),
            width: px(28),
            margin: EdgeInsets.only(bottom: px(15),left: px(12)),
          ),
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
                  child: TimeSelect(
                    scaffoldKey: _scaffoldKey,
                    hintText: "请选择排查时间",
                    time: abarbeitungDates.isNotEmpty ? DateTime.parse(abarbeitungDates) :null,
                    callBack: (time) {
                      abarbeitungDates = formatTime(time);
                      _setInventory(
                          {
                            'id':uuid,
                            'solvedAt': abarbeitungDates,
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
                  child: TimeSelect(
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
                    '隐患问题',
                  ),
                ),
              ),
              GestureDetector(
                child: Container(
                  width: px(40),
                  height: px(41),
                  margin: EdgeInsets.only(right: px(20)),
                  child: Image.asset('lib/assets/icons/form/add.png')),
                onTap: () async{
                  var res = await Navigator.pushNamed(context, '/fillInForm',arguments: argumentMap);
                  if(res == true){
                    _getProblem();
                  }
                },
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
                    callBack:(){
                      Navigator.pushNamed(context, '/rectificationProblem',
                          arguments: {'check':true,'problemId':problemList[i]['id']}
                      );
                    }
                )),
              ),
            ],
          ),
        ],
      ),
    );
  }

  ///日期转换
  String formatTime(time) {
    return utcToLocal(time.toString()).substring(0,10);
  }
}
