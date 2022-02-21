import 'package:flutter/material.dart';
import 'package:scet_check/api/api.dart';
import 'package:scet_check/api/request.dart';
import 'package:scet_check/page/environmental_stewardship/check/StatisticAnaly/statistics.dart';
import 'package:scet_check/page/environmental_stewardship/check/statisticAnaly/components/layout_page.dart';


class StatisticAnalysis extends StatefulWidget {
  const StatisticAnalysis({Key? key}) : super(key: key);

  @override
  _StatisticAnalysisState createState() => _StatisticAnalysisState();
}

class _StatisticAnalysisState extends State<StatisticAnalysis> {

  final PageController pagesController = PageController();
  List tabBar = ["园区统计","第一片区","第二片区","第三片区"];
  Map gardenStatistics = {};//统计数据
  int _pageIndex = 0;//下标

  // 获取园区统计
  void _getStatistics() async {
    Map<String, dynamic> params = _pageIndex == 0 ? {}: {'area':_pageIndex};
    var response = await Request().get(Api.url['statistics'], data: params);
    if(response['code'] == 200) {
      setState(() {
        gardenStatistics = response["data"];
        // questionTotal = gardenStatistics['question_total'] ?? 0;
        // finished = gardenStatistics['question_finished'] ?? 0;
        // companyTotal = gardenStatistics['company_total'] ?? 0;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // _getStatistics(); // 获取园区统计
  }

  @override
  Widget build(BuildContext context) {
      return LayoutPage(
        tabBar: tabBar,
        pageBody: [
          Statistics(
            tableBody: gardenStatistics,
            pageIndex:_pageIndex,
          ),
          Statistics(
            tableBody: gardenStatistics,
            pageIndex:_pageIndex,
          ),
          Statistics(
            tableBody: gardenStatistics,
            pageIndex:_pageIndex,
          ),
          Statistics(
            tableBody: gardenStatistics,
            pageIndex:_pageIndex,
          ),
        ],
        callBack: (val){
          _pageIndex = val;
          setState(() {});
        },
      );
  }

}
