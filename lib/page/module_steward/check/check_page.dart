import 'package:flutter/material.dart';
import 'package:scet_check/page/module_steward/personal/components/task_compon.dart';

import 'StatisticAnaly/statistic_analysis.dart';

///隐患排查
class CheckPage extends StatefulWidget {
  const CheckPage({Key? key}) : super(key: key);

  @override
  _CheckPageState createState() => _CheckPageState();
}

class _CheckPageState extends State<CheckPage> {
  bool show = true;

  //echart返回到有echart页面会闪退，需要先关闭，再返回
  Future<bool> echartPop(){
    setState(() {show = false;});
    return Future.delayed(Duration(milliseconds: 200)).then((onValue) {
      Navigator.pop(context);
      return true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: echartPop,
        child: Scaffold(
          body: Column(
            children: [
              TaskCompon.topTitle(
                  title: '统计分析',
                  home: true,
                  colors: Colors.transparent,
                  callBack: (){
                    echartPop();
                  }
              ),
              Expanded(
                child: show ?
                StatisticAnalysis():
                Container(),
              )
            ],
          ),
        ),
    );
  }

}
