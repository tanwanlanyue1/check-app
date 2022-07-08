import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scet_check/api/api.dart';
import 'package:scet_check/api/request.dart';
import 'package:scet_check/main.dart';
import 'package:scet_check/model/provider/provider_details.dart';
import 'package:scet_check/page/module_steward/check/hiddenParame/Components/client_list_page.dart';
import 'package:scet_check/page/module_steward/check/statisticAnaly/components/layout_page.dart';
import 'package:scet_check/page/module_steward/personal/components/task_compon.dart';
import 'package:scet_check/utils/screen/screen.dart';

///企业管理
///arguments:{'history':true,"task":任务，“name”:发布任务}历史台账进入
class EnterprisePage extends StatefulWidget {
  final Map? arguments;
  const EnterprisePage({Key? key,this.arguments}) : super(key: key);

  @override
  _EnterprisePageState createState() => _EnterprisePageState();
}

class _EnterprisePageState extends State<EnterprisePage> with RouteAware{
  List tabBar = [""];//tab
  int pageIndex = 0;//页面下标
  List companyList = [];//公司列表
  List districtId = [];//片区id
  List districtList = [];//片区统计数据
  Map<String,dynamic> data = {};//获取企业数据传递的参数
  ProviderDetaild? _roviderDetaild;//全局数据
  String name = "一企一档";

  /// 获取企业统计
  /// district.id:片区id
  void _getCompany() async {
    if(pageIndex != 0){
      data = {
        "districtId": districtId[pageIndex-1],
        // "sort":["CAST(substring_index(number,'-',1) AS SIGNED)","CAST(substring_index(number,'-',-1) AS SIGNED)"],
        // "order":["ASC","ASC"],
      };
    }else{
      data = {
        // "sort":["CAST(substring_index(number,'-',1) AS SIGNED)","CAST(substring_index(number,'-',-1) AS SIGNED)"],
        // "order":["ASC","ASC"],
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
    name = widget.arguments?['name'] ?? name;
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
    return Scaffold(
      body: Column(
        children: [
          TaskCompon.topTitle(
              title: name,
              left: widget.arguments?['task'] ?? false,
              home: widget.arguments?['history'] ?? false,
              colors: widget.arguments?['history'] ?? false ? Colors.transparent : Colors.white,
              child: (widget.arguments?['task'] ?? false) ?
              GestureDetector(
                child: Container(
                  height: px(56),
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(right: px(12)),
                  child: Text(
                    '提交',
                    style: TextStyle(
                        fontSize: sp(28),
                        fontFamily: "R",
                        color: Color(0xff323233)),
                  ),
                ),
                onTap: (){
                  Navigator.pop(context,true);
                },
              ) : Container(),
              callBack: (){
                Navigator.pop(context);
              }
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
                  sort: true,
                  select: widget.arguments?['task'] ?? false,
                  callBack: (id,name,user){
                    if(widget.arguments?['history'] ?? false){
                      Navigator.pushNamed(context, '/historyTask',arguments: {'name':name,"id":id});
                    }else if(widget.arguments?['task'] ?? false){
                      Navigator.pop(context,{'name':name,"id":id,"user":user});
                    }else{
                      Navigator.pushNamed(context, '/enterpriseDetails',arguments: {'name':name,"id":id});
                    }
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
