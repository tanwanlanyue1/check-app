import 'package:flutter/material.dart';
import 'package:scet_check/api/api.dart';
import 'package:scet_check/api/request.dart';
import 'package:scet_check/utils/screen/screen.dart';

import 'Components/same_point_table.dart';

///统计
///pageIndex:当前页面下表
///districtId:园区id
class Statistics extends StatefulWidget {
  int pageIndex;
  List? districtId;
  Statistics({Key? key,required this.pageIndex,this.districtId}) : super(key: key);

  @override
  _StatisticsState createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {

  String _districtId = '';//片区id
  String type = '企业';//排名类型

  Map gardenStatistics = {};//总数据
  List districtList = [];//片区统计数据
  List _tableBody = [];//表单
  int tabIndex = 0;//表单类型
  int finished = 0;//问题整改
  int questionTotal = 0;//问题总数
  int companyTotal = 0;//企业总数
  int _pageIndex = 0;//企业总数
  int _types = 0;//类型的下标
  List number = [];//整改数
  List columns = [];//表头
  Map<String,dynamic> data = {
    'groupTable':'industry',
  };//获取问题统计数目传递的参数
  @override
  void initState() {
    super.initState();
    _pageIndex = widget.pageIndex;
    _districtId = widget.districtId?[_pageIndex] ?? '';
    if(mounted){
      _getProblem();//获取问题数据总数
      _companyCount();//获取企业总数
      _getAbarbeitung();// 获取整改数据总数
      _getStatistics(data: {
        'groupTable':'industry',
      });
      judge();
    }
  }

  @override
  void didUpdateWidget(covariant Statistics oldWidget) {
    _pageIndex = widget.pageIndex;
    _districtId = widget.districtId?[_pageIndex] ?? '';
    if(mounted){
      _getProblem();//获取问题数据总数
      _companyCount();//获取企业总数
      _getAbarbeitung();// 获取整改数据总数
      // _getStatistics();// 获取问题统计数目
      judge();
    }
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }

  /// 获取问题统计数目
  void _getStatistics({Map<String,dynamic>? data}) async {
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
  /// 获取问题数据总数
  void _getProblem() async {
    var response = await Request().get(
        Api.url['problemCount'],
    );
    if(response['statusCode'] == 200) {
      setState(() {
        questionTotal = response['data'];
      });
    }
  }

  /// 获取企业总数
  void _companyCount() async {
    Map<String,dynamic> _data =  _districtId.isEmpty ? {} :
    {
    'district.id': _districtId
    };
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
    Map<String,dynamic> _data =  _districtId.isEmpty ?
    {
      'status':'[2,3]',
    } :
    {
      'status':'[2,3]',
      'district.id': _districtId
    };
    var response = await Request().get(
        Api.url['problemCount'],
        data: _data
    );
    if(response['statusCode'] == 200) {
      setState(() {
        finished = response['data'];
        number = [
          {'total':companyTotal,'unit':'家','name':"企业总数"},
          {'total':questionTotal,'unit':'个','name':"排查问题"},
          {'total':finished,'unit':'个','name':"整改完毕"},
        ];
      });
    }
  }

  ///判断表单的数据
  judge(){
    switch (_types){
      case 0: {
        type = '行业';
        if(_districtId.isNotEmpty){
          data =  {
            'groupTable':'industry',
            'district.id': _districtId
          };
        }else{
          data =   {
            'groupTable':'industry',
          };
        }
        setState((){});
        _getStatistics(data: data);
        return;
      }
      case 1: {
        type = '片区';
        if(_districtId.isNotEmpty){
          data =   {
            'groupTable':'district',
            'district.id': _districtId
          };
        }else{
          data =   {
            'groupTable':'district',
          };
        }
        setState((){});
        _getStatistics(data: data);
        return;
      }
      case 2: {
        type = '企业';
        if(_districtId.isNotEmpty){
          data =   {
            'groupTable':'company',
            'district.id': _districtId
          };
        }else{
          data =   {
            'groupTable':'company',
          };
        }
        setState((){});
        _getStatistics(data: data);
        return;
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
            tableHeader: columns,
            tableTitle: type,
            tableBody: _tableBody,
            callBack: (){
              if(tabIndex != 2){
                tabIndex++;
                _types++;
              }else {
                tabIndex = 0;
                _types = 0;
              }
              judge();
            },
            callPrevious: (){
              if(tabIndex != 0){
                tabIndex--;
                _types--;
              }else{
                tabIndex = 2;
                _types = 2;
              }
              judge();
            },
          ),
        ],
      ),
    );
  }

  ///整改
  Widget abarbeitung(){
    return Container(
      width: px(710),
      height: px(215),
      color: Colors.white,
      padding: EdgeInsets.only(top: px(25)),
      child: Column(
        children: [
          numberRectification(),
          _tableBody.isNotEmpty ?
          Expanded(
            child: Container(
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
            ),
          ) : Container(),
        ],
      ),
    );
  }

  ///整改数
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