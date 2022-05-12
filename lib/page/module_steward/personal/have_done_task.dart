import 'package:flutter/material.dart';
import 'package:scet_check/utils/screen/screen.dart';

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
              children: List.generate(5, (i){
                //taskList(i);
                return TaskCompon.taskList(
                    i: i,
                    company: {},
                    callBack: (){
                      Navigator.pushNamed(context, '/taskDetails');
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
