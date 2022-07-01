import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:scet_check/api/api.dart';
import 'package:scet_check/api/request.dart';
import 'package:scet_check/components/generalduty/toast_widget.dart';
import 'package:scet_check/components/pertinence/companyEchart/column_echarts.dart';
import 'package:scet_check/page/module_steward/personal/components/task_compon.dart';
import 'package:scet_check/utils/screen/screen.dart';
import 'package:scet_check/utils/storage/data_storage_key.dart';
import 'package:scet_check/utils/storage/storage.dart';

class HomeClassify extends StatefulWidget {
  const HomeClassify({Key? key}) : super(key: key);

  @override
  _HomeClassifyState createState() => _HomeClassifyState();
}

///首页分类
class _HomeClassifyState extends State<HomeClassify> with RouteAware{
  List classify = [
    {"name":'统计分析',"icon":"lib/assets/icons/home/statistics.png"},
    {"name":'待办任务',"icon":"lib/assets/icons/home/backlog.png"},
    {"name":'已办任务',"icon":"lib/assets/icons/home/hoveDone.png"},
    {"name":'台账记录',"icon":"lib/assets/icons/home/standingBook.png"},
    {"name":'法律规范',"icon":"lib/assets/icons/home/law.png"},
    {"name":'分类分级',"icon":"lib/assets/icons/home/classify.png"},
    {"name":'通知中心',"icon":"lib/assets/icons/home/message.png"},
    {"name":'更多',"icon":"lib/assets/icons/home/more.png"}];//分类
  List statisticsData = [];//统计数据
  List issue = [];//问题
  List name = [];//问题
  List echartData = [];//问题
  bool show = true;//展示echarts
  int total = 0;//待办任务总数
  String userId = ''; //用户id

 /// 问题统计数据
 void _getProblemStatis() async {
   var response = await Request().get(
       Api.url['problemStatistics'],
       data: {
         'groupTable':'company',
         "size":10,
         "page":1,
       }
   );
   if(response['statusCode'] == 200 && mounted) {
     setState(() {
       statisticsData = response['data']['list'];
       for(var i = 0; i < statisticsData.length; i++){
         issue.add(int.parse(statisticsData[i]['allCount']));
         name.add(statisticsData[i]['companyShortName']);
       }
       echartData = issue;
        // echartData = [
        //    {
        //      'type': 'bar',
        //      'data': issue,
        //      'itemStyle':
        //        {
        //         'color': '#669AFF'
        //        } ,
        //    },
        //  ];
     });
   }
 }

 //选择事件
  void selectClass(int index){
   switch(index) {
     case 0: echartPop(callBack: (){
       Navigator.pushNamed(context, '/checkPage').then((value){
         setState(() {
           show = true;
         });});
     }); break;
     // case 1: Navigator.pushNamed(context, '/abutmentList'); break;
     case 1: Navigator.pushNamed(context, '/backlogTask'); break;
     case 2: Navigator.pushNamed(context, '/haveDoneTask'); break;
     case 3: Navigator.pushNamed(context, '/enterprisePage',arguments: {"history":true,"name":"台账记录"}); break;
     case 4: Navigator.pushNamed(context, '/policyStand',arguments: true); break;
     case 5: Navigator.pushNamed(context, '/targetClassifyPage'); break;
     case 6: Navigator.pushNamed(context, '/messagePage',arguments: {'company':false}); break;
     default: ToastWidget.showToastMsg('暂无更多页面');
   }
 }
  /// 查询任务列表
  /// status 1：待办 2：已办
  /// 主要查询total，获取到总数
  void _getTaskList() async {
    var response = await Request().get(
      Api.url['taskList'],
      data: {
        "check_user_list": {"id":userId},
        "status":1,
        "page":1,
        "size":1,
      },
    );
    if(response['statusCode'] == 200) {
      total = response['data']['total'];
      setState(() {});
    }
  }
 @override
  void initState() {
    // TODO: implement initState
   userId= jsonDecode(StorageUtil().getString(StorageKey.PersonalData))['id'].toString();
   _getProblemStatis();
   _getTaskList();
    super.initState();
  }

