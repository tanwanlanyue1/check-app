import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scet_check/api/api.dart';
import 'package:scet_check/api/request.dart';
import 'package:scet_check/model/provider/provider_details.dart';
import 'package:scet_check/page/environmental_stewardship/check/StatisticAnaly/statistics.dart';
import 'package:scet_check/utils/screen/screen.dart';
import 'package:scet_check/utils/storage/data_storage_key.dart';
import 'package:scet_check/utils/storage/storage.dart';

import 'components/check_compon.dart';


class StatisticAnalysis extends StatefulWidget {
  const StatisticAnalysis({Key? key}) : super(key: key);

  @override
  _StatisticAnalysisState createState() => _StatisticAnalysisState();
}

class _StatisticAnalysisState extends State<StatisticAnalysis> {

  final PageController pagesController = PageController();
  List tabBar = ["园区统计","第一片区","第二片区","第三片区"];
  Map gardenStatistics = {};//统计数据
  int finished = 0;//问题整改
  int questionTotal = 0;//问题总数
  int companyTotal = 0;//企业总数
  int _pageIndex = 0;//下标
  String type = '行业';//排名类型
  ProviderDetaild? _roviderDetaild;
  List tableBody = [];//表单数据
  List allCoum = [];
  int tabIndex = 0;//表单类型

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
      });
      judge();
    }
  }


  // 获取全部公司
  void _getLatestData() async {
    var response = await Request().get(Api.url['all']);
    if(response['code'] == 200) {
      allCoum = response['data'];
      StorageUtil().setString(StorageKey.allCompany,response['data'].toString());
    }
  }

  //遍历全部公司名称
  allFirm<String>(int allId){
    for(var i=0; i<allCoum.length; i++){
      if(allId == allCoum[i]["id"]){
        return allCoum[i]['name'];
      }
    }
  }

  //判断表单的数据 type
  judge(){
    switch (tabIndex){
      case 0: {//行业
        type = '行业';
        setState((){});
        return tableBody = gardenStatistics['rank_industry_total_views'] ?? [];
      }
      case 1: {//片区
        type = '片区';
        setState((){});
        return tableBody = gardenStatistics['rank_area_total_view'] ?? [];
      }
      case 2: {//企业
        type = '企业';
        setState((){});
        return tableBody = gardenStatistics['rank_company_total_views'] ?? [];
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _getStatistics(); // 获取园区统计
    // var res = StorageUtil().getString(StorageKey.allCompany) ?? ''; //取出缓存的公司名称
    pagesController.addListener(() {
      if(pagesController.page != null){
        _roviderDetaild!.setOffest(pagesController.page!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _roviderDetaild = Provider.of<ProviderDetaild>(context, listen: true);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: px(730),
          height: px(74),
          margin: EdgeInsets.only(left:px(20),right: px(18)),
          child:  Stack(
            children: [
              CheckCompon.bagColor(
                pageIndex: _pageIndex,
                offestLeft:_roviderDetaild!.offestLeft,
              ),
              CheckCompon.tabCut(
                  index: _pageIndex,
                  tabBar: tabBar,
                  onTap: (i){
                    _pageIndex = i;
                    pagesController.jumpToPage(i);
                    _getStatistics();
                    setState(() {});
                  }
              ),
            ],
          ),
        ),
        abarbeitung(),
        Expanded(
          child: PageView.builder(
          controller: pagesController,
          itemCount: 4,
          itemBuilder: (context, i) =>
          Statistics(
            tableBody: tableBody,
            type: type,
            callBack: (){
              judge();
              if(tabIndex != 2){
                tabIndex++;
              }else{
                tabIndex = 0;
              }},
            callPrevious: (){
              judge();
              if(tabIndex != 0){
                tabIndex--;
              }else{
                tabIndex = 2;
              }
            },
          ),
          onPageChanged: (val){
            _pageIndex = val;
            _getStatistics();
          },
          )),
      ],
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text.rich(
                      TextSpan(text: '$companyTotal',
                        style: TextStyle(
                            fontSize: sp(40.0),
                            color: Color(0XFF4D7FFF)
                        ),
                        children: <TextSpan>[
                          TextSpan(text: '/家',
                              style: TextStyle(
                                color: Color(0XFF323233),
                                fontSize:sp(20.0),)
                          ),
                        ],
                      ),
                    ),
                    Text('企业总数',style: TextStyle(color: Color(0xff646566), fontSize:sp(20.0),),)
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text.rich(
                      TextSpan(text: '$questionTotal',
                        style: TextStyle(
                            fontSize: sp(40.0),
                            color: Color(0XFFD68184)
                        ),
                        children: <TextSpan>[
                          TextSpan(text: '/个',
                              style: TextStyle(
                                color: Color(0XFF323233),
                                fontSize:sp(20.0),)
                          )
                        ],
                      ),
                    ),
                    Text('排查问题',style: TextStyle(color: Color(0xff646566), fontSize:sp(20.0),),)
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text.rich(
                      TextSpan(text: '$finished',
                        style: TextStyle(
                            fontSize: sp(40.0),
                            color: Color(0XFF95C758)
                        ),
                        children: <TextSpan>[
                          TextSpan(text: '/个',
                              style: TextStyle(
                                color: Color(0XFF323233),
                                fontSize:sp(20.0),)
                          )
                        ],
                      ),
                    ),
                    Text('整改完毕',style: TextStyle(color: Color(0xff646566), fontSize:sp(20.0),),)
                  ],
                ),
              ],
            ),
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

}
