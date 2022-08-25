import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:scet_check/utils/screen/screen.dart';
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

class _HistoryTaskState extends State<HistoryTask>  with SingleTickerProviderStateMixin{
  List tabBar = ["全部",'个人'];//tab列表
  String companyId = '';//企业id+
  late TabController _tabController; //TabBar控制器


  @override
  void initState() {
    // TODO: implement initState
    _tabController = TabController(vsync: this,length: tabBar.length);
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
              home: true,
              callBack: (){
                Navigator.pop(context);
              }
          ),
          SizedBox(
            height: px(96),
            child: DefaultTabController(
              length: tabBar.length,
              child: Container(
                margin: EdgeInsets.only(left: px(20),right: px(20)),
                child: TabBar(
                    controller: _tabController,
                    indicatorSize: TabBarIndicatorSize.label,
                    indicatorPadding: EdgeInsets.only(bottom: px(16)),
                    isScrollable: true,
                    labelColor: Color(0xff4D7FFF),
                    labelStyle: TextStyle(fontSize: sp(32.0),fontFamily: 'M'),
                    unselectedLabelColor: Color(0xff646566),
                    unselectedLabelStyle: TextStyle(fontSize: sp(30.0),fontFamily: 'R'),
                    indicatorColor:Color(0xff4D7FFF),
                    indicatorWeight: px(4),
                    tabs: tabBar.map((item) {
                      return Tab(text: '$item');
                    }).toList()
                ),
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
                controller: _tabController,
                children: <Widget>[
                  HistoryInventory(
                    companyId: companyId,
                  ),
                  HistoryInventory(
                    companyId: companyId,
                    user: true,
                  ),
                ]
            ),
          ),
        ],
      ),
    );
  }

}
