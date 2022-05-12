import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:scet_check/api/api.dart';
import 'package:scet_check/api/request.dart';
import 'package:scet_check/page/module_enterprise/abarbeitung/problem_details.dart';
import 'package:scet_check/page/module_steward/check/potentialRisks/enterprise_reform.dart';
import 'package:scet_check/page/module_steward/check/potentialRisks/review_situation.dart';
import 'package:scet_check/page/module_steward/check/statisticAnaly/components/form_check.dart';
import 'package:scet_check/page/module_steward/personal/components/task_compon.dart';
import 'package:scet_check/utils/screen/screen.dart';
import 'package:scet_check/utils/storage/data_storage_key.dart';
import 'package:scet_check/utils/storage/storage.dart';

///整改问题表单 inventory
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
  bool getLose = false; //请求失败
  bool abarbeitung = false; //是否可以修改
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
      setState(() {});
    }
  }
  /// 整改详情，
  /// 判断是否提交，进行修改
  void _setSolution() async {
    Map<String,dynamic> _data = {
      'problemId':problemId,
    };
    var response = await Request().get(
        Api.url['solutionList'],data: _data
    );
    if(response['statusCode'] == 200 && response['data'] != null) {
      solutionList = response['data']['list'];
      abarbeitung = false;
      for(var i=0; i < solutionList.length; i++){
        if(solutionList[i]['status'] == 4){//4未提交
          abarbeitung = true;
        }
      }
      setState(() {});
    }else{
      getLose = true;
      setState(() {});
    }
  }
  /// 复查详情，
  void _getReviewList() async {
    Map<String,dynamic> _data = {
      'page':1,
      'size':50,
      'problemId': problemId,
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
          TaskCompon.topTitle(
              title: '隐患整改问题详情',
              left: true,
              callBack: (){
                Navigator.pop(context);
              }
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.only(top: 0),
              children: [
                //问题详情
                ProblemDetails(
                  problemList: problemList,
                ),
                //企业整改详情
                addAbarbeitung(),
                solutionList.isNotEmpty?
                EnterpriseReform(
                  problemId: problemId,
                  solutionList: solutionList,
                ):Container(),
                //现场复查情况
                reviewList.isNotEmpty?
                ReviewSituation(
                  arguments:{
                    'problemId':problemId,
                    'reviewList':reviewList,
                  },
                ) :
                Container(),
                // rubyAgent(),
              ],
            ),
          )
        ],
      ),
    );
  }

  ///填报整改情况.
  ///getLose网络请求，关掉新增按钮
  Widget addAbarbeitung(){
    return Container(
      padding: EdgeInsets.only(right: px(24),bottom: px(12)),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  color: Colors.white,
                  padding: EdgeInsets.only(left: px(24)),
                  margin: EdgeInsets.only(top: px(4)),
                  height: px(56),
                  child: FormCheck.formTitle('整改详情'),
                ),
              ),
              abarbeitung ?
              GestureDetector(
                child: Container(
                  padding: EdgeInsets.only(left: px(12),right: px(12),bottom: px(4),top: px(4)),
                  child: Text('修改',style: TextStyle(
                      fontSize: sp(26),
                      color: Colors.white
                  )),
                  decoration: BoxDecoration(
                    color: Color(0xff4D7FFF),
                    border: Border.all(width: px(2),color: Color(0XffE8E8E8)),
                    borderRadius: BorderRadius.all(Radius.circular(px(10))),
                  ),
                ),
                onTap: () async{
                  var res = await Navigator.pushNamed(context, '/fillAbarbeitung',arguments: {'id':problemId});
                  if(res == true){
                    _getProblems();
                    _setSolution();
                  }
                },
              ) :
              Container(),
            ],
          ),
          getLose != true && (solutionList.isEmpty || problemList['status'] == 4) && !abarbeitung ?
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            child: Container(
              margin: EdgeInsets.only(left: px(24),right: px(24),bottom: px(4)),
              padding: EdgeInsets.only(left: px(12),right: px(12),bottom: px(4),top: px(4)),
              child: Text('填报整改情况',style: TextStyle(
                  fontSize: sp(26),
                  color: Colors.white
                // color: Color(0xff323233),
              )),
              decoration: BoxDecoration(
                color: Color(0xff4D7FFF),
                border: Border.all(width: px(2),color: Color(0XffE8E8E8)),
                borderRadius: BorderRadius.all(Radius.circular(px(10))),
              ),
            ),
            onTap: () async{
              var res = await Navigator.pushNamed(context, '/fillAbarbeitung',arguments: {'id':problemId});
              if(res == true){
                _getProblems();
                _setSolution();
              }
            },
          ):
          Container(),
        ],
      ),
    );
  }

}
