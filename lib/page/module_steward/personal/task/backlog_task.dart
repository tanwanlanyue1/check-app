import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:scet_check/api/api.dart';
import 'package:scet_check/api/request.dart';
import 'package:scet_check/components/generalduty/no_data.dart';
import 'package:scet_check/utils/easyRefresh/easy_refreshs.dart';
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
  final EasyRefreshController _controller = EasyRefreshController(); // 上拉组件控制器
  // List tabBar = ["现场检查","表格填报",'其他专项','管家平台'];//tab列表
  // late TabController _tabController; //TabBar控制器
  String userId = ''; //用户id
  String checkPeople = '';//排查人员
  List taskList = [];//任务列表
  int type = 1;//现场检查
  bool _enableLoad = true; // 是否开启加载
  int _pageNo = 1; // 当前页码
  int _total = 10; // 总条数

  /// 查询任务列表
  ///page:第几页
  ///size:每页多大
  /// status 1：待办 2：已办
  /// type 1:现场检查 2:表格填报
  _getTaskList({typeStatusEnum? type,Map<String,dynamic>? data}) async {
    var response = await Request().get(Api.url['taskList'],data: data);
    if(response['statusCode'] == 200) {
      Map _data = response['data'];
      _pageNo++;
      if (mounted) {
        if(type == typeStatusEnum.onRefresh) {
          // 下拉刷新
          _onRefresh(data: _data['list'], total: _data['total']);
        }else if(type == typeStatusEnum.onLoad) {
          // 上拉加载
          _onLoad(data: _data['list'], total: _data['total']);
        }
      }
    }
  }

  /// 下拉刷新
  /// 判断是否是企业端,剔除掉非企业端看的问题
  _onRefresh({required List data,required int total}) {
    _total = total;
    taskList = data;
    _pageNo = 2;
    _enableLoad = true;
    _controller.finishRefresh();
    _controller.resetLoadState();
    if(taskList.length >= total){
      _enableLoad = false;
    }
    setState(() {});
  }

  /// 上拉加载
  /// 当前数据等于总数据，关闭上拉加载
  _onLoad({required List data,required int total}) {
    _total = total;
    taskList.addAll(data);
    _controller.finishLoadCallBack!();
    if(taskList.length >= total){
      _enableLoad = false;
      _controller.finishLoad(noMore: true);
    }
    setState(() {});
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
          Expanded(
            child: AbutmentList(),
          )
          // SizedBox(
          //   height: px(96),
          //   child: DefaultTabController(
          //     length: tabBar.length,
          //     child: Container(
          //       color: Colors.white,
          //       margin: EdgeInsets.only(left: px(20),right: px(20)),
          //       child: TabBar(
          //           controller: _tabController,
          //           indicatorSize: TabBarIndicatorSize.label,
          //           indicatorPadding: EdgeInsets.only(bottom: px(16)),
          //           isScrollable: true,
          //           labelColor: Color(0xff4D7FFF),
          //           labelStyle: TextStyle(fontSize: sp(32.0),fontFamily: 'M'),
          //           unselectedLabelColor: Color(0xff646566),
          //           unselectedLabelStyle: TextStyle(fontSize: sp(30.0),fontFamily: 'R'),
          //           indicatorColor:Color(0xff4D7FFF),
          //           indicatorWeight: px(4),
          //           onTap: (val){
          //             type = val;
          //             _controller.dispose();
          //             _getTaskList(
          //                 type: typeStatusEnum.onRefresh,
          //                 data: {
          //                   'page': 1,
          //                   'size': 10,
          //                   "checkUserList": {"id":userId},
          //                   "status":1,
          //                   "type":type
          //                 }
          //             );
          //           },
          //           tabs: tabBar.map((item) {
          //             return Tab(text: '$item');
          //           }).toList()
          //       ),
          //     ),
          //   ),
          // ),
          // Expanded(
          //   child: TabBarView(
          //       controller: _tabController,
          //       children: <Widget>[
          //         itemTask(),
          //         itemTask(),
          //         itemTask(),
          //       ]
          //   ),
          // ),
        ],
      ),
    );
  }

  ///任务列表
  Widget itemTask(){
    return EasyRefresh(
      enableControlFinishRefresh: true,
      enableControlFinishLoad: true,
      topBouncing: true,
      controller: _controller,
      taskIndependence: false,
      footer: footers(),
      header: headers(),
      onLoad: _enableLoad ? () async{
        _getTaskList(
            type: typeStatusEnum.onLoad,
            data: {
              'page': _pageNo,
              'size': 10,
              "checkUserList": {"id":userId},
              "status":1,
              "type":type
            }
        );
      }: null,
      onRefresh: () async {
        _pageNo = 1;
        _getTaskList(
            type: typeStatusEnum.onRefresh,
            data: {
              'page': 1,
              'size': 10,
              "checkUserList": {"id":userId},
              "status":1,
              "type":type
            }
        );
      },
      child: taskList.isNotEmpty ?
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
      ):
      Column(
        children: [
          NoData(timeType: true, state: '未获取到数据!')
        ],
      ),
    );
  }

}
