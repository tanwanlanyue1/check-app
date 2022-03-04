import 'package:flutter/material.dart';
import 'package:scet_check/api/api.dart';
import 'package:scet_check/api/request.dart';
import 'package:scet_check/utils/screen/screen.dart';

import 'Components/same_point_table.dart';

//统计
class Statistics extends StatefulWidget {
  int pageIndex;//当前页面下表
  Statistics({Key? key,required this.pageIndex}) : super(key: key);

  @override
  _StatisticsState createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {

  Map gardenStatistics = {};//总数据
  List _tableBody = [];//表单
  String type = '行业';//排名类型
  int tabIndex = 0;//表单类型
  int finished = 0;//问题整改
  int questionTotal = 0;//问题总数
  int companyTotal = 0;//企业总数
  int _pageIndex = 0;//企业总数
  List number = [];//整改数

  @override
  void initState() {
    super.initState();
    _pageIndex = widget.pageIndex;
    _getStatistics(); // 获取园区统计
    _getcolumns(); // 获取表头
  }

  // 获取园区统计
  void _getStatistics() async {
    Map<String, dynamic> params = _pageIndex == 0 ? {}: {'area':_pageIndex};
    var response = await Request().get(Api.url['statistics'], data: params);
    if(response['code'] == 200) {
      setState(() {
        gardenStatistics = response["data"];
        questionTotal = gardenStatistics['question_total'] ?? 0;
        finished = gardenStatistics['question_finished'] ?? 0;
        companyTotal = gardenStatistics['company_total'] ?? 0;
        number = [
          {'total':companyTotal,'unit':'家','name':"企业总数"},
          {'total':questionTotal,'unit':'个','name':"排查问题"},
          {'total':finished,'unit':'个','name':"整改完毕"},
        ];
      });
      judge();
    }
  }
  // 获取园区统计
  void _getcolumns() async {
    var response = await Request().get(Api.url['columns']);
    if(response['code'] == 200) {
      print(response);
    }
  }

  //判断表单的数据
  judge(){
    switch (tabIndex){
      case 0: {
        type = '行业';
        setState((){});
        return _tableBody = gardenStatistics['rank_industry_total_views'] ?? [];
      }
      case 1: {
        type = '片区';
        setState((){});
        return _tableBody = gardenStatistics['rank_area_total_view'] ?? [];
      }
      case 2: {
        type = '企业';
        setState((){});
        return _tableBody = gardenStatistics['rank_company_total_views'] ?? [];
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: px(12),right: px(12)),
        child: ListView(
        padding: EdgeInsets.only(top: 0),
        children: [
          abarbeitung(),
          SamePointTable(
            tableHeader: type,
            tableBody: _tableBody,
            callBack: (){
              judge();
              if(tabIndex != 2){
                tabIndex++;
              }else {
                tabIndex = 0;
              }
              // widget.callBack?.call();
            },
            callPrevious: (){
              judge();
              if(tabIndex != 0){
                tabIndex--;
              }else{
                tabIndex = 2;
              }
              // widget.callPrevious?.call();
            },
          ),
        ],
      ),
    );
  }

  //整改
  Widget abarbeitung(){
    return Container(
      width: px(710),
      height: px(215),
      color: Colors.white,
      padding: EdgeInsets.only(top: px(25)),
      child: Column(
        children: [
          numberRectification(),
          Expanded(
            child: gardenStatistics.isNotEmpty ?
            Container(
              margin: EdgeInsets.only(left: px(49),right: px(10)),
              child: Row(
                children: [
                  Text('整改率',style: TextStyle(color: Color(0xff323233), fontSize:sp(24.0),),),
                  SizedBox(
                    height: px(100),
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment(0, 0),
                          child: Container(
                            width: px(475),
                            height: px(16),
                            margin: EdgeInsets.only(left: px(18),right: px(16)),
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(184, 197, 230, 0.3),
                              borderRadius: BorderRadius.all(Radius.circular(px(2.0))),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment(0, 0),
                          child: Container(
                            width: px(475*(finished/questionTotal)),
                            height: px(16),
                            margin: EdgeInsets.only(left: px(18),right: px(16)),
                            decoration: BoxDecoration(
                              color: Color(0xff4D7FFF),
                              borderRadius: BorderRadius.all(Radius.circular(px(2.0))),
                            ),
                          ),
                        ),
                        Container(
                          width: px(27),
                          height: px(32),
                          margin: EdgeInsets.only(top: px(11),left: px(475*(finished/questionTotal)+3)),
                          child: Image.asset("lib/assets/icons/other/coordinate.png"),
                        ),
                      ],
                    ),
                  ),
                  Text('${(finished/questionTotal*100).toInt()}%',style: TextStyle(color: Color(0xff336DFF), fontSize:sp(28.0),),),
                ],
              ),
            ):
            Container(),
          ),
        ],
      ),
    );
  }

  //整改数
  Widget numberRectification(){
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(number.length, (i) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text.rich(
                TextSpan(text: '${number[i]['total']}',
                  style: TextStyle(
                      fontSize: sp(40.0),
                      color: i == 0 ?
                      Color(0XFF4D7FFF):
                      i == 1 ?
                      Color(0XFFD68184):
                      Color(0XFF95C758)
                  ),
                  children: <TextSpan>[
                    TextSpan(text: '/${number[i]['unit']}',
                        style: TextStyle(
                          color: Color(0XFF323233),
                          fontSize:sp(20.0),)
                    ),
                  ],
                ),
              ),
              Text('${number[i]['name']}',style: TextStyle(color: Color(0xff646566), fontSize:sp(20.0),),)
            ],
          );
        }
        )
    );
  }
}