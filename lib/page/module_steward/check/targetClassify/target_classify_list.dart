import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:scet_check/api/api.dart';
import 'package:scet_check/api/request.dart';
import 'package:scet_check/components/generalduty/no_data.dart';
import 'package:scet_check/page/module_steward/check/statisticAnaly/components/form_check.dart';
import 'package:scet_check/page/module_steward/law/components/law_components.dart';
import 'package:scet_check/page/module_steward/personal/components/task_compon.dart';
import 'package:scet_check/utils/easyRefresh/easy_refreshs.dart';
import 'package:scet_check/utils/screen/screen.dart';

import 'easy_refreshs.dart';

///指标列表
///arguments:{id:企业id]
class TargetClassifyList extends StatefulWidget {
  Map? arguments;
  TargetClassifyList({Key? key, this.arguments}) : super(key: key);

  @override
  _TargetClassifyListState createState() => _TargetClassifyListState();
}

class _TargetClassifyListState extends State<TargetClassifyList>
    with SingleTickerProviderStateMixin {
  List tabBar = ["差异性指标","原则性指标",'加分项指标','扣分项指标']; //tab列表
  late TabController _tabController; //TabBar控制器
  String companyName = '';
  int typeStatus = 1;

  @override
  void initState() {
    // TODO: implement initState
    _tabController = TabController(vsync: this, length: tabBar.length);
    companyName = widget.arguments?['name'] ?? '';
    _tabController.addListener(() {
      typeStatus = _tabController.index+1;
      setState(() {});
      print("aaaaaaaaaaaaaaaaaaaaaaaa=$typeStatus");
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TaskCompon.topTitle(
              title: companyName,
              left: true,
              callBack: () {
                Navigator.pop(context);
              }),
          Container(
            height: px(64.0),
            color: Colors.white,
            child: DefaultTabController(
              length: tabBar.length,
              child: TabBar(
                controller: _tabController,
                indicatorSize: TabBarIndicatorSize.label,
                indicatorPadding: EdgeInsets.only(bottom: 5.0),
                isScrollable: true,
                labelColor: Colors.blue,
                labelStyle: TextStyle(fontSize: sp(30.0), fontFamily: 'M'),
                unselectedLabelColor: Color(0xff969799),
                unselectedLabelStyle:
                    TextStyle(fontSize: sp(30.0), fontFamily: 'R'),
                indicatorColor: Colors.blue,
                indicatorWeight: px(2),
                tabs: tabBar.map((item) {
                  return Tab(text: '  $item  ');
                }).toList(),
                onTap: (val) {
                  typeStatus = val + 1;
                  setState(() {});
                },
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: List.generate(tabBar.length, (index) => EasyRefreshs(
                typeStatus: typeStatus,
                callBack: (childData){
                  if(childData['level'] == 3 || childData['level'] == 4){
                    if(childData['level'] == 4){
                      Navigator.pushNamed(context, '/targetDetails', arguments: {
                        "three": false,
                        'id': childData['parentId'],
                        'companyId': widget.arguments?['id'],
                        'companyName': widget.arguments?['name'],
                        'name': tabBar[typeStatus-1],
                        'children': childData['id'],
                      });
                    }else{
                      Navigator.pushNamed(context, '/targetDetails', arguments: {
                        "three": true,
                        'id':childData['id'],
                        'companyId':widget.arguments?['id'],
                        'companyName': widget.arguments?['name'],
                        'name': tabBar[typeStatus-1],
                      });
                    }
                  }else if(childData['children'] == null || childData['children']?.length ==0){
                    Navigator.pushNamed(context, '/targetDetails', arguments: {
                      'id':childData['id'],
                      'companyName': widget.arguments?['name'],
                      'name': tabBar[typeStatus-1],
                    });
                  }
                },
              ))
            ),
          ),
        ],
      ),
    );
  }
}
