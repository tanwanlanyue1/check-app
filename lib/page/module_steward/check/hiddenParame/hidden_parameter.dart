import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scet_check/api/api.dart';
import 'package:scet_check/api/request.dart';
import 'package:scet_check/model/provider/provider_details.dart';
import 'package:scet_check/page/module_steward/check/statisticAnaly/components/layout_page.dart';
import 'package:scet_check/page/module_steward/personal/components/task_compon.dart';
import 'package:scet_check/utils/screen/screen.dart';
import 'package:scet_check/utils/storage/data_storage_key.dart';
import 'package:scet_check/utils/storage/storage.dart';

import '../../../../main.dart';
import 'Components/client_list_page.dart';

/// 隐患台账
class HiddenParameter extends StatefulWidget {
  const HiddenParameter({Key? key}) : super(key: key);

  @override
  _HiddenParameterState createState() => _HiddenParameterState();
}

class _HiddenParameterState extends State<HiddenParameter> {

  List tabBar = [];//头部
  String _companyId = '';//公司id
  String _companyName = '';//公司名称
  List companyList = [];//全部公司数据
  int pageIndex = 0;//下标
  List districtList = [];//片区统计数据
  List districtId = [""];//片区id
  Map<String,dynamic> data = {};//获取企业数据传递的参数
  String orgId = '';
  // ProviderDetaild? _roviderDetaild;//全局数据

  /// 获取片区统计
  /// 获取tabbar表头，不在写死,
  /// 片区id也要获取，传递到页面请求片区详情
  void _getStatistics() async {
    var response = await Request().get(Api.url['district']);
    if(response['statusCode'] == 200) {
      tabBar = [];
      tabBar.add('全园区');
      setState(() {
        districtList = response["data"];
        for(var i = 0; i<districtList.length;i++){
          tabBar.add(districtList[i]['name']);
          districtId.add(districtList[i]['id']);
        }
      });
      _getCompany(); // 获取企业数据
    }
  }
  /// 获取企业统计
  /// district.id:片区id,切换请求的片区
  void _getCompany() async {
    if(pageIndex != 0){
      data = {
        'districtId': districtId[pageIndex],
        "sort":["CAST(substring_index(p.number,'-',1) AS SIGNED)","CAST(substring_index(p.number,'-',-1) AS SIGNED)"],
        "order":["ASC","ASC"],
        "parentOrgId":orgId
      };
    }else{
      data = {
        "sort":["CAST(substring_index(p.number,'-',1) AS SIGNED)","CAST(substring_index(p.number,'-',-1) AS SIGNED)"],
        "order":["ASC","ASC"],
        "parentOrgId":orgId
      };
    }
    var response = await Request().get(
        Api.url['companyList'],
        data: data
    );
    if(response['statusCode'] == 200) {
      companyList = response["data"]['list'];
      setState(() {});
    }
  }

@override
  void initState() {
    // TODO: implement initState
  _getStatistics();//获取片区统计
  orgId = jsonDecode(StorageUtil().getString(StorageKey.PersonalData))['orgId'].toString();
  super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
        TaskCompon.topTitle(
          title: '隐患排查',
          colors: Colors.transparent
        ),
          Expanded(
            child: LayoutPage(
              tabBar: tabBar,
              pageName: 'HiddenParameter',
              callBack: (val){
                pageIndex = val;
                _getCompany();
                setState(() {});
              },
              pageBody: List.generate(tabBar.length, (index) => Visibility(
                visible: companyList.isNotEmpty,
                child: ClientListPage(
                  companyList: companyList,
                  sort: true,
                  callBack: (id,name){
                    _companyId = id;
                  _companyName = name;
                  Navigator.pushNamed(context, '/hiddenDetails',arguments: {'companyId': _companyId,'companyName': _companyName,});
                  setState(() {});
                  },
                ),
              ),),
            ),
          ),
        ],
      ),
    );
  }

}