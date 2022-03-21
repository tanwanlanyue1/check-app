import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:scet_check/api/api.dart';
import 'package:scet_check/api/request.dart';
import 'package:scet_check/components/generalduty/toast_widget.dart';
import 'package:scet_check/page/module_enterprise/abarbeitung/problem_details.dart';
import 'package:scet_check/page/module_steward/check/hiddenParame/components/rectify_components.dart';
import 'package:scet_check/page/module_steward/check/potentialRisks/enterprise_reform.dart';
import 'package:scet_check/page/module_steward/check/potentialRisks/review_situation.dart';
import 'package:scet_check/utils/screen/screen.dart';
import 'package:scet_check/utils/storage/data_storage_key.dart';
import 'package:scet_check/utils/storage/storage.dart';

///整改问题表单
///arguments{'id'：企业id}
class AbarbeitungFrom extends StatefulWidget {
  final Map? arguments;
  final Function? callBack;
  const AbarbeitungFrom({Key? key,this.arguments,this.callBack}) : super(key: key);

  @override
  _AbarbeitungFromState createState() => _AbarbeitungFromState();
}

class _AbarbeitungFromState extends State<AbarbeitungFrom> {
  List imgDetails = [];//问题图片列表
  Map problemList = {};//问题详情
  String problemId = '';//问题ID
  bool declare = false; //申报
  bool abarbeitung = false; //是否可以整改
  String userName = '';//用户名
  String userId = '';//用户id
  List solutionList = [];//整改详情
  List reviewList = [];//复查详情

  @override
  void initState() {
    // TODO: implement initState
    problemId = widget.arguments?['id'];
    userName= jsonDecode(StorageUtil().getString(StorageKey.PersonalData))['nickname'];
    userId= jsonDecode(StorageUtil().getString(StorageKey.PersonalData))['id'];
    _getProblems();
    _setSolution();
    _getReviewList();
    super.initState();
  }
  /// 获取问题
  /// status:1,未整改;2,已整改;3,整改已通过;4,整改未通过
  void _getProblems() async {
    var response = await Request().get(Api.url['problem']+'/$problemId',);
    if(response['statusCode'] == 200) {
      problemList = response['data'];
      abarbeitung = response['data']['status'] == 1 ||
                    response['data']['status'] == 4 ? true :false;
      setState(() {});
    }
  }
  /// 整改详情，
  void _setSolution() async {
    Map<String,dynamic> _data = {
      'page':1,
      'size':50,
      'problem.id':problemId,
    };
    var response = await Request().get(
        Api.url['solutionList'],data: _data
    );
    if(response['statusCode'] == 200 && response['data']!=null) {
      solutionList = response['data']['list'];
      setState(() {});
    }
  }
  /// 复查详情，
  void _getReviewList() async {
    Map<String,dynamic> _data = {
      'page':1,
      'size':50,
      'problem.id': problemId,
    };
    var response = await Request().get(
        Api.url['reviewList'],data: _data
    );
    if(response['statusCode'] == 200 && response['data']!=null) {
      reviewList = response['data']['list'];
      setState(() {});
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          topBar(),
          Expanded(
            child: ListView(
              padding: EdgeInsets.only(top: 0),
              children: [
                //问题详情
                ProblemDetails(
                  problemList: problemList,
                ),
                //企业整改详情
                EnterpriseReform(
                  problemId: problemId,
                  solutionList: solutionList,
                ),
                //现场复查情况
                ReviewSituation(
                  arguments:{
                    'problemId':problemId,
                    'reviewList':reviewList,
                  },
                ),
                // rubyAgent(),
              ],
            ),
          )
        ],
      ),
    );
  }
  ///头部
  Widget topBar(){
    return Container(
      color: Colors.white,
      height: px(88),
      margin: EdgeInsets.only(top: Adapt.padTopH()),
      child: Row(
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
            flex: 1,
            child: Center(
              child: Text("隐患整改问题填报",style: TextStyle(color: Color(0xff323233),fontSize: sp(36),fontFamily: 'M'),),
            ),
          ),
          GestureDetector(
            child: Container(
                width: px(40),
                height: px(41),
                margin: EdgeInsets.only(right: px(20)),
                child: Image.asset('lib/assets/icons/form/add.png'),),
            onTap: () async{
              if(abarbeitung){
               var res = await Navigator.pushNamed(context, '/fillAbarabeitung',arguments: {'id':problemId});
               if(res == true){
                 _setSolution();
               }
              }else{
                ToastWidget.showToastMsg('当前问题已整改');
              }
            },
          ),
        ],
      ),
    );
  }
}
