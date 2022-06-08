import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:scet_check/api/api.dart';
import 'package:scet_check/api/request.dart';
import 'package:scet_check/utils/storage/data_storage_key.dart';
import 'package:scet_check/utils/storage/storage.dart';

import 'components/task_compon.dart';

///任务详情
class HaveDoneTask extends StatefulWidget {
  const HaveDoneTask({Key? key}) : super(key: key);

  @override
  _HaveDoneTaskState createState() => _HaveDoneTaskState();
}

class _HaveDoneTaskState extends State<HaveDoneTask> {
  String userName = '';//用户名
  DateTime startTime = DateTime.now();//选择开始时间
  DateTime endTime = DateTime.now();//选择结束时间
  List haveDoneList = [];//已办任务
  String userId = ''; //用户id

  /// 查询任务列表
  /// status 1：待办 2：已办
  void _getTaskList() async {
    var response = await Request().get(
      Api.url['taskList'],data: {
      "checkUserList": {"id":userId},
      "status":2
    },
    );
    if(response['statusCode'] == 200) {
      haveDoneList = response['data']['list'];
      setState(() {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    userId = jsonDecode(StorageUtil().getString(StorageKey.PersonalData))['id'];
    _getTaskList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TaskCompon.topTitle(
              title: '已办任务',
              home: true,
              colors: Colors.transparent,
              callBack: (){
                Navigator.pop(context);
              }
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.only(top: 0),
              children: List.generate(haveDoneList.length, (i){
                return TaskCompon.taskList(
                    i: i,
                    company: haveDoneList[i],
                    callBack: (val){
                      Navigator.pushNamed(context, '/taskDetails',arguments: {'id':val});
                    }
                );
              }),
            ),
          )
        ],
      ),
    );
  }

}
