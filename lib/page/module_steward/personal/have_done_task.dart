import 'package:flutter/material.dart';
import 'package:scet_check/page/module_steward/check/hiddenParame/components/rectify_components.dart';
import 'package:scet_check/utils/screen/screen.dart';

class HaveDoneTask extends StatefulWidget {
  Map? arguments;
  HaveDoneTask({Key? key,this.arguments}) : super(key: key);

  @override
  _HaveDoneTaskState createState() => _HaveDoneTaskState();
}

class _HaveDoneTaskState extends State<HaveDoneTask> {
  String userName = '';//用户名
  DateTime startTime = DateTime.now();//选择开始时间
  DateTime endTime = DateTime.now();//选择结束时间
  List haveDoneList = [];//已办任务

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
              title: '已办任务',
              callBack: (){
                Navigator.pop(context);
              }
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.only(top: 0),
              children: List.generate(5, (i){
                return taskList(i);
              }),
            ),
          )
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
          Navigator.pushNamed(context, '/taskDetails');
        },
      ),
    );
  }

}
