import 'package:flutter/material.dart';
import 'package:scet_check/page/module_steward/check/hiddenParame/components/rectify_components.dart';
import 'package:scet_check/utils/screen/screen.dart';

///待办任务
///arguments:{'name':用户名,'id':用户id}
class BacklogTask extends StatefulWidget {
  Map? arguments;
  BacklogTask({Key? key,this.arguments}) : super(key: key);

  @override
  _BacklogTaskState createState() => _BacklogTaskState();
}

class _BacklogTaskState extends State<BacklogTask> with SingleTickerProviderStateMixin{
  List tabBar = ["现场检查","表格填报",'其他专项'];//tab列表
  late TabController _tabController; //TabBar控制器

  @override
  void initState() {
    // TODO: implement initState
    _tabController = TabController(vsync: this,length: tabBar.length);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: px(750),
            height: appTopPadding(context),
            color: Color(0xff19191A),
          ),
          RectifyComponents.topBar(
              title: '待办任务',
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
                  ListView(
                    children: List.generate(5, (i){
                      return taskList(i);
                    }),
                  ),
                  Container(),
                  Container(),
                ]
            ),
          ),
        ],
      ),
    );
  }
  ///任务列表
  Widget taskList(int i){
    return Container(
      margin: EdgeInsets.only(top: px(24),left: px(20),right: px(24)),
      padding: EdgeInsets.only(left: px(24),top: px(20),bottom: px(20)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(px(8.0))),
      ),
      child: InkWell(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  child: Text('${i+1}.标题名称/公司名称',style: TextStyle(color: Color(0xff323233),fontSize: sp(30),overflow: TextOverflow.ellipsis),),
                )
              ],
            ),
            Container(
              child: Text('副标题+排查人员',style: TextStyle(color: Color(0xff969799),fontSize: sp(26),overflow: TextOverflow.ellipsis),),
            ),
            Container(
              width: px(140),
              height: px(48),
              child: Text('2022-4-21',
                style: TextStyle(color: Color(0xff969799),fontSize: sp(24)),),
            ),
            Container(
              width: px(140),
              height: px(48),
              child: Text('处理中',
                style: TextStyle(color: Color(0xff969799),fontSize: sp(24)),),
            ),
          ],
        ),
        onTap: (){
          Navigator.pushNamed(context, '/backTaskDetails');
        },
      ),
    );
  }
}
