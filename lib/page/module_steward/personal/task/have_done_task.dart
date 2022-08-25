import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:scet_check/api/api.dart';
import 'package:scet_check/api/request.dart';
import 'package:scet_check/components/generalduty/no_data.dart';
import 'package:scet_check/utils/screen/screen.dart';
import 'package:scet_check/utils/storage/data_storage_key.dart';
import 'package:scet_check/utils/storage/storage.dart';

import '../components/task_compon.dart';
import 'abutment/check_task.dart';

///任务详情
class HaveDoneTask extends StatefulWidget {
  const HaveDoneTask({Key? key}) : super(key: key);

  @override
  _HaveDoneTaskState createState() => _HaveDoneTaskState();
}

class _HaveDoneTaskState extends State<HaveDoneTask> with SingleTickerProviderStateMixin{

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
            child: CheckTask(),
          )
        ],
      ),
    );
  }

}
