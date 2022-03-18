import 'package:flutter/material.dart';
import 'package:scet_check/page/module_steward/check/statisticAnaly/components/form_check.dart';
import 'package:scet_check/utils/screen/screen.dart';

import 'enterprise_compon.dart';

///危险废物
class HazardousWastes extends StatefulWidget {
  const HazardousWastes({Key? key}) : super(key: key);

  @override
  _HazardousWastesState createState() => _HazardousWastesState();
}

class _HazardousWastesState extends State<HazardousWastes> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: ListView(
        padding: EdgeInsets.only(top: 0),
        children: [
          Container(
            color: Colors.white,
            padding: EdgeInsets.all(px(32)),
            child:  Column(
              children: EnterPriseCompon.type(color: true,length: 3),
            ),
            // child: Column(
            //   children: type(),
            // ),
          )
        ],
      ),
    );
  }

  ///污染物类型循环
  ///rowItem: 小标题
  ///classify: 污染物具体数据
  List<Widget> type(){
    List<Widget> itemRow = [];
    for(var i = 0; i < 2; i++){
      itemRow.add(
        Column(
          children: List.generate(2, (index) {
            return Column(
              children: [
                Container(
                  child: FormCheck.rowItem(
                      title: '1.污泥',
                      titleColor: Color(0xff323233),//0xff6089F0
                      child: Text('危废编码：264-012-12',style: TextStyle(color: Color(0xff323233),fontSize: sp(26)),textAlign: TextAlign.right,)
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(bottom: px(12)),
                  height: px(150),
                  child: Row(
                    children: List.generate(3, (i) =>
                      Expanded(
                        child: EnterPriseCompon.classify(
                            title:'否',
                            color: 0,
                            type:'纳入管理计划'
                        ),
                      )),
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(width: px(1.0),color: Color(0XffE8E8E8)),
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      );
    }
    return itemRow;
  }
}
