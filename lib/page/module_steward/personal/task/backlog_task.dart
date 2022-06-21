import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:scet_check/api/api.dart';
import 'package:scet_check/api/request.dart';
import 'package:scet_check/components/generalduty/no_data.dart';
import 'package:scet_check/utils/screen/screen.dart';
import 'package:scet_check/utils/storage/data_storage_key.dart';
import 'package:scet_check/utils/storage/storage.dart';

import '../components/task_compon.dart';
import 'abutment/abutment_list.dart';

///待办任务
///arguments:{'name':用户名,'id':用户id}
class BacklogTask extends StatefulWidget {
  Map? arguments;
  BacklogTask({Key? key,this.arguments}) : super(key: key);

  @override
  _BacklogTaskState createState() => _BacklogTaskState();
}

class _BacklogTaskState extends State<BacklogTask> with SingleTickerProviderStateMixin{
  List tabBar = ["现场检查","表格填报",'其他专项','管家平台'];//tab列表
  late TabController _tabController; //TabBar控制器
  String userId = ''; //用户id
  String checkPeople = '';//排查人员
  List taskList = [];//任务列表
  int type = 1;//现场检查

  @override
  void initState() {
    // TODO: implement initState
    _tabController = TabController(vsync: this,length: tabBar.length);
    userId= jsonDecode(StorageUtil().getString(StorageKey.PersonalData))['id'].toString();
    _tabController.addListener(() {
      type = _tabController.index+1;
      if(type != 4){
        _getTaskList();
      }
    });
    _getTaskList();
    super.initState();
  }
  /// 查询任务列表
  /// status 1：待办 2：已办
  /// type 1:现场检查 2:表格填报
  void _getTaskList() async {
    var response = await Request().get(
      Api.url['taskList'],
      data: {
        "check_user_list": {"id":userId},
        "status":1,
        "type":type
    },
    );
    if(response['statusCode'] == 200) {
      taskList = response['data']['list'];
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TaskCompon.topTitle(
              title: '待办任务',
              home: true,
              colors: Colors.transparent,
              callBack: (){
                Navigator.pop(context);
              },
          ),
          SizedBox(
            height: px(96),
            child: DefaultTabController(
              length: tabBar.length,
              child: Container(
                color: Colors.white,
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
                    onTap: (val){
                      type = val;
                      _getTaskList();
                    },
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
                  itemTask(),
                  itemTask(),
                  itemTask(),
                  AbutmentList(),
                ]
            ),
          ),
        ],
      ),
    );
  }

  Widget itemTask(){
    return taskList.isNotEmpty ?
      ListView(
        padding: EdgeInsets.only(top: 0),
        children: List.generate(taskList.length, (i){
          return TaskCompon.taskList(
              i: i,
              company: taskList[i],
              callBack: (val) {//任务详情id
                Navigator.pushNamed(context, '/taskDetails',arguments: {'backlog':true,'id':val}).then((value) => {
                  _getTaskList(),
                });
              }
          );
        }),
      ):Column(
        children: [
          NoData(timeType: true, state: '未获取到数据!')
        ],
      );
  }

}
