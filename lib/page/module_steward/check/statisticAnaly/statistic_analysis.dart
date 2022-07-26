import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scet_check/api/api.dart';
import 'package:scet_check/api/request.dart';
import 'package:scet_check/main.dart';
import 'package:scet_check/model/provider/provider_details.dart';
import 'package:scet_check/page/module_steward/check/StatisticAnaly/statistics.dart';
import 'package:scet_check/utils/screen/screen.dart';

import 'components/check_compon.dart';
import 'components/layout_page.dart';

///统计分析
class StatisticAnalysis extends StatefulWidget {
  const StatisticAnalysis({Key? key}) : super(key: key);

  @override
  _StatisticAnalysisState createState() => _StatisticAnalysisState();
}

class _StatisticAnalysisState extends State<StatisticAnalysis> with RouteAware{

  List tabBar = [];//表头
  List districtList = [];//片区统计数据
  List problemType = [];//问题类型统计数据
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
  ProviderDetaild? _roviderDetaild;//全局数据
  double off = 0.0;//偏移量

  @override
  void initState() {
    _getStatistics();
    dealWith();
    controller.addListener(() {
      off = controller.offset;
      controllerTow.jumpTo(off);
      _roviderDetaild!.setOffest(double.parse(_pageIndex.toString()));
    });
    super.initState();
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

  /// 获取问题数据总数,查询全部问题的数量，不分状态
  void _getProblem() async {
    var response = await Request().get(
      Api.url['problemCount'],
      data: _data
    );
    if(response['statusCode'] == 200) {
      questionTotal = response['data'];
      _companyCount();
    }
  }

  /// 获取企业总数
  void _companyCount() async {
    var response = await Request().get(
        Api.url['companyCount'],
        data: _data
    );
    if(response['statusCode'] == 200) {
      companyTotal = response['data'];
      _getAbarbeitung();
    }
  }

  /// 获取整改数据总数
  /// status:写死的状态 2,3 已整改，整改已通过
  void _getAbarbeitung() async {
    Map<String,dynamic> _data =  _pageIndex == 0 ?
    {
      'status':'[2,3]',
    } :
    {
      'status':'[2,3]',
      'districtId': districtId[_pageIndex]
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

  /// 问题统计数据/ 问题类型统计数据
  void _getProblemStatis({Map<String,dynamic>? data,bool type = false}) async {
    var response = await Request().get(
        Api.url['problemStatistics'],
        data: data
    );
    if(response['statusCode'] == 200) {
      setState(() {
        if(type){
          problemType = response['data']['list'];
        }else{
          _tableBody = response['data']['list'];
        }
      });
    }
  }
  /// 按照行业统计数目
  void _getIndustryStatistics({Map<String,dynamic>? data}) async {
    var response = await Request().get(
        Api.url['statistics'],
        data: data
    );
    if(response['statusCode'] == 200) {
      setState(() {
        _tableBody = response['data']['list'];
      });
    }
  }

  ///处理数据
  ///判断是哪一个片区进来的，
  ///_pageIndex 0=统计片区
  ///如果是统计片区，则不传片区id，只需要传递查询的类型
  ///默认第一次查询企业类型-company
  void dealWith (){
    // 获取问题数据总数,查询全部问题的数量，不分状态
    _data = _pageIndex == 0 ? {} :
    { 'districtId': districtId[_pageIndex] };
    //查询全部片区下的企业问题信息统计
    groupTable = _pageIndex == 0 ? {'groupTable':'company'} :
    {
      'districtId': districtId[_pageIndex],
      'groupTable':'company'
    };
    _getProblem();
    _getProblemStatis(
        data: groupTable
    );
    //问题类型，根据片区进行分开统计———扇形图表数据来源
    Map<String,dynamic> typeData = _pageIndex == 0 ? {'groupTable':'problemTypeParentId'} :
    { 'districtId': districtId[_pageIndex],'groupTable':'problemTypeParentId'};
    _getProblemStatis(
      data: typeData,
      type: true
    );
  }

  ///判断表单的数据
  ///判断切换的类型和片区
  judge(){
    Map<String, dynamic> data = {};
    switch (_types){
      case 0: {
        type = '企业';
        data =  _pageIndex == 0 ?
       {'groupTable':'company',} :
       {
          'districtId': districtId[_pageIndex],
          'groupTable':'company',
       };
        _getProblemStatis(data: data);
        setState((){});
        return;
      }
      case 1: {
        type = '行业';
        data =  _pageIndex == 0 ?
        {} :
        {
          'problems.districtId': districtId[_pageIndex],
        };
        _getIndustryStatistics(data:data);
        setState((){});
        return;
      }
      case 2: {
        type = '片区';
        data =  _pageIndex == 0 ?
        {'groupTable':'district',} :
        {
          'districtId': districtId[_pageIndex],
          'groupTable':'district',
        };
        _getProblemStatis(data: data);
        setState((){});
        return;
      }
    }
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    ///监听路由
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  //清除偏移量
  @override
  void didPop() {
    // TODO: implement didPop
    _roviderDetaild!.initOffest();
    super.didPop();
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
                    width: px(206 * tabBar.length),
                    child: Row(
                      children: [
                        CheckCompon.bagColor(
                          offestLeft: _roviderDetaild?.offestLeft,
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
                        _types = 0;
                        _roviderDetaild!.setOffest(double.parse(_pageIndex.toString()));
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
            problemType:problemType,
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
