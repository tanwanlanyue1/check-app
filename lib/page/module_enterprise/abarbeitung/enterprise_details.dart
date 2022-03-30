import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:scet_check/page/module_steward/check/hiddenParame/components/rectify_components.dart';
import 'package:scet_check/page/module_steward/check/hiddenParame/inventory_page.dart';
import 'package:scet_check/page/module_steward/check/hiddenParame/problem_page.dart';
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
  late TabController _tabController; //TabBar控制器


  @override
  void initState() {
    // TODO: implement initState
    companyId =  jsonDecode(StorageUtil().getString(StorageKey.PersonalData))['companyId'];
    companyName =  jsonDecode(StorageUtil().getString(StorageKey.PersonalData))['company']['name'];
    _tabController = TabController(vsync: this,length: tabBar.length);
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
                  ProblemPage(
                    companyId: companyId,
                    firm: true,
                  ),
                  InventoryPage(
                    companyId: companyId,
                    firm: true,
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
