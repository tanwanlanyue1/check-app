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
  List tabBar = ["排查工具",'管家平台'];//tab列表
  String userName = '';//用户名
  DateTime startTime = DateTime.now();//选择开始时间
  DateTime endTime = DateTime.now();//选择结束时间
  List haveDoneList = [];//已办任务
  String userId = ''; //用户id
  late TabController _tabController; //TabBar控制器

  /// 查询任务列表
  /// status 1：待办 2：已办
  void _getTaskList() async {
    var response = await Request().get(
      Api.url['taskList'],data: {
      "check_user_list": {"id":userId},
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
    _tabController = TabController(vsync: this,length: tabBar.length);
    userId= jsonDecode(StorageUtil().getString(StorageKey.PersonalData))['id'].toString();
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
                  haveDoneList.isNotEmpty ?
                  ListView(
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
                  ) :
                  Column(
                    children: [
                      NoData(timeType: true, state: '未获取到数据!')
                    ],
                  ),
                  CheckTask(),
                ]
            ),
          ),
        ],
      ),
    );
  }

}
