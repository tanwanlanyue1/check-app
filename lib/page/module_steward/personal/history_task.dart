import 'package:flutter/material.dart';
import 'package:scet_check/components/generalduty/date_range.dart';
import 'package:scet_check/page/module_steward/check/hiddenParame/components/rectify_components.dart';
import 'package:scet_check/utils/screen/screen.dart';

///历史台账
///arguments:{'name':用户名,'id':用户id}
class HistoryTask extends StatefulWidget {
  Map? arguments;
  HistoryTask({Key? key,this.arguments}) : super(key: key);

  @override
  _HistoryTaskState createState() => _HistoryTaskState();
}

class _HistoryTaskState extends State<HistoryTask> {
  String userName = '';//用户名
  DateTime startTime = DateTime.now();//选择开始时间
  DateTime endTime = DateTime.now();//选择结束时间
  List historyList = [];//历史任务列表

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
              title: '历史台账',
              callBack: (){
                Navigator.pop(context);
              }
          ),
          selectTime(),
          Column(
            children: List.generate(5, (i){
              return taskList(i);
            }),
          )
        ],
      ),
    );
  }

  ///日期选择
  Widget selectTime(){
    return Container(
      margin: EdgeInsets.only(left: px(24),top: px(24),right: px(24)),
      padding: EdgeInsets.only(bottom: px(12),left: px(12),top: px(12)),
      color: Colors.white,
      child: Row(
        children: [
          Container(
            width: px(140),
            alignment: Alignment.bottomCenter,
            child: Text('选择日期：',style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),),
          ),
          Expanded(
            child: Container(
              width: px(580),
              margin: EdgeInsets.only(left: px(24),right: px(24)),
              child: DateRange(
                start: startTime,
                end: endTime,
                showTime: false,
                callBack: (val) {
                  print(val);
                },
              ),
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
      padding: EdgeInsets.only(left: px(16),top: px(20),bottom: px(20)),
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
                  margin: EdgeInsets.only(left: px(16),right: px(12)),
                  child: Text('${i+1}.标题名称/公司名称',style: TextStyle(color: Color(0xff323233),fontSize: sp(30),overflow: TextOverflow.ellipsis),),
                )
              ],
            ),
            Container(
              margin: EdgeInsets.only(left: px(16),right: px(12)),
              child: Text('副标题+排查人员',style: TextStyle(color: Color(0xff969799),fontSize: sp(26),overflow: TextOverflow.ellipsis),),
            ),
            Container(
              width: px(140),
              height: px(48),
              alignment: Alignment.center,
              child: Text('2022-4-21',
                style: TextStyle(color: Color(0xff969799),fontSize: sp(24)),),
            ),
          ],
        ),
        onTap: (){},
      ),
    );
  }
}
