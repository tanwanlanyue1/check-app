import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:scet_check/api/api.dart';
import 'package:scet_check/api/request.dart';
import 'package:scet_check/components/generalduty/date_range.dart';
import 'package:scet_check/components/generalduty/down_input.dart';
import 'package:scet_check/components/generalduty/search.dart';
import 'package:scet_check/components/generalduty/toast_widget.dart';
import 'package:scet_check/page/module_enterprise/abarbeitung/problem_firm.dart';
import 'package:scet_check/page/module_login/login_page.dart';
import 'package:scet_check/page/module_steward/check/hiddenParame/components/drop_down_menu_route.dart';
import 'package:scet_check/page/module_steward/check/hiddenParame/components/rectify_components.dart';
import 'package:scet_check/routers/router_animate/router_animate.dart';
import 'package:scet_check/utils/screen/adapter.dart';
import 'package:scet_check/utils/screen/screen.dart';
import 'package:scet_check/utils/storage/data_storage_key.dart';
import 'package:scet_check/utils/storage/storage.dart';

import 'inventory_firm.dart';

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

  @override
  void initState() {
    // TODO: implement initState
    companyId =  jsonDecode(StorageUtil().getString(StorageKey.PersonalData))['companyId'];
    companyName =  jsonDecode(StorageUtil().getString(StorageKey.PersonalData))['company']['name'];
    _tabController = TabController(vsync: this,length: tabBar.length);
    _getProblem();
    _getInventoryList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: RectifyComponents.appBars(
        name: companyName,
        leading: Container()
      ),
      body: Column(
        children: [
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
          Expanded(
            child: TabBarView(
                controller: _tabController,
                children: <Widget>[
                  ProblemFirm(
                    hiddenProblem: companyDetails,
                    companyId: companyId,
                  ),//问题列表
                  InventoryFirm(
                    hiddenInventory: inventoryDetails,
                    companyId: companyId,
                  ),// 排查清单
                ]
            ),
          ),
        ],
      ),
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
}
