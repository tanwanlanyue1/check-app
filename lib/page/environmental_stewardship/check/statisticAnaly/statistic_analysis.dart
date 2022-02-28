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
  int _pageIndex = 0;//下标

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
      return LayoutPage(
        tabBar: tabBar,
        pageBody: [
          Statistics(
            pageIndex:_pageIndex,
          ),
          Statistics(
            pageIndex:_pageIndex,
          ),
          Statistics(
            pageIndex:_pageIndex,
          ),
          Statistics(
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
