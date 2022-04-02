import 'package:flutter/material.dart';
import 'package:scet_check/api/api.dart';
import 'package:scet_check/api/request.dart';
import 'package:scet_check/page/module_steward/check/hiddenParame/Components/client_list_page.dart';
import 'package:scet_check/page/module_steward/check/statisticAnaly/components/layout_page.dart';
import 'package:scet_check/utils/screen/screen.dart';

///企业管理
class EnterprisePage extends StatefulWidget {
  const EnterprisePage({Key? key}) : super(key: key);

  @override
  _EnterprisePageState createState() => _EnterprisePageState();
}

class _EnterprisePageState extends State<EnterprisePage> {
  List tabBar = [""];//tab
  int pageIndex = 0;//页面下标
  List companyList = [];//公司列表
  List districtId = [""];//片区id
  List districtList = [];//片区统计数据
  Map<String,dynamic> data = {};//获取企业数据传递的参数

  /// 获取企业统计
  /// district.id:片区id
  void _getCompany() async {
    if(pageIndex != 0){
      data = {
        'district.id': districtId[pageIndex]
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
      _getCompany();
    }
  }
  @override
  void initState() {
    super.initState();
    _getStatistics();// 获取片区
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: px(750),
          height: appTopPadding(context),
          color: Color(0xff19191A),
        ),
        Expanded(
          child: LayoutPage(
            tabBar: tabBar,
            callBack: (val){
              pageIndex = val;
              _getCompany();
              setState(() {});
            },
            pageBody: List.generate(tabBar.length, (index) => Visibility(
              visible: companyList.isNotEmpty,
              child: ClientListPage(
                companyList: companyList,
                callBack: (id,name){
                  Navigator.pushNamed(context, '/enterpriseDetails',arguments: {'name':name,"id":id});
                },
              ),
            ),),
          ),
        ),
      ],
    );
  }

}
