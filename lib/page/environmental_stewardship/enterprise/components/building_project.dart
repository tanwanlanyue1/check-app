import 'package:flutter/material.dart';
import 'package:scet_check/components/form_check.dart';
import 'package:scet_check/utils/screen/screen.dart';

import 'enterprise_compon.dart';

class BuildingProject extends StatefulWidget {
  const BuildingProject({Key? key}) : super(key: key);

  @override
  _BuildingProjectState createState() => _BuildingProjectState();
}

class _BuildingProjectState extends State<BuildingProject> {
  List bodyList = [
    {
      'data':[
        {'name':'油烟','type':'污染物种类'},
        {'name':'食堂','type':'产废环节'},
        {'name':'油烟净化器','type':'治理设施及工艺'},
        {'name':'是','type':'治理工艺与现场是否一致'},
        {'name':'颗粒物','type':'污染物种类'},
      ]
    },
    {
      'data':[
        {'name':'分散蓝291：1'},
        {'name':'氟氮'},
        {'name':'doog'},
        {'name':'否'},
      ]
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Material(
      child: ListView(
        padding: EdgeInsets.only(top: 0),
        children: [
          building(),
        ],
      ),
    );
  }

  //建设
  Widget building(){
    return Container(
      padding: EdgeInsets.only(left: px(24),right: px(24)),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(width: px(2.0),color: Color(0XffE8E8E8)),
        ),
      ),
      child: FormCheck.dataCard(
          children: [
            FormCheck.formTitle(
                '建设项目一',
            ),
            Container(
              margin: EdgeInsets.all(px(24)),
              child: Text("环保型高牢度分散燃料、高档高牢度活性燃料及表面活性剂项目",style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),),
            ),
            itemClassly(bodyList[0]['data']),
          ]
      ),
    );
  }

  Widget itemClassly(List data){
    return  Column(
      children: List.generate((data.length/2).ceil(), (j) {
        return Container(
          padding: EdgeInsets.only(top: px(24),bottom: px(24)),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: EnterPriseCompon.classify(
                      title: j+1 < data.length ?'${data[j*2]['name']}' : '${data[j]['name']}',
                      type:'${data[j]['type']}'
                  ),
                ),
                Container(
                  width: px(1),
                  height: px(48),
                  color: Color(0xffE8E8E8),
                ),
                (j*2+1 < data.length) ?
                Expanded(
                  child: EnterPriseCompon.classify(
                    title: j+1 <data.length ?'${data[j*2+1]['name']}' : '${data[j]['name']}',
                    type: j+1 <data.length ?'${data[j+1]['type']}' : '${data[j]['type']}',
                  ),
                ):Expanded(
                  child: Container(),
                ),
              ]
          ),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(width: px(2.0),color: Color(0XffE8E8E8)),
            ),
          ),
        );
      }),
    );
  }
}
