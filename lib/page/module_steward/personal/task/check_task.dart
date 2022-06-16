import 'package:flutter/material.dart';
import 'package:scet_check/utils/screen/screen.dart';

import '../components/task_compon.dart';

///选择任务列表
///arguments:{'name':用户名,'id':用户id}
class CheckTask extends StatefulWidget {
  Map? arguments;
  CheckTask({Key? key,this.arguments}) : super(key: key);

  @override
  _CheckTaskState createState() => _CheckTaskState();
}

class _CheckTaskState extends State<CheckTask> {
  String checkPeople = '';//排查人员

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: px(750),
            height: Adapt.padTopH(),
            color: Color(0xff19191A),
          ),
          SizedBox(
            height: px(88),
            child: Row(
              children: [
                InkWell(
                  child: Container(
                    height: px(88),
                    width: px(55),
                    color: Colors.transparent,
                    padding: EdgeInsets.only(left: px(12)),
                    margin: EdgeInsets.only(left: px(12)),
                    child: Image.asset('lib/assets/icons/other/chevronLeft.png',),
                  ),
                  onTap: (){
                    Navigator.pop(context);
                  },
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(right: px(55)),
                    child: Text('选择任务',style: TextStyle(color: Color(0xff323233),fontSize: sp(36),fontFamily: 'M'),),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.only(top: 0),
              children: List.generate(5, (i){
                return TaskCompon.taskList(
                    i: i,
                    company: {},
                    callBack: (){
                      Navigator.pushNamed(context, '/backTaskDetails',arguments: {'check':true});
                    }
                );
              }),
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
      ),
    );
  }

}
