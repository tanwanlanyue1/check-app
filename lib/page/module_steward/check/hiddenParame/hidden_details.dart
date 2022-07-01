import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scet_check/page/module_steward/check/hiddenParame/problem_page.dart';
import 'package:scet_check/page/module_steward/personal/components/task_compon.dart';
import 'package:scet_check/utils/screen/screen.dart';
import 'inventory_page.dart';

///隐患台账企业排查清单
///arguments:{companyId:公司id，companyName：公司名称 }
class HiddenDetails extends StatefulWidget {
  Map? arguments;
  HiddenDetails({Key? key,this.arguments,}) : super(key: key);

  @override
  _HiddenDetailsState createState() => _HiddenDetailsState();
}

class _HiddenDetailsState extends State<HiddenDetails>  with SingleTickerProviderStateMixin{
  List tabBar = ["隐患问题","问题台账"];//tab列表
  List imgDetails = []; //上传图片
  String companyName = '';//公司名
  String companyId = '';//公司id
  late TabController _tabController; //TabBar控制器

  @override
  void initState() {
    // TODO: implement initState
    companyName = widget.arguments?['companyName'] ?? '';
    companyId = widget.arguments?['companyId'].toString() ?? '';
    _tabController = TabController(vsync: this,length: tabBar.length);
    super.initState();
  }

  ///请空已选的数据
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TaskCompon.topTitle(
              title: companyName,
              left: true,
              font: 28,
              callBack: (){
                Navigator.pop(context);
              }
          ),
          Container(
            height: px(64.0),
            color: Colors.white,
            child: DefaultTabController(
              length: tabBar.length,
              child: TabBar(
                  controller: _tabController,
                  indicatorSize: TabBarIndicatorSize.label,
                  indicatorPadding: EdgeInsets.only(bottom: 5.0,),
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
                    firm: false,
                  ),
                  InventoryPage(
                    companyId: companyId,
                    firm: false,
                  ),// 排查清单
                ]
            ),
          ),
        ],
      ),
    );
  }
}
