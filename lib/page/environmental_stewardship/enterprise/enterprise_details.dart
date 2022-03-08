import 'package:flutter/material.dart';
import 'package:scet_check/page/environmental_stewardship/check/hiddenParame/components/rectify_components.dart';
import 'package:scet_check/utils/screen/screen.dart';

import 'components/basic_information.dart';
import 'components/building_project.dart';
import 'components/contingency_plan.dart';
import 'components/hazardous_wastes.dart';
import 'components/pollution_discharge.dart';

///企业管理详情
class EnterpriseDetails extends StatefulWidget {
  Map? arguments;
  EnterpriseDetails({Key? key,this.arguments}) : super(key: key);

  @override
  _EnterpriseDetailsState createState() => _EnterpriseDetailsState();
}

class _EnterpriseDetailsState extends State<EnterpriseDetails> {
  List tabBar = ["企业基本信息","建设项目情况",'排污许可情况','危险废物','应急预案']; //tab标题
  PageController pagesController = PageController(); //page控制器
  final ScrollController _tabScrController = ScrollController(); //tab控制器
  int pageIndex = 0; //下标

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          RectifyComponents.topBar(
            title: '北京私立安药业有限公司',
            callBack: (){
              Navigator.pop(context);
            }
        ),
          tabCut(),
          Expanded(
            child: PageView(
              controller: pagesController,
              children: [
                BasicInformation(),///基本信息
                BuildingProject(),///建设项目情况
                PollutionDischarge(),///排污许可
                HazardousWastes(),///危险废物
                ContingencyPlan(),///应急预案
              ],
              onPageChanged: (i) async{
                pageIndex = i;
                _tabScrController.jumpTo(px(100)*(pageIndex+1));
                setState(() {});
              },
            ),
          ),
        ],
      ),
    );
  }
  //头部切换
  Widget tabCut() {
    return Column(
      children: [
        Container(
          width: px(750),
          height: px(68),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(width: px(1.0),color: Color(0X99A1A6B3))),
          ),
          child: ListView(
            scrollDirection: Axis.horizontal,
            controller: _tabScrController,
            children: List.generate(tabBar.length, (i) {
              return GestureDetector(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: px(26), right: px(20)),
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "${tabBar[i]}",
                          style: TextStyle(
                              color: pageIndex == i ?
                              Color(0xff4D7FFF) :
                              Colors.grey,
                              fontSize: sp(30),fontFamily: 'M'),),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: px(20)),
                      color: Color(0xff4D7FFF),
                      width: px(48),
                      height: pageIndex == i ? px(4) : 0,
                    ),
                  ],
                ),
                onTap: () {
                  pageIndex = i;
                  pagesController.jumpToPage(i);
                },
              );
            }),
          ),
        ),
      ],
    );
  }
}