  ///首次登录进入页面，再跳转到有echart详情时，会闪退
  ///需要添加一个延时，用来关闭echart
  void echartPop({Function? callBack}){
    setState(() {show = false;});
    Future.delayed(Duration(milliseconds: 200)).then((onValue) {
      callBack?.call();
    });
  }

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            top(),
            Expanded(
              child: ListView(
                padding: EdgeInsets.only(top: px(0)),
                children: [
                  show ? Container(
                    margin: EdgeInsets.only(bottom: px(24),left: px(24),right: px(24)),
                    height: px(700),
                    width: px(550),
                    child: ColumnEcharts(
                      erectName: name,
                      data: echartData,
                      title:'园区企业问题数统计排名',
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(width: px(4),color: Colors.white),
                      borderRadius: BorderRadius.all(Radius.circular(px(20))),
                    ),
                  ):
                  Container(
                    margin: EdgeInsets.only(bottom: px(24)),
                    height: px(700),
                    width: px(550),
                  ),//图表
                  Container(
                    margin: EdgeInsets.only(left: px(24),right: px(24),bottom: px(24)),
                    padding: EdgeInsets.only(top: px(12),left: px(12),right: px(12)),
                    child: GridView.builder(
                      shrinkWrap:true,
                      physics: NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.all(0),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemCount: classify.length,
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Stack(
                                alignment: AlignmentDirectional.center,
                                children: [
                                  SizedBox(
                                    width: px(96),
                                    height: px(96),
                                    child: Image.asset('${classify[index]['icon']}'),
                                  ),
                                  index == 1 && total != 0?
                                  Positioned(
                                    right: 0,
                                    top: 0,
                                    child: Container(
                                      padding: EdgeInsets.only(left: px(8),right: px(8)),
                                      child: Text("$total",style: TextStyle(fontSize: sp(26),color: Colors.white),),
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.all(Radius.circular(px(20))),
                                      ),
                                    ),
                                  ) :
                                  Container()
                                ],
                              ),
                              Text('${classify[index]['name']}',style: TextStyle(color: Color(0xff323233),fontSize: sp(26)),),
                            ],
                          ),
                          onTap: () {
                            selectClass(index);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(//渐变位置
              begin: Alignment.topCenter,end: Alignment.bottomCenter,
              stops: const [0.0, 1.0], //[渐变起始点, 渐变结束点]
              colors: const [Color(0xffC0CCFE), Color(0xffF2F3FA)]//渐变颜色[始点颜色, 结束颜色]
          ),
        ),
      ),
    );
  }

  Widget top(){
   return Column(
     children: [
       Container(
         width: px(750),
         height: Adapt.padTopH(),
         color: Color(0xff19191A),
       ),
       Container(
         height: px(88),
         decoration: BoxDecoration(
           gradient: LinearGradient(//渐变位置
               begin: Alignment.topCenter,end: Alignment.bottomCenter,
               stops: const [0.0, 1.0], //[渐变起始点, 渐变结束点]
               colors: const [Color(0xffC0CCFE), Color(0xffC5D0FE)]//渐变颜色[始点颜色, 结束颜色]
           ),
         ),
         child: Row(
           children: [
             Container(
               width: px(56),
               height: px(56),
               margin: EdgeInsets.only(left: px(26),right: px(24)),
               child: Image.asset('lib/assets/icons/home/iconLogo.png',),
             ),
             Expanded(
               flex: 1,
               child: Container(
                 alignment: Alignment.centerLeft,
                 child: Text('隐患排查平台',style: TextStyle(color: Color(0xff323233),fontSize: sp(38),fontFamily: 'M'),),
               ),
             ),
           ],
         ),
       ),
     ],
   );
  }
}
