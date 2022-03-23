import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:scet_check/api/api.dart';
import 'package:scet_check/api/request.dart';
import 'package:scet_check/components/generalduty/date_range.dart';
import 'package:scet_check/components/generalduty/down_input.dart';
import 'package:scet_check/components/generalduty/search.dart';
import 'package:scet_check/components/generalduty/toast_widget.dart';
import 'package:scet_check/page/module_login/login_page.dart';
import 'package:scet_check/page/module_steward/check/hiddenParame/components/drop_down_menu_route.dart';
import 'package:scet_check/page/module_steward/check/hiddenParame/components/rectify_components.dart';
import 'package:scet_check/routers/router_animate/router_animate.dart';
import 'package:scet_check/utils/screen/screen.dart';
import 'package:scet_check/utils/storage/data_storage_key.dart';
import 'package:scet_check/utils/storage/storage.dart';

///企业详情
/// 问题未整改列表/清单下的问题
class EnterpriseDetails extends StatefulWidget {
  const EnterpriseDetails({Key? key}) : super(key: key);

  @override
  _EnterpriseDetailsState createState() => _EnterpriseDetailsState();
}

class _EnterpriseDetailsState extends State<EnterpriseDetails>  with SingleTickerProviderStateMixin{
  List tabBar = ["隐患问题","排查清单"];//tab列表
  String companyName = '';//公司名
  String companyId = '';//公司id
  bool check = false; //申报,排查
  List companyDetails = [];//公司问题详情
  List inventoryDetails = [];//公司清单列表
  late TabController _tabController; //TabBar控制器
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();//侧边栏key
  String condition = ''; //条件查询
  List status = [];//状态
  List problemStatus = [
    {'name':'未整改','id':1},
    {'name':'已整改','id':2},
    {'name':'整改已通过','id':3},
    {'name':'整改未通过','id':4},
  ]; //问题的状态
  List inventoryStatus = [
    {'name':'整改中','id':1},
    {'name':'已归档','id':2},
    {'name':'待审核','id':3},
    {'name':'审核已通过','id':4},
    {'name':'审核未通过','id':5},
    {'name':'未提交','id':6},
  ]; //清单的状态
  Map<String,dynamic> typeStatus = {'name':'请选择','id':0};//默认类型
  int selectIndex = 0; //选择的下标
  DateTime? startTime;//选择开始时间
  DateTime? endTime;//选择结束时间
  /// 获取企业下的问题
  ///companyId:公司id
  ///page:第几页
  ///size:每页多大
  ///andWhere:查询的条件
  void _getProblem() async {
    Map<String,dynamic> data = {
      'company.id':companyId,
    };
    var response = await Request().get(Api.url['problemList'],data: data,);
    if(response['statusCode'] == 200 && response['data'] != null) {
      setState(() {
        companyDetails = [];
        for(var i=0;i<response['data']['list'].length;i++){
          if(response['data']['list'][i]['isCompanyRead'] == true){
            companyDetails.add(response['data']['list'][i]);
          }
        }
      });
    }
  }

