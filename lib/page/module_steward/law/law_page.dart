import 'package:flutter/material.dart';
import 'package:scet_check/page/module_steward/law/policy_stand.dart';
import 'package:scet_check/utils/screen/screen.dart';

import 'essential_gist.dart';

///法律法规
class LawPage extends StatefulWidget {
  const LawPage({Key? key}) : super(key: key);

  @override
  _LawPageState createState() => _LawPageState();
}

class _LawPageState extends State<LawPage>  with SingleTickerProviderStateMixin{
  List tabBar = ["政策标准规范","排查要点依据"];//tab列表
  late TabController _tabController; //TabBar控制器

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this,length: tabBar.length);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          Expanded(
            child: TabBarView(
                controller: _tabController,
                children: <Widget>[
                  PolicyStand(),//政策标准规范
                  EssentialGist(),//排查要点依据
                ]
            ),
          )
        ],
      ),
    );
  }

  ///头部
  Widget topBar(){
    return Container(
      margin: EdgeInsets.only(top: Adapt.padTopH()),
      color: Colors.white,
      height: px(88),
      child: Row(
        children: [
          Container(
            height: px(40),
            width: px(41),
            margin: EdgeInsets.only(left: px(20)),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Text("标准规范",style: TextStyle(color: Color(0xff323233),fontSize: sp(36),fontFamily: 'M'),),
            ),
          ),
          Container(
            width: px(40),
            height: px(41),
            margin: EdgeInsets.only(right: px(20)),
          ),
        ],
      ),
    );
  }
}
