import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scet_check/api/api.dart';
import 'package:scet_check/api/request.dart';
import 'package:scet_check/model/provider/provider_details.dart';
import 'package:scet_check/page/module_steward/check/StatisticAnaly/statistics.dart';
import 'package:scet_check/page/module_steward/check/statisticAnaly/components/layout_page.dart';
import 'package:scet_check/utils/screen/screen.dart';

import 'components/check_compon.dart';

///统计分析
class StatisticAnalysis extends StatefulWidget {
  const StatisticAnalysis({Key? key}) : super(key: key);

  @override
  _StatisticAnalysisState createState() => _StatisticAnalysisState();
}

class _StatisticAnalysisState extends State<StatisticAnalysis> {

  final PageController pagesController = PageController();
  List tabBar = [];//表头
  List districtList = [];//片区统计数据
  List districtId = [""];//片区id
  List _tableBody = [];//问题统计数据
  List number = [];//整改数
  int _pageIndex = 0;//下标
  int questionTotal = 0;//问题总数
  int companyTotal = 0;//企业总数
  Map<String,dynamic> _data = {};//获取企业 传递的参数
  Map<String,dynamic> groupTable = {'groupTable':'company'};//统计数据-传递的参数
  String type = '企业';//排名类型
  int _types = 0; //排名类型
  ScrollController controller = ScrollController();
  ScrollController controllerTow = ScrollController();
  ProviderDetaild? _roviderDetaild;
  double off = 0.0;

  @override
  void initState() {
    _getStatistics();
    dealWith();
    pagesController.addListener(() {
      if(pagesController.page != null){
        _roviderDetaild!.setOffest(pagesController.page!);
      }
    });
    controller.addListener(() {
      off = controller.offset;
      controllerTow.jumpTo(off);
    });
    super.initState();
  }
  @override
  void didUpdateWidget(covariant StatisticAnalysis oldWidget) {
    // TODO: implement didUpdateWidget
    _getStatistics();
    dealWith();
    super.didUpdateWidget(oldWidget);
  }
  /// 获取片区统计
  /// 获取tabbar表头，不在写死,
  /// 片区id也要获取，传递到页面请求片区详情
  void _getStatistics() async {
    var response = await Request().get(Api.url['district']);
    if(response['statusCode'] == 200) {
      tabBar = [];
      tabBar.add('园区统计');
      setState(() {
        districtList = response["data"];
        for(var i = 0; i<districtList.length;i++){
          tabBar.add(districtList[i]['name']);
          districtId.add(districtList[i]['id']);
        }
      });
    }
  }

  /// 获取问题数据总数
  void _getProblem() async {
    var response = await Request().get(
      Api.url['problemCount'],
      data: _data
    );
    if(response['statusCode'] == 200) {
      setState(() {
        questionTotal = response['data'];
      });
    }
  }

  /// 获取企业总数
  void _companyCount() async {
    var response = await Request().get(
        Api.url['companyCount'],
        data: _data
    );
    if(response['statusCode'] == 200) {
      setState(() {
        companyTotal = response['data'];
      });
    }
  }

  /// 获取整改数据总数
  /// status:写死的状态
  void _getAbarbeitung() async {
    Map<String,dynamic> _data =  _pageIndex == 0 ?
    {
      'status':'[2,3]',
    } :
    {
      'status':'[2,3]',
      'district.id': districtId[_pageIndex]
    };
    var response = await Request().get(
        Api.url['problemCount'],
        data: _data
    );
    if(response['statusCode'] == 200) {
      setState(() {
        number = [
          {'total':companyTotal,'unit':'家','name':"企业总数"},
          {'total':questionTotal,'unit':'个','name':"排查问题"},
          {'total':response['data'],'unit':'个','name':"整改完毕"},
        ];
      });
    }
  }

  /// 问题统计数据
  void _getProblemStatis({Map<String,dynamic>? data}) async {
    print('data=====$data');
    var response = await Request().get(
        Api.url['problemStatistics'],
        data: data
    );
    if(response['statusCode'] == 200) {
      setState(() {
        _tableBody = response['data'];
      });
    }
  }

  //处理数据
  void dealWith (){
    _data = _pageIndex == 0 ? {} :
    {
      'district.id': districtId[_pageIndex]
    };
    groupTable = _pageIndex == 0 ? {'groupTable':'company'} :
    {
      'district.id': districtId[_pageIndex],
      'groupTable':'company'
    };
    print('groupTable=$groupTable');
    _getProblem();
    _companyCount();
    _getAbarbeitung();
    _getProblemStatis(
        data: groupTable
    );
  }
  ///判断表单的数据
  judge(){
    switch (_types){
      case 0: {
        type = '企业';
        _pageIndex == 0 ?
        _getProblemStatis(
            data: {
              'groupTable':'company',

            }) :
        _getProblemStatis(
            data: {
              'district.id': districtId[_pageIndex],
              'groupTable':'company',

            });
        setState((){});
        return;
      }
      case 1: {
        type = '行业';
        _pageIndex == 0 ?
        _getProblemStatis(
            data: {
              'groupTable':'industry',

            }) :
        _getProblemStatis(
            data: {
              'district.id': districtId[_pageIndex],
              'groupTable':'industry'
            }
        );
        setState((){});
        return;
      }
      case 2: {
        type = '片区';
        _pageIndex == 0 ?
        _getProblemStatis(
            data: {
              'groupTable':'district',

            }) :
        _getProblemStatis(
            data: {
              'district.id': districtId[_pageIndex],
              'groupTable':'district'
            }
        );
        setState((){});
        return;
      }
    }
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
          child: Stack(
            children: [
              ListView(
                scrollDirection: Axis.horizontal,
                controller: controllerTow,
                children: [
                  SizedBox(
                    height: px(88),
                    // width: px(206 * tabBar.length),
                    child: Row(
                      children: [
                        CheckCompon.bagColor(
                          pageIndex: _pageIndex,
                          // offestLeft: _roviderDetaild?.offestLeft,
                          offestLeft: tabBar==0 ?px(206): px(206 * tabBar.length),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              ListView(
                scrollDirection: Axis.horizontal,
                controller: controller,
                children: [
                  CheckCompon.tabCut(
                      index: _pageIndex,
                      tabBar: tabBar,
                      onTap: (i){
                        _pageIndex = i;
                        dealWith();
                        type = '企业';
                        setState(() {});
                        setState(() {});
                      }
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: Statistics(
            pageIndex: _pageIndex,
            number:number,
            type:type,
            tableBody:_tableBody,
            callBack:(val){
              _types = val;
              judge();
            },
          ),
        ),
      ],
    );
  }

}
