import 'package:flutter/material.dart';
import 'package:scet_check/components/pertinence/companyEchart/column_echarts.dart';
import 'package:scet_check/page/module_steward/personal/components/task_compon.dart';

import 'StatisticAnaly/statistic_analysis.dart';

///隐患排查
class CheckPage extends StatefulWidget {
  const CheckPage({Key? key}) : super(key: key);

  @override
  _CheckPageState createState() => _CheckPageState();
}

class _CheckPageState extends State<CheckPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TaskCompon.topTitle(
              title: '统计分析',
              home: true,
              colors: Colors.transparent,
              callBack: (){
                Navigator.pop(context);
              }
          ),
          Expanded(
            child: StatisticAnalysis(),
          )

        ],
      ),
    );
  }

}
