import 'package:flutter/material.dart';
import 'package:scet_check/api/api.dart';
import 'package:scet_check/api/request.dart';
import 'package:scet_check/page/module_steward/check/statisticAnaly/components/layout_page.dart';
import 'package:scet_check/utils/screen/screen.dart';

import 'Components/client_list_page.dart';

/// 隐患台账
class HiddenParameter extends StatefulWidget {
  const HiddenParameter({Key? key}) : super(key: key);

  @override
  _HiddenParameterState createState() => _HiddenParameterState();
}

class _HiddenParameterState extends State<HiddenParameter> {

  List tabBar = ["全园区","第一片区","第二片区","第三片区"];//头部
  final PageController pagesController = PageController();//页面控制器
  String _companyId = '';//公司id
  String _companyName = '';//公司名称
  List companyList = [];//全部公司数据
  int pageIndex = 0;//下标
  List districtList = [];//片区统计数据
  List districtId = [""];//片区id
  Map<String,dynamic> data = {};//获取企业数据传递的参数

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
  /// district.id:片区id
  void _getCompany() async {
    if(pageIndex != 0){
      data = {
        'size':1000,
        'page':1,
        'district.id': districtList[pageIndex]['id']
      };
    }else{
      data = {};
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
  super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutPage(
      tabBar: tabBar,
      pageBody: List.generate(4, (index) => Column(
        children: [
          Container(
            height: px(24),
            margin: EdgeInsets.only(left:px(20),right: px(20)),
            color: Colors.white,
          ),
          Visibility(
            visible: companyList.isNotEmpty,
            child: Expanded(
              child: ClientListPage(
                companyList: companyList,
                callBack: (id,name){
                  _companyId = id;
                  _companyName = name;
                  Navigator.pushNamed(context, '/hiddenDetails',arguments: {'companyId': _companyId,'companyName': _companyName,});
                  setState(() {});
                },
              ),
            ),
          ),
        ],
      )),
      callBack: (val){
        pageIndex = val;
        _getCompany();
        setState(() {});
      },
    );
  }

}
