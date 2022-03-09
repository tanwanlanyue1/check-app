import 'package:flutter/material.dart';
import 'package:scet_check/components/form_check.dart';
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
  List colunms = ['在线监测设备名称','排口编号','监测因子','是否联网'];//表头
  ///表单数据
  List bodyList = [
    {
      'data':[
        {'name':'油烟'},
        {'name':'食堂'},
        {'name':'右眼净化器'},
        {'name':'是'},
      ]
    },
    {
      'data':[
        {'name':'分散蓝291：1'},
        {'name':'氟氮'},
        {'name':'good'},
        {'name':'否'},
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
              '排放口信息',
              showUp: true,
              tidy: true,
              onTaps: (){}
            ),
            Container(
              margin: EdgeInsets.only(top: px(12)),
              child: LawComponents.rowTwo(
                  child: Image.asset('lib/assets/icons/other/smog.png'),
                  textChild: Text('DA001-食堂排烟桶',style: TextStyle(color: Color(0xff6089F0),fontSize: sp(28)),)
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: px(24)),
              child: Container(
                padding: EdgeInsets.only(top: px(24),bottom: px(24)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: EnterPriseCompon.classify(
                          title:'报告书',
                          type:'报告类型'
                      ),
                    ),
                    Container(
                      width: px(1),
                      height: px(48),
                      color: Color(0xffE8E8E8),
                    ),
                    Expanded(
                      child: EnterPriseCompon.classify(
                          title:'2019-2-21',
                          type:'环评批复日期',
                          color: 2
                      ),
                    ),
                  ],
                ),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(width: px(2.0),color: Color(0XffE8E8E8)),
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: px(24),bottom: px(24)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: EnterPriseCompon.classify(
                        title:'生活废水、循环系统排水、生产同意'*3,
                        type:'投产时间'
                    ),
                  ),
                  Container(
                    width: px(1),
                    height: px(48),
                    color: Color(0xffE8E8E8),
                  ),
                  Expanded(
                    child: EnterPriseCompon.classify(
                        title:'未验收',
                        type: '验收时间',
                        color: 0
                    ),
                  ),
                ],
              ),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(width: px(2.0),color: Color(0XffE8E8E8)),
                ),
              ),
            ),

            Container(
              margin: EdgeInsets.only(top: px(12)),
              child: LawComponents.rowTwo(
                  child: Image.asset('lib/assets/icons/other/drainWater.png'),
                  textChild: Text('DA001-废水',style: TextStyle(color: Color(0xff6089F0),fontSize: sp(28)),)
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: px(24)),
              child: Container(
                padding: EdgeInsets.only(top: px(24),bottom: px(24)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: EnterPriseCompon.classify(
                          title:'报告书',
                          type:'报告类型'
                      ),
                    ),
                    Container(
                      width: px(1),
                      height: px(48),
                      color: Color(0xffE8E8E8),
                    ),
                    Expanded(
                      child: EnterPriseCompon.classify(
                          title:'2019-2-21',
                          type:'环评批复日期',
                          color: 2
                      ),
                    ),
                  ],
                ),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(width: px(2.0),color: Color(0XffE8E8E8)),
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: px(24),bottom: px(24)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: EnterPriseCompon.classify(
                        title:'生活废水、循环系统排水、生产同意'*3,
                        type:'投产时间'
                    ),
                  ),
                  Container(
                    width: px(1),
                    height: px(48),
                    color: Color(0xffE8E8E8),
                  ),
                  Expanded(
                    child: EnterPriseCompon.classify(
                        title:'未验收',
                        type: '验收时间',
                        color: 0
                    ),
                  ),
                ],
              ),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(width: px(2.0),color: Color(0XffE8E8E8)),
                ),
              ),
            ),
          ]
      ),
    );
  }

  ///在线监测设备情况
  Widget monitoringFacility(){
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
                '在线监测设备情况',
                showUp: true,
                tidy: true,
                onTaps: (){}
            ),
            Row(
              children: EnterPriseCompon.topRow(colunms),
            ),
            Column(
              children: EnterPriseCompon.bodyRow(bodyList),
            ),
          ]
      ),
    );
  }

  ///污染物类型
  Widget contaminant(){
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
                '污染物类型',
                showUp: true,
                tidy: false,
                onTaps: (){}
            ),
            Column(
              children: type(),
            )
          ]
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
              children: List.generate(2, (index) {
                return Column(
                  children: [
                    Container(
                      child: FormCheck.rowItem(
                          title: '1.硫酸雾',
                          titleColor: Color(0xff323233),
                          child: Text('大气污染防治发',style: TextStyle(color: Color(0xff969799 ),fontSize: sp(28)),textAlign: TextAlign.right,)
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: px(24),bottom: px(24)),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: EnterPriseCompon.classify(
                                  title:'${bodyList[0]['data'][0]['name']}',
                                  type:'排放银子限值'
                              ),
                            ),
                            Container(
                              width: px(1),
                              height: px(48),
                              color: Color(0xffE8E8E8),
                            ),
                            Expanded(
                              child: EnterPriseCompon.classify(
                                title:'/',
                                type: '总量控制(t/a)',
                              ),
                            ),
                          ]
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(width: px(2.0),color: Color(0XffE8E8E8)),
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ),
          ],
        )
      );
    }
    return itemRow;
  }
}
