import 'package:flutter/material.dart';
import 'package:scet_check/utils/screen/screen.dart';

import 'enterprise_compon.dart';

///应急预案
class ContingencyPlan extends StatefulWidget {
  const ContingencyPlan({Key? key}) : super(key: key);

  @override
  _ContingencyPlanState createState() => _ContingencyPlanState();
}

class _ContingencyPlanState extends State<ContingencyPlan> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: body(),
    );
  }

///内容
  Widget body(){
    return Container(
      padding: EdgeInsets.only(left: px(32),top: px(32),right: px(32)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('突发环境事件应急预案备案级别',style: TextStyle(color: Color(0xff969799),fontSize: sp(26)),),
          Container(
            margin: EdgeInsets.only(left: px(32),top: px(12),bottom: px(24)),
            child: Text('较大 [较大-大气（Q2-M2-E3）较大-水]',style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),),
          ),
          EnterPriseCompon.surveyItem("备案编号",'大气污染防治发'),
          EnterPriseCompon.surveyItem("备案日期",'2021-4-23'),
          EnterPriseCompon.surveyItem("2021年是否开展应急演练及日期",'2012-4-9'),
          EnterPriseCompon.surveyItem("2021年是否开展应急演练及日期",'2021-6-25'),
        ],
      ),
    );
  }

}