  /// 获取企业下的清单 沧州临港凯茵
  ///companyId:公司id
  ///page:第几页
  ///size:每页多大
  ///andWhere:查询的条件
  void _getInventoryList() async {
    Map<String,dynamic> data = {
      'company.id':companyId,
    };
    var response = await Request().get(Api.url['inventoryList'],data: data,);
    if(response['statusCode'] == 200 && response['data'] != null) {
      setState(() {
        inventoryDetails = response['data']['list'];
      });
    }
  }
  /// 问题搜索筛选
  ///name:搜索名
  ///query:搜索的字段
  void _problemSearch({Map<String,dynamic>? data}) async {
    companyDetails = [];
    var response = await Request().get(Api.url['problemList'],data: data,);
    if(response['statusCode'] == 200 && response['data'] != null) {
      setState(() {
        for(var i=0;i<response['data']['list'].length;i++){
          if(response['data']['list'][i]['isCompanyRead'] == true){
            companyDetails.add(response['data']['list'][i]);
          }
        }
      });
    }
  }
  /// 清单搜索筛选
  ///name:搜索名
  ///query:搜索的字段
  void _inventorySearch({Map<String,dynamic>? data}) async {
    var response = await Request().get(Api.url['inventoryList'],data: data,);
    if(response['statusCode'] == 200 && response['data'] != null) {
      setState(() {
        inventoryDetails = response['data']['list'];
      });
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    companyId =  jsonDecode(StorageUtil().getString(StorageKey.PersonalData))['companyId'];
    companyName =  jsonDecode(StorageUtil().getString(StorageKey.PersonalData))['company']['name'];
    _tabController = TabController(vsync: this,length: tabBar.length);
    status = problemStatus;
    _getProblem();
    _getInventoryList();
    _tabController.addListener(() {
      if(_tabController.index == 0){
        status = problemStatus;
      }else{
        status = inventoryStatus;
      }
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Column(
        children: [
          topBar(),
          Container(
            height: px(64.0),
            color: Colors.white,
            child: DefaultTabController(
              length: tabBar.length,
              child: TabBar(
                  controller: _tabController,
                  indicatorSize: TabBarIndicatorSize.label,
                  indicatorPadding: EdgeInsets.only(bottom: 5.0),
                  isScrollable: false,
                  labelColor: Colors.blue,
                  labelStyle: TextStyle(fontSize: sp(30.0),fontFamily: 'M'),
                  unselectedLabelColor: Color(0xff969799),
                  unselectedLabelStyle: TextStyle(fontSize: sp(30.0),fontFamily: 'R'),
                  indicatorColor:Colors.blue,
                  indicatorWeight: px(2),
                  tabs: tabBar.map((item) {
                    return Tab(text: '  $item  ');
                  }).toList()
              ),
            ),
          ),
          Search(
            bgColor: Color(0xffffffff),
            textFieldColor: Color(0xFFF0F1F5),
            search: (value) {
              condition = value;
              if(_tabController.index == 0){
                _problemSearch(data: {
                  'regexp':true,//近似搜索
                  'detail': condition,
                  'company.id':companyId,
                });
              }else{
                _inventorySearch(
                    data: {
                      'regexp':true,//近似搜索
                      'detail': condition,
                      'company.id':companyId,
                    }
                );
              }

            },
            screen: (){
              _scaffoldKey.currentState!.openEndDrawer();
            },
          ),
          Expanded(
            child: TabBarView(
                controller: _tabController,
                children: <Widget>[
                  ListView(
                    padding: EdgeInsets.only(top: 0),
                    children: List.generate(companyDetails.length, (i) => RectifyComponents.rectifyRow(
                        company: companyDetails[i],
                        i: i,
                        detail: true,
                        review: false,
                        callBack:(){
                          Navigator.pushNamed(context, '/abarbeitungFrom',arguments: {'id':companyDetails[i]['id']});
                        }
                    )),
                  ),//问题列表
                  ListView(
                    padding: EdgeInsets.only(top: 0),
                    children: List.generate(inventoryDetails.length, (i) => RectifyComponents.repertoireRow(
                        company: inventoryDetails[i],
                        i: i,
                        callBack:(){
                          Navigator.pushNamed(context, '/enterprisInventory',
                              arguments: {'uuid':inventoryDetails[i]['id'],'company':false});
                        }
                    )),
                  ), // 排查清单
                ]
            ),
          ),
        ],
      ),
      endDrawer: endDrawers(),
    );
  }

  ///头部
  ///筛选
  ///companyDetails要清空并重新赋值
  Widget topBar(){
    return Container(
      color: Colors.white,
      height: px(88),
      margin: EdgeInsets.only(top: Adapt.padTopH()),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Center(
              child: Text(companyName,style: TextStyle(color: Color(0xff323233),fontSize: sp(30),fontFamily: 'M'),),
            ),
          ),
        ],
      ),
    );
  }
  ///抽屉
  Widget endDrawers(){
    return Container(
      width: px(600),
      color: Color(0xFFFFFFFF),
      padding: EdgeInsets.only(left: px(20), right: px(20),bottom: px(50)),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: Adapt.padTopH()),
            child: Row(
              mainAxisAlignment:MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '问题搜索',
                  style: TextStyle(fontSize: sp(30),color: Color(0xFF2E2F33),fontFamily:"M"),
                ),
                IconButton(
                  icon: Icon(Icons.clear,color: Colors.red,size: px(39),),
                  onPressed: (){Navigator.pop(context);},
                )
              ],
            ),
          ),
          Row(
            children: [
              Container(
                height: px(72),
                width: px(140),
                alignment: Alignment.bottomLeft,
                child: Text('状态：',style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: px(20), right: px(20)),
                  child: DownInput(
                    value: typeStatus['name'],
                    data: status,
                    callback: (val){
                      typeStatus['name'] = val['name'];
                      typeStatus['id'] = val['id'];
                      setState(() {});
                    },
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                height: px(72),
                width: px(140),
                alignment: Alignment.bottomCenter,
                child: Text('起止时间：',style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),),
              ),
              Expanded(
                child: Container(
                  height: px(72),
                  width: px(580),
                  color: Colors.white,
                  margin: EdgeInsets.only(top: px(24),left: px(24),right: px(24)),
                  child:DateRange(
                    start: startTime ?? DateTime.now(),
                    end: endTime ?? DateTime.now(),
                    showTime: false,
                    callBack: (val) {
                      startTime = val[0];
                      endTime = val[1];
                      setState(() { });
                    },
                  ),
                ),
              ),
            ],
          ),

          Spacer(),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  child: Container(
                    alignment: Alignment.center,
                    color: Color(0xffE6EAF5),
                    height: px(56),
                    padding: EdgeInsets.only(left: px(49),right: px(49)),
                    child: Text('取消',style: TextStyle(color: Color(0xff4D7FFF),fontSize: sp(24)),),
                  ),
                  onTap: (){
                    Navigator.pop(context);
                  },
                ),
              ),
              Expanded(
                child: InkWell(
                  child: Container(
                    color: Color(0xff4D7FFF),
                    height: px(56),
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(left: px(49),right: px(49)),
                    child: Text('确定',style: TextStyle(color: Colors.white,fontSize: sp(24)),),
                  ),
                  onTap: (){
                    if(startTime==null){
                      if(_tabController.index == 0){
                        _problemSearch(
                            data: {
                              'status':typeStatus['id'],
                              'company.id':companyId,
                            }
                        );
                      }else{
                        _inventorySearch(
                            data: {
                              'status':typeStatus['id'],
                              'company.id':companyId,
                            }
                        );
                      }
                    }
                    else{
                      if(_tabController.index == 0){
                        _problemSearch(
                            data: {
                              'status':typeStatus['id'],
                              'company.id':companyId,
                              'timeSearch':'createdAt',
                              'startTime': startTime,
                              'endTime': endTime,
                            }
                        );
                      }else{
                        _inventorySearch(
                            data: {
                              'status':typeStatus['id'],
                              'company.id':companyId,
                              'timeSearch':'createdAt',
                              'startTime':startTime,
                              'endTime':endTime,
                            }
                        );
                      }
                    }
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
