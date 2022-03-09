import 'package:flutter/material.dart';
import 'package:scet_check/components/form_check.dart';
import 'package:scet_check/page/environmental_stewardship/law/components/law_components.dart';
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
            child: Column(
              children: type(),
            ),
          )
        ],
      ),
    );
  }


  ///污染物类型循环
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
                      titleColor: Color(0xff323233),
                      child: Text('危废编码：264-012-12',style: TextStyle(color: Color(0xff323233),fontSize: sp(26)),textAlign: TextAlign.right,)
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(bottom: px(12)),
                  height: px(150),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: EnterPriseCompon.classify(
                              title:'否',
                              color: 0,
                              type:'纳入管理计划'
                          ),
                        ),
                        Container(
                          width: px(1),
                          height: px(48),
                          color: Color(0xffE8E8E8),
                        ),
                        Expanded(
                          child: EnterPriseCompon.classify(
                              title:'是',
                              color: 2,
                              type:'纳入排污许可'
                          ),
                        ),
                        Expanded(
                          child: EnterPriseCompon.classify(
                            title:'20',
                            type: '排污许可量(t/a)',
                          ),
                        ),
                      ]
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
