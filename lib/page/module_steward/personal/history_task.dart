import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:scet_check/utils/storage/data_storage_key.dart';
import 'package:scet_check/utils/storage/storage.dart';

import 'components/task_compon.dart';
import 'history_inventory.dart';

///历史台账
///arguments:{'name':用户名,'id':用户id}
class HistoryTask extends StatefulWidget {
  Map? arguments;
  HistoryTask({Key? key,this.arguments}) : super(key: key);

  @override
  _HistoryTaskState createState() => _HistoryTaskState();
}

class _HistoryTaskState extends State<HistoryTask> {
  String userId = '';//用户id
  String companyId = '';//企业id+


  @override
  void initState() {
    // TODO: implement initState
    userId= jsonDecode(StorageUtil().getString(StorageKey.PersonalData))['id'];
    if(widget.arguments != null){
      companyId = widget.arguments!['id'];
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TaskCompon.topTitle(
              title: '台账记录',
              left: true,
              callBack: (){
                Navigator.pop(context);
              }
          ),
          Expanded(
            child: HistoryInventory(
              companyId: companyId,
            ),
          ),
        ],
      ),
    );
  }

}
