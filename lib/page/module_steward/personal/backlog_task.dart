import 'package:flutter/material.dart';
import 'package:scet_check/components/generalduty/no_data.dart';
import 'package:scet_check/utils/screen/screen.dart';

import 'components/task_compon.dart';

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
  String checkPeople = '';//排查人员

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
          TaskCompon.topTitle(
              title: '待办任务',
              home: true,
              colors: Colors.transparent,
              callBack: (){
                Navigator.pop(context);
              }
          ),
          Container(
            height: px(96),
            child: DefaultTabController(
              length: tabBar.length,
              child: Container(
                color: Colors.white,
                margin: EdgeInsets.only(left: px(20),right: px(20)),
                child: TabBar(
                    controller: _tabController,
                    indicatorSize: TabBarIndicatorSize.label,
                    indicatorPadding: EdgeInsets.only(bottom: px(16)),
                    isScrollable: false,
                    labelColor: Color(0xff4D7FFF),
                    labelStyle: TextStyle(fontSize: sp(32.0),fontFamily: 'M'),
                    unselectedLabelColor: Color(0xff646566),
                    unselectedLabelStyle: TextStyle(fontSize: sp(30.0),fontFamily: 'R'),
                    indicatorColor:Color(0xff4D7FFF),
                    indicatorWeight: px(4),
                    tabs: tabBar.map((item) {
                      return Tab(text: '$item');
                    }).toList()
                ),
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
                controller: _tabController,
                children: <Widget>[
                  ListView(
                    padding: EdgeInsets.only(top: 0),
                    children: List.generate(5, (i){
                      return TaskCompon.taskList(
                          i: i,
                          company: {},
                          callBack: (){
                            Navigator.pushNamed(context, '/backTaskDetails');
                          }
                      );
                    }),
                  ),
                  Column(
                    children: [
                      NoData(timeType: true, state: '未获取到数据!')
                    ],
                  ),
                  Column(
                    children: [
                      NoData(timeType: true, state: '未获取到数据!')
                    ],
                  ),
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
                  width: px(40),
                  height: px(40),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(//渐变位置
                        begin: Alignment.topLeft,end: Alignment.bottomRight,
                        stops: const [0.0, 1.0], //[渐变起始点, 渐变结束点]
                        colors: const [Color(0xff9EB9FF), Color(0xff608DFF)]//渐变颜色[始点颜色, 结束颜色]
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                  ),
                  child: Text('${i+1}',style: TextStyle(color: Colors.white,fontSize: sp(28)),),
                ),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: Adapt.screenW()-px(250),
                  ),
                  child: Container(
                    margin: EdgeInsets.only(left: px(16),right: px(12)),
                    child: Text('标题名称/公司名称',style: TextStyle(color: Color(0xff323233),fontSize: sp(30),fontFamily: "M",overflow: TextOverflow.ellipsis),),
                  ),
                ),
                Spacer(),
                Container(
                  width: px(110),
                  height: px(48),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: TaskCompon.firmTaskColor(i),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(px(20)),
                        bottomLeft: Radius.circular(px(20)),
                      )
                  ),//状态；1,未整改;2,已整改;3,整改已通过;4,整改未通过
                  child: Text(TaskCompon.firmTask(i)
                    ,style: TextStyle(color: Colors.white,fontSize: sp(20)),),
                ),
              ],
            ),
            Row(
              children: [
                SizedBox(
                  height: px(32),
                  child: Image.asset('lib/assets/icons/my/group.png'),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: px(16),top: px(16)),
                  child: Text(' 第三片区+排查人员',style: TextStyle(color: Color(0xff969799),fontSize: sp(26),overflow: TextOverflow.ellipsis),),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(
                  height: px(32),
                  width: px(32),
                  child: Image.asset('lib/assets/icons/check/sandClock.png'),
                ),
                Text(' 2022-4-21 12:00',
                  style: TextStyle(color: Color(0xff969799),fontSize: sp(26)),),
              ],
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
