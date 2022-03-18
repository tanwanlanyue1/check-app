import 'package:flutter/material.dart';
import 'package:scet_check/api/api.dart';
import 'package:scet_check/api/request.dart';
import 'package:scet_check/page/module_steward/check/StatisticAnaly/statistics.dart';
import 'package:scet_check/page/module_steward/check/statisticAnaly/components/layout_page.dart';

///统计分析
class StatisticAnalysis extends StatefulWidget {
  const StatisticAnalysis({Key? key}) : super(key: key);

  @override
  _StatisticAnalysisState createState() => _StatisticAnalysisState();
}

class _StatisticAnalysisState extends State<StatisticAnalysis> {

  final PageController pagesController = PageController();
  List tabBar = [];//表头
  List districtList = [];//片区统计数据
  List districtId = [];//片区id
  int _pageIndex = 0;//下标

  @override
  void initState() {
    _getStatistics();
    super.initState();
  }
  /// 获取园区统计
  /// 获取tabbar表头，不在写死,
  /// 片区id也要获取，传递到页面请求片区详情
  void _getStatistics() async {
    var response = await Request().get(Api.url['district']);
    if(response['statusCode'] == 200) {
      tabBar = [];
      tabBar.add('园区统计');
      setState(() {
        districtList = response["data"];
        for(var i = 0; i<districtList.length;i++){
          tabBar.add(districtList[i]['name']);
          districtId.add(districtList[i]['id']);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
      return LayoutPage(
        tabBar: tabBar,
        pageBody: List.generate(tabBar.length, (index) =>
            Statistics(
              pageIndex: _pageIndex,
              districtId: districtId,
            ),),
        callBack: (val){
          _pageIndex = val;
          setState(() {});
        },
      );
  }

}
