import 'package:flutter/material.dart';
import 'package:scet_check/utils/screen/screen.dart';
import 'package:scet_check/utils/time/utc_tolocal.dart';

///任务组件
class TaskCompon{

  ///title:标题
  ///left:左按钮
  ///home：首页按钮
  ///colors:背景色
  ///callBack:回调
  ///font:字体
  ///child:右侧组件
  static Widget topTitle({required String title,bool left = false,bool home = false,Color? colors,Widget? child,Function? callBack,double? font}){
    return Column(
      children: [
        Container(
          width: px(750),
          height: Adapt.padTopH(),
          color: Color(0xff19191A),
        ),
        Container(
          color: colors ?? Colors.white,
          height: px(88),
          child: Row(
            children: [
              InkWell(
                child: Visibility(
                  visible: left == false && home== false,
                  child: Container(),
                  replacement: Container(
                    height: px(88),
                    width: px(55),
                    color: Colors.transparent,
                    padding: EdgeInsets.only(left: px(12)),
                    margin: EdgeInsets.only(left: px(12)),
                    child: left ? Image.asset('lib/assets/icons/other/chevronLeft.png',):
                    (home ? Image.asset('lib/assets/icons/my/backHome.png',):
                    Text('')),
                  ),
                ),
                onTap: (){
                  if(left || home){
                    callBack?.call();
                  }
                },
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(left: child !=null ? px(56) : 0),
                  child: Text(title,style: TextStyle(color: Color(0xff323233),fontSize: sp(font ?? 36),fontFamily: 'M'),),
                ),
              ),
              Container(
                child: child,
              ),
            ],
          ),
        ),
      ],
    );
  }

  ///任务列表
  static Widget taskList({required int i,required Map company,Function? callBack}){
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
                    child: Text('${company['company']?['name'] ?? ''}',style: TextStyle(color: Color(0xff323233),fontSize: sp(30),fontFamily: "M",overflow: TextOverflow.ellipsis),),
                  ),
                ),
                Spacer(),
                Container(
                  width: px(110),
                  height: px(48),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: TaskCompon.fromStatusColor(company['status']),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(px(20)),
                        bottomLeft: Radius.circular(px(20)),
                      )
                  ),
                  child: Text(TaskCompon.fromStatus(company['status'])
                    ,style: TextStyle(color: Colors.white,fontSize: sp(22)),),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(bottom: px(16),top: px(24)),
              child: Row(
                children: [
                  SizedBox(
                    height: px(32),
                    child: Image.asset('lib/assets/icons/my/otherArea.png'),
                  ),
                  Text(
                    company['district'].length > 0 ?
                    ' ${company['district'][0]?['name']}' : '',style: TextStyle(color: Color(0xff969799),fontSize: sp(26),fontFamily: 'R'),),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: px(16)),
              child: Row(
                children: [
                  SizedBox(
                    height: px(32),
                    child: Image.asset('lib/assets/icons/my/group.png'),
                  ),
                  Expanded(
                    child: Text(checkPeople(people: company['checkUserList']),style: TextStyle(color: Color(0xff969799),fontSize: sp(26),overflow: TextOverflow.ellipsis),),
                  ),
                ],
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(
                  height: px(32),
                  width: px(32),
                  child: Image.asset('lib/assets/icons/check/sandClock.png'),
                ),
                Text(formatTime(company['createdAt']),
                  style: TextStyle(color: Color(0xff969799),fontSize: sp(26)),),
              ],
            ),
          ],
        ),
        onTap: (){
          callBack?.call(company['id']);
        },
      ),
    );
  }

  ///处理排查人员
  static String checkPeople({required List people}){
    String checkList = '';
    for(var i = 0; i < people.length; i++){
      if(i > 0){
        checkList = checkList + ',' + people[i]['nickname'];
      }else{
        checkList = people[i]['nickname'];
      }
    }
    return checkList;
  }

  //对接的任务状态 	任务状态（1：待派发，2：已派发，3：已驳回 4: 未提交 5：执行中）1-5：待整改 6-7:已完成
  static String firmTask(status){
    switch(status){
      case 1 : return '待派发';
      case 2 : return '已派发';
      case 3 : return '已驳回';
      case 4 : return '未提交';
      case 5 : return '执行中';
      case 6 : return '待审核';
      case 7 : return '已完成';
      default: return '待处理';
    }
  }

  //对接的任务颜色状态
  static Color firmTaskColor(status){
    switch(status){
      case 1 : return Color(0xfffaaa5a);
      case 2 : return Color(0xff7196F5);
      case 3 : return Colors.red;
      case 4 : return Color(0xfffaaa5a);
      case 5 : return Color(0xff7196F5);
      case 6 : return Color(0xfffaaa5a);
      case 7 : return Color(0xff95C758);
      default: return Color(0xffFAAA5A);
    }
  }

  //任务状态 	任务状态（1：未处理，2：处理中）
  static String fromStatus(status){
    switch(status){
      case 1 : return '待处理';
      case 2 : return '已完成';
      default: return '待处理';
    }
  }
  //任务颜色
  static Color fromStatusColor(status){
    switch(status){
      case 1 : return Color(0xffFAAA5A);
      case 2 : return Color(0xff7196F5);
      default: return Color(0xffFAAA5A);
    }
  }
  ///按钮
  static Widget revocation({String? title,Color? color,Function? onTops}){
    return Container(
      height: px(88),
      margin: EdgeInsets.only(top: px(24)),
      color: color ?? Colors.transparent,
      alignment: Alignment.center,
      child: GestureDetector(
        child: Container(
          width: px(240),
          height: px(56),
          alignment: Alignment.center,
          margin: EdgeInsets.only(left: px(40)),
          child: Text(
            title ?? '提交',
            style: TextStyle(
                fontSize: sp(24),
                fontFamily: "M",
                color: Color(0xff4D7FFF)),
          ),
          decoration: BoxDecoration(
            border: Border.all(width: px(2),color: Color(0xff4D7FFF)),
            borderRadius: BorderRadius.all(Radius.circular(px(28))),
          ),
        ),
        onTap: () {
          onTops?.call();
        },
      ),
    );
  }

  ///时间格式
  ///time:时间
  static String formatTime(time) {
    return utcToLocal(time.toString()).substring(0,16);
  }
}