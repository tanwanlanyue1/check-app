import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:scet_check/api/api.dart';
import 'package:scet_check/api/request.dart';
import 'package:scet_check/components/generalduty/time_select.dart';
import 'package:scet_check/components/generalduty/toast_widget.dart';
import 'package:scet_check/components/generalduty/upload_image.dart';
import 'package:scet_check/page/module_steward/check/statisticAnaly/components/form_check.dart';
import 'package:scet_check/page/module_steward/personal/components/task_compon.dart';
import 'package:scet_check/utils/screen/screen.dart';
import 'package:scet_check/utils/time/utc_tolocal.dart';

import 'components/rectify_components.dart';

///管家排查
///arguments:{companyId:公司id，companyName：公司名称,uuid:清单id,'task':任务}
class StewardCheck extends StatefulWidget {
  Map? arguments;
  StewardCheck({Key? key,this.arguments, }) : super(key: key);

  @override
  _StewardCheckState createState() => _StewardCheckState();
}

class _StewardCheckState extends State<StewardCheck>{
  bool tidy = true; //展开/收起
  bool sing = false; //展开/收起
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
  bool pigeon = false; //是否可以归档
  bool subStatus = false; //是否可以修改的状态
  bool task = false;//是否任务
  bool firstTask = false;//是否第一次从任务进入
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Map<String, dynamic> subCompanies = {'companies':[],'environments':[]};//提交的数组
  List review = [];//复查列表

  /// 获取清单详情
  /// id:清单id
  /// argumentMap 提交问题传递的参数
  void _getCompany() async {
    var response = await Request().get(Api.url['inventory']+'/$uuid');
    if(response['statusCode'] == 200 && response['data'] != null) {
      setState(() {
        _getProblem();
        repertoire = response['data'];
        stewardCheck = repertoire['checkPersonnel'];
        location = repertoire['company']?['region']['name'];
        area = repertoire['company']?['district']['name'];
        checkDate = RectifyComponents.formatTime(repertoire['createdAt']);
        abarbeitungDates = repertoire['solvedAt'] != null ? RectifyComponents.formatTime(repertoire['solvedAt']) : '';
        sceneReviewDate = repertoire['reviewedAt'] != null ? RectifyComponents.formatTime(repertoire['reviewedAt']) : '';
        checkType = repertoire['checkType'] == 1 ? '隐患排查':
        repertoire['checkType'] == 2 ? '专项检查' :
        repertoire['checkType'] == 3 ? '现场检查':
        repertoire['checkType'] == 4 ? '表格填报': '其他类型';
        subStatus = repertoire['status'] == 6 ? true : false; //状态为6，可以提交问题、修改
        task = repertoire['latitude'] == null ? true : false; //判断是否从任务过来
        _problemSearch(
            data: {
              'status':2,
              'companyId':repertoire['company']['id'],
            }
        );
        argumentMap = {
          'declare':true,//申报
          'uuid': uuid,//清单ID
          'addProblem':true,//新增问题
          'stewardCheck': stewardCheck,//签到人员
          'districtId': repertoire['company']['districtId'],//片区id
          'companyId': repertoire['company']['id'],//企业id
          'industryId': repertoire['company']['industryId'],//行业ID
          'inventoryStatus': repertoire['status'],//清单状态
        };
        if(firstTask) {
          Navigator.pushNamed(context, '/fillInForm', arguments: argumentMap).then((value) => {
              if(value == null){
                  firstTask = false,
                  _getProblem()
              }
          });
        }
      });
    }
  }

  /// 获取问题
  ///companyId:公司id
  ///page:第几页
  ///size:每页多大
  ///andWhere:查询的条件
  ///check 添加一个提交问题的判断
  ///有一个问题未通过，就不可以归档
  void _getProblem() async {
    var response = await Request().get(Api.url['problemList'],
      data: {
        'inventory.id':uuid
      },);
    if(response['statusCode'] == 200 && response['data'] != null) {
      setState(() {
        problemList = response['data']['list'];
        for(var i=0; i<problemList.length; i++){
          if(problemList[i]['status'] != 3){
            pigeon = false;
          }else{
            pigeon = repertoire['status'] == 4 ||  repertoire['status'] == 1 ? true : false; //审核已通过
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
        _getCompany();
        setState(() {});
        ToastWidget.showToastMsg('修改并提交成功');
      }
  }


  @override
  void initState() {
    // TODO: implement initState
    uuid = widget.arguments?['uuid'].toString() ?? '';
    firstTask = widget.arguments?['task'] ?? false;
    //查询清单下的问题
    _getCompany();
    super.initState();
  }
  /// 获取企业下的问题/问题搜索筛选
  ///companyId:公司id
  ///page:第几页
  ///size:每页多大
  /// 'timeSearch':确认传递时间,
  /// 'startTime':开始时间,
  /// 'endTime':结束时间,
  ///添加一个状态 check-提交到企业,environment-提交到环保局
  _problemSearch({Map<String,dynamic>? data}) async {
    var response = await Request().get(Api.url['problemList'],data: data);
    if(response['statusCode'] == 200 && response['data'] != null){
      review = response['data']['list'];
      setState(() {});
    }
  }

    @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Column(
        children: [
          TaskCompon.topTitle(
              title: '隐患排查',
              left: true,
              callBack: (){
                Navigator.pop(context);
              }
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.only(top: 0),
              children: [
                repertoire.isNotEmpty && !task?
                singSurvey():
                Container(),
                repertoire.isNotEmpty ?
                survey():
                Container(),
                concerns(),
                notReview(),
                pigeonhole(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ///签到概况
  Widget singSurvey(){
    return Container(
      padding: EdgeInsets.only(left: px(24),right: px(24)),
      color: Colors.white,
      child: Visibility(
        visible: sing,
        child: FormCheck.dataCard(
          padding: false,
            children: [
              FormCheck.formTitle(
                  '签到概况',
                  showUp: sing,
                  tidy: sing,
                  onTaps: (){
                    sing = !sing;
                    setState(() {});
                  }
              ),
              surveyItem('归属片区',area),
              surveyItem('签到坐标','${(double.parse(repertoire['longitude'])).toStringAsFixed(2)}, '
                  '${((double.parse(repertoire['latitude'])).toStringAsFixed(2))}',),
              surveyItem('排查人员',stewardCheck),
              surveyItem('企业名',repertoire['company']['name']),
              surveyItem('排查日期',checkDate.substring(0,10)),
              FormCheck.rowItem(
                alignStart: true,
                title: "签到照片",
                child: UploadImage(
                  imgList: repertoire['images'],
                  closeIcon: false,
                ),
              ),
            ]
        ),
        replacement: SizedBox(
          height: px(88),
          child: FormCheck.formTitle(
              '签到概况',
              showUp: true,
              tidy: sing,
              onTaps: (){
                sing = !sing;
                setState(() {});
              }
          ),
        ),
      ),
    );
  }

  ///排查概况
  ///修改检查类型，排查日期
  Widget survey(){
    return Container(
      padding: EdgeInsets.only(left: px(24),right: px(24)),
      color: Colors.white,
      child: Visibility(
        visible: tidy,
        child: FormCheck.dataCard(
            padding: false,
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
              surveyItem('排查人员',stewardCheck),
              Container(
                margin: EdgeInsets.only(top: px(24)),
                child: FormCheck.rowItem(
                  title: '检查类型',
                  expandedLeft: true,
                  child: Text(checkType,style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),textAlign: TextAlign.right,),
                ),
              ),
              surveyItem('排查日期',checkDate.substring(0,10)),
              Container(
                margin: EdgeInsets.only(top: px(24)),
                child: FormCheck.rowItem(
                  title: '整改截至日期',
                  expandedLeft: true,
                  child: !subStatus ?
                  Text(abarbeitungDates,style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),textAlign: TextAlign.right,):
                  TimeSelect(
                    scaffoldKey: _scaffoldKey,
                    hintText: "请选择排查时间",
                    time: abarbeitungDates.isNotEmpty ? DateTime.parse(abarbeitungDates) : null,
                    callBack: (time) {
                      abarbeitungDates = formatTime(time);
                      // 修改清单的排查日期
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
                  child: !subStatus ?
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
                    '隐患问题',
                  ),
                ),
              ),
              subStatus ?
              GestureDetector(
                child: Container(
                  width: px(40),
                  height: px(41),
                  margin: EdgeInsets.only(right: px(20)),
                  child: Image.asset('lib/assets/icons/form/add.png')),
                  onTap: () async {
                    var res = await Navigator.pushNamed(context, '/fillInForm', arguments: argumentMap);
                    if(res == null){
                      _getProblem();
                    }
                  },
              ) :
              Container(),
            ],
          ),
          Column(
            children: List.generate(problemList.length, (i) => RectifyComponents.rectifyRow(
                company: problemList[i],
                i: i,
                callBack:() async {
                  var res = await Navigator.pushNamed(context, '/rectificationProblem',
                      arguments: {'check':true,'problemId':problemList[i]['id'],'inventoryStatus': repertoire['status'],}
                  );
                  if(res == null){
                    _getProblem();
                  }
                }
            )),
          ),
        ],
      ),
    );
  }

  ///该企业下未复查的列表
  Widget notReview(){
    return Container(
      margin: EdgeInsets.only(top: px(4)),
      color: Colors.white,
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: px(20),left: px(32),),
            height: px(55),
            child: FormCheck.formTitle(
              '复查问题',
            ),
          ),
          Column(
            children: List.generate(review.length, (i) => RectifyComponents.rectifyRow(
                company: review[i],
                i: i,
                callBack:() async {
                  var res =  await Navigator.pushNamed(context, '/fillAbarbeitung',arguments: {'id':review[i]['id'],'review':true});
                  if(res == true){
                    _getCompany();
                  }
                }
            )),
          ),
        ],
      ),
    );
  }


  ///归档
  ///是否可以提交问题
  Widget pigeonhole(){
    return Container(
      height: px(88),
      margin: EdgeInsets.only(top: px(12)),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            child: Container(
              width: px(240),
              height: px(56),
              alignment: Alignment.center,
              margin: EdgeInsets.only(left: px(40)),
              child: Text(
                '归档',
                style: TextStyle(
                    fontSize: sp(24),
                    fontFamily: "R",
                    color: Colors.white),
              ),
              decoration: BoxDecoration(
                color: Color(0xff4D7FFF),
                border: Border.all(width: px(2),color: Color(0XffE8E8E8)),
                borderRadius: BorderRadius.all(Radius.circular(px(28))),
              ),
            ),
            onTap: (){
              if(pigeon){
                _setInventory(
                    {
                      'id':uuid,
                      'status': 2,
                    }
                );
              }else{
                if(repertoire['status'] == 2){
                  ToastWidget.showToastMsg('该清单已归档');
                }else{
                  ToastWidget.showToastMsg('有问题未通过，暂时无法归档');
                }
              }
              setState(() {});
            },
          ),
          GestureDetector(
            child: Container(
              width: px(240),
              height: px(56),
              alignment: Alignment.center,
              margin: EdgeInsets.only(left: px(40)),
              child: Text(
                '提交',
                style: TextStyle(
                    fontSize: sp(24),
                    fontFamily: "R",
                    color: Colors.white),
              ),
              decoration: BoxDecoration(
                color: Color(0xff4D7FFF),
                border: Border.all(width: px(2),color: Color(0XffE8E8E8)),
                borderRadius: BorderRadius.all(Radius.circular(px(28))),
              ),
            ),
            onTap: (){
              if(repertoire['status'] == 6 || repertoire['status'] == 5){
                _setInventory(
                    {
                      'id':uuid,
                      'status': 3,
                    }
                );
              }else{
                ToastWidget.showToastMsg('当前状态不可提交');
              }
              setState(() {});
            },
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
