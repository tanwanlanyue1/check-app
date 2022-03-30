import 'package:flutter/material.dart';
import 'package:scet_check/page/module_steward/check/statisticAnaly/components/form_check.dart';
import 'package:scet_check/page/module_steward/law/components/law_components.dart';
import 'package:scet_check/utils/screen/screen.dart';

import 'enterprise_compon.dart';

///排污许可
class PollutionDischarge extends StatefulWidget {
  const PollutionDischarge({Key? key}) : super(key: key);

  @override
  _PollutionDischargeState createState() => _PollutionDischargeState();
}

class _PollutionDischargeState extends State<PollutionDischarge> {
  bool let = true; //排放
  bool monitor = true; //在线监测设备情况
  bool pollute = true; //污染物类型
  List colunms = ['在线监测设备名称','排口编号','监测因子','是否联网'];//表头
  ///表单数据
  List bodyList = [
    {
      'data':[
        {'name':'油烟','type':'报告类型','color':0},
        {'name':'食堂','type':'环评批复日期','color':2},
        {'name':'油烟净化器','type':'净化器','color':1},
        {'name':'是','type':'治理工艺与现场是否一致','color':0},
      ]
    },
    {
      'data':[
        {'name':'分散蓝291：1','type':'报告类型','color':0},
        {'name':'氟氮','type':'环评批复日期','color':2},
        {'name':'good','type':'净化器','color':1},
        {'name':'否','type':'治理工艺与现场是否一致','color':0},
      ]
    },
  ];
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.only(top: 0),
      children: [
        building(),
        monitoringFacility(),
        contaminant(),
      ],
    );
  }

  ///排放口信息
  Widget building(){
    return box(
        vis: let,
        child: FormCheck.dataCard(
            padding: false,
            children: [
              FormCheck.formTitle(
                  '排放口信息',
                  showUp: true,
                  tidy: let,
                  onTaps: (){
                    let = !let;
                    setState(() {});
                  }
              ),
              Container(
                margin: EdgeInsets.only(top: px(12)),
                child: LawComponents.rowTwo(
                    child: Image.asset('lib/assets/icons/other/smog.png'),
                    textChild: Text('DA001-食堂排烟桶',style: TextStyle(color: Color(0xff6089F0),fontSize: sp(28)),)
                ),
              ),
              EnterPriseCompon.itemClassly(bodyList[0]['data']),
              Container(
                margin: EdgeInsets.only(top: px(12)),
                child: LawComponents.rowTwo(
                    child: Image.asset('lib/assets/icons/other/drainWater.png'),
                    textChild: Text('DA001-废水',style: TextStyle(color: Color(0xff6089F0),fontSize: sp(28)),)
                ),
              ),
              EnterPriseCompon.itemClassly(bodyList[1]['data']),
            ]
        ),
        replacement: FormCheck.formTitle(
            '排放口信息',
            showUp: true,
            tidy: let,
            onTaps: (){
              let = !let;
              setState(() {});
            }
        ),
    );
  }

  ///在线监测设备情况
  Widget monitoringFacility(){
    return box(
        vis: monitor,
        child: FormCheck.dataCard(
            padding: false,
            children: [
              FormCheck.formTitle(
                  '在线监测设备情况',
                  showUp: true,
                  tidy: monitor,
                  onTaps: (){
                    monitor = !monitor;
                    setState(() {});
                  }
              ),
              Row(
                children: EnterPriseCompon.topRow(colunms),
              ),
              Column(
                children: EnterPriseCompon.bodyRow(bodyList),
              ),
            ]
        ),
        replacement: FormCheck.formTitle(
            '在线监测设备情况',
            showUp: true,
            tidy: monitor,
            onTaps: (){
              monitor = !monitor;
              setState(() {});
            }
        ),
    );
  }

  ///污染物类型
  Widget contaminant(){
    return box(
        vis: pollute,
        child: FormCheck.dataCard(
            padding: false,
            children: [
              FormCheck.formTitle(
                  '污染物类型',
                  showUp: true,
                  tidy: pollute,
                  onTaps: (){
                    pollute = !pollute;
                    setState(() {});
                  }
              ),
              Column(
                children: type(),
              )
            ]
        ),
      replacement: FormCheck.formTitle(
          '污染物类型',
          showUp: true,
          tidy: pollute,
          onTaps: (){
            pollute = !pollute;
            setState(() {});
          }
      ),
    );
  }

  ///盒子
  Widget box({required bool vis,required Widget child,required Widget replacement}){
    return Container(
      padding: EdgeInsets.only(left: px(24),right: px(24)),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(width: px(2.0),color: Color(0XffE8E8E8)),
        ),
      ),
      child: Visibility(
        visible: vis,
        child: child,
        replacement: SizedBox(
          height: px(78),
          child: replacement,
        ),
      ),
    );
  }

  ///污染物类型循环
  List<Widget> type(){
    List<Widget> itemRow = [];
    for(var i = 0; i < 2; i++){
      itemRow.add(
        Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: px(12)),
              child: LawComponents.rowTwo(
                  child: Image.asset('lib/assets/icons/other/smog.png'),
                  textChild: Text('DA001-废气',style: TextStyle(color: Color(0xff6089F0),fontSize: sp(28)),)
              ),
            ),
            Column(
              children: EnterPriseCompon.type(color: true),
            ),
            // Column(
            //   children: List.generate(2, (index) {
            //     return Column(
            //       children: [
            //         Container(
            //           margin: EdgeInsets.only(top: px(12)),
            //           child: FormCheck.rowItem(
            //               title: '1.硫酸雾',
            //               titleColor: Color(0xff323233),
            //               child: Text('大气污染防治发',style: TextStyle(color: Color(0xff969799 ),fontSize: sp(28)),textAlign: TextAlign.right,)
            //           ),
            //         ),
            //         Container(
            //           padding: EdgeInsets.only(top: px(24),bottom: px(24)),
            //           child: Row(
            //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //             children: List.generate(2, (j) =>
            //                 Expanded(
            //                   child: EnterPriseCompon.classify(
            //                       title:'${bodyList[0]['data'][0]['name']}',
            //                       color: 1,
            //                       type:'排放银子限值'
            //                   ),
            //                 )),
            //           ),
            //           decoration: BoxDecoration(
            //             border: Border(
            //               top: BorderSide(width: px(1.0),color: Color(0XffE8E8E8)),
            //             ),
            //           ),
            //         ),
            //       ],
            //     );
            //   }),
            // ),
          ],
        )
      );
    }
    return itemRow;
  }
}
