import 'package:flutter/material.dart';
import 'package:scet_check/api/api.dart';
import 'package:scet_check/api/request.dart';
import 'package:scet_check/components/generalduty/toast_widget.dart';
import 'package:scet_check/components/pertinence/companyEchart/column_echarts.dart';
import 'package:scet_check/page/module_steward/personal/components/task_compon.dart';
import 'package:scet_check/utils/screen/screen.dart';

class HomeClassify extends StatefulWidget {
  const HomeClassify({Key? key}) : super(key: key);

  @override
  _HomeClassifyState createState() => _HomeClassifyState();
}

///首页分类
class _HomeClassifyState extends State<HomeClassify> with RouteAware{
  List classify = ['统计分析','待办任务','已办任务','台账记录','法律规范','通知中心','分类分级','更多'];//分类
  List statisticsData = [];//统计数据
  List issue = [];//问题
  List name = [];//问题
  List echartData = [];//问题
  bool show = true;//展示echarts

 /// 问题统计数据
 void _getProblemStatis() async {
   var response = await Request().get(
       Api.url['problemStatistics'],
       data: {
         'groupTable':'company'
       }
   );
   if(response['statusCode'] == 200 && mounted) {
     setState(() {
       statisticsData = response['data'];
       for(var i = 0; i < statisticsData.length; i++){
         issue.add(int.parse(statisticsData[i]['allCount']));
         name.add(statisticsData[i]['companyName']);
       }
        echartData = [
           {
             'type': 'bar',
             'data': issue,
             'color':'#D68184'
           },
         ];
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
     case 1: Navigator.pushNamed(context, '/backlogTask'); break;
     case 2: Navigator.pushNamed(context, '/haveDoneTask'); break;
     case 3: Navigator.pushNamed(context, '/enterprisePage',arguments: {"history":true}); break;
     case 4: Navigator.pushNamed(context, '/policyStand',arguments: true); break;
     case 5: Navigator.pushNamed(context, '/messagePage',arguments: {'company':false}); break;
     case 6: Navigator.pushNamed(context, '/targetClassifyPage'); break;
     default: ToastWidget.showToastMsg('暂无更多页面');
   }
 }

 @override
  void initState() {
    // TODO: implement initState
   _getProblemStatis();
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
      body: Column(
        children: [
          TaskCompon.topTitle(title: '首页'),
          Expanded(
            child: ListView(
              padding: EdgeInsets.only(top: px(0)),
              children: [
                show ? Container(
                  margin: EdgeInsets.only(bottom: px(24)),
                  height: px(700),
                  width: px(550),
                  child: ColumnEcharts(
                    erect: true,
                    erectName: name,
                    data: echartData,
                    title:'园区企业问题数统计',
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
                  color: Colors.white,
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
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(width: px(2)),
                            borderRadius: BorderRadius.all(Radius.circular(px(8))),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.margin),
                              Container(
                                child: Text('${classify[index]}'),
                              ),
                            ],
                          ),
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
    );
  }

}
