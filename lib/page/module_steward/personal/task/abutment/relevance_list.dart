import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:scet_check/api/api.dart';
import 'package:scet_check/api/request.dart';
import 'package:scet_check/components/generalduty/no_data.dart';
import 'package:scet_check/page/module_steward/check/statisticAnaly/components/form_check.dart';
import 'package:scet_check/page/module_steward/personal/components/task_compon.dart';
import 'package:scet_check/utils/screen/screen.dart';


///关联表单列表
///arguments:{
///taskId,formId,companyId 任务/表单/企业
///backlog/已办：代办
///name:表单名称
///}
class RelevanceList extends StatefulWidget {
  final Map? arguments;
  const RelevanceList({Key? key,this.arguments}) : super(key: key);

  @override
  _RelevanceListState createState() => _RelevanceListState();
}

class _RelevanceListState extends State<RelevanceList> {
  int? formId;//表单
  String taskId = '';//任务
  String name = '';//表单名称
  String companyId = '';//企业
  List relevance = [];//关联列表
  Map companyList = {};//任务企业列表
  bool backlog = true;//完成

  /// 获取记录列表
  _relevanceIssue() async {
    Map<String, dynamic> _data = companyId.isEmpty ? {
      'taskId':taskId,
      'formId':formId,
    } : {
      'taskId':taskId,
      'formId':formId,
      'companyId':companyId
    };
    var response = await Request().get(Api.url['relevanceIssue'],
        data: _data
    );
    if(response?['errCode'] == '10000') {
      relevance = response['result'];
      setState(() {});
    }
  }

  ///跳转新增
  void addRelevance({String? contents}) async{
    var res = await Navigator.pushNamed(context, '/abutmentFrom',arguments: {
      'formId':formId,
      'taskId':taskId,
      'backlog':backlog,
      'companyList':companyList,
    });
    if(res != null){
      _relevanceIssue();
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    taskId = widget.arguments?['taskId'];
    name = widget.arguments?['name'] ?? '';
    formId = widget.arguments?['formId'] ?? 0;
    backlog = widget.arguments?['backlog'] ?? false;
    companyList = widget.arguments?['companyList'];
    if(companyList.isNotEmpty){
      companyId = companyList['id'];
    }
    _relevanceIssue();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TaskCompon.topTitle(
              title: '表单列表',
              left: true,
              callBack: (){
                Navigator.pop(context);
              },
              child: backlog ?
              Container() :
              GestureDetector(
                child: Container(
                    width: px(40),
                    height: px(41),
                    margin: EdgeInsets.only(right: px(20)),
                    child: Image.asset('lib/assets/icons/form/add.png')),
                    onTap: () async {
                      addRelevance();
                    },
              )
          ),
          Expanded(
            child: Visibility(
              visible: relevance.isNotEmpty,
              child: Column(
                children: List.generate(relevance.length, (i) => taskDynamicForm(
                  i: i,
                  cycleList: relevance[i],
                )),
              ),
              replacement: Column(
                children: [
                  NoData(timeType: true, state: '未获取到数据!'),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  ///任务动态表单
  Widget taskDynamicForm({required int i,Map? cycleList}){
    return InkWell(
      child: Container(
        padding: EdgeInsets.only(bottom: px(12),left: px(12)),
        margin: EdgeInsets.only(left: px(24),right: px(24),top: px(24)),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(width: px(2),color: Color(0xffF6F6F6)),)
        ),
        child: FormCheck.rowItem(
          title: '$name:',
          child: Row(
            children: [
              Expanded(
                child: Text(DateTime.fromMillisecondsSinceEpoch(cycleList?['createDate']).toString().substring(0,16),style: TextStyle(color: Color(0xff323233),fontSize: sp(28),overflow: TextOverflow.ellipsis),),
              ),
              Icon(Icons.keyboard_arrow_right)
            ],
          ),
        ),
      ),
      onTap: () async {
        Map content = {};
        if(cycleList?['content'] != null){
          content = jsonDecode(cycleList?['content']) ?? {};
        }
        var res = await Navigator.pushNamed(context, '/abutmentFrom',arguments: {
          'formId':formId,
          'taskId':taskId,
          'content':content,
          'backlog':backlog,
          'id':cycleList?['id'],
          'companyList':companyList,
        });
        if(res != null){
          _relevanceIssue();
        }
      },
    );
  }

}
