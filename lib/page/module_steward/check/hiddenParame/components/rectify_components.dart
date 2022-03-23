import 'package:flutter/material.dart';
import 'package:scet_check/utils/screen/screen.dart';
import 'package:scet_check/utils/time/utc_tolocal.dart';

//整改插件
class RectifyComponents{

  ///问题表单
  /// company:每一项数据
  /// i:第i项
  /// detail:详情使用，序号为圆
  /// review:复查记录是否开启
  /// callBack:回调
 static  Widget rectifyRow({required Map company,required int i,bool detail = false,bool review = false,Function? callBack}){
   return Container(
     margin: EdgeInsets.only(top: px(20),left: px(20),right: px(20)),
     padding: EdgeInsets.only(left: px(16),top: px(20),bottom: px(20)),
     decoration: BoxDecoration(
       color: Colors.white,
       borderRadius: BorderRadius.all(Radius.circular(px(4.0))),
     ),
     child: InkWell(
       child: Column(
         children: [
           Row(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               Visibility(
                 visible: !detail,
                 child: Text(i < 9 ? '0${i+1}':'$i',style: TextStyle(color: Color(0xff4D7FFF),fontSize: sp(28)),),
                 replacement: Container(
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
               ),
               ConstrainedBox(
                 constraints: BoxConstraints(
                   maxWidth: Adapt.screenW()-px(250),
                 ),
                 child: Container(
                   margin: EdgeInsets.only(left: px(16),right: px(12)),
                   child: Text('${company["detail"]}',style: TextStyle(color: Color(0xff323233),fontSize: sp(30),overflow: TextOverflow.ellipsis),),
                 ),
               ),
               Container(
                 alignment: Alignment.topLeft,
                 height: px(32),
                 width: px(32),
                 margin: EdgeInsets.only(top: px(8)),
                 child: company['isImportant'] ?? false ? Image.asset('lib/assets/icons/form/star.png') : Text(''),
               ),
               Spacer(),
               Container(
                 width: px(110),
                 height: px(48),
                 alignment: Alignment.center,
                 decoration: BoxDecoration(
                     color: Colorswitchs(company["status"]),
                     borderRadius: BorderRadius.only(
                       topLeft: Radius.circular(px(20)),
                       bottomLeft: Radius.circular(px(20)),
                     )
                 ),//状态；1,未整改;2,已整改;3,整改已通过;4,整改未通过
                 child: Text(switchs(company["status"])
                   ,style: TextStyle(color: Colors.white,fontSize: sp(20)),),
               ),
             ],
           ),
           Container(
             margin: EdgeInsets.only(top: px(20)),
             child: Row(
               crossAxisAlignment: CrossAxisAlignment.start,
               mainAxisAlignment: MainAxisAlignment.start,
               children: [
                 Container(
                   height: px(18),
                   width: px(18),
                   margin: EdgeInsets.only(left: px(12)),
                   child: Icon(Icons.widgets_outlined,color: Color(0xffC8C9CC),size: 18,),
                 ),
                 Container(
                   margin: EdgeInsets.only(left: px(30),right: px(50)),
                   child: Text('${company["problemType"]?['name']}',style: TextStyle(color: Color(0xff969799),fontSize: sp(24)),),
                 ),
                 SizedBox(
                   height: px(32),
                   width: px(32),
                   child: Image.asset('lib/assets/icons/check/sandClock.png'),//problem.png
                 ),
                 Container(
                   margin: EdgeInsets.only(left: px(24),right: px(80)),
                   child: Text(formatTime(company["createdAt"]),style: TextStyle(color: Color(0xff969799),fontSize: sp(24)),),
                 ),
                 SizedBox(
                   height: px(32),
                   width: px(32),
                   child: Image.asset('lib/assets/icons/check/sandClockEnd.png'),
                 ),
                 Container(
                   margin: EdgeInsets.only(left: px(12)),
                   child: Text(formatTime(company['updatedAt']),style: TextStyle(color: Color(0xff969799),fontSize: sp(24)),),
                 ),
               ],
             ),
           ),
           Visibility(
             visible: review,
             child: Container(
               margin: EdgeInsets.only(top: px(20)),
               child: Row(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 mainAxisAlignment: MainAxisAlignment.start,
                 children: [
                   Container(
                     height: px(32),
                     width: px(32),
                     margin: EdgeInsets.only(left: px(12)),
                     child: Image.asset('lib/assets/icons/form/alter.png',fit: BoxFit.fill,),
                   ),
                   Container(
                     margin: EdgeInsets.only(left: px(11)),
                     child: Text('添加复查记录',style: TextStyle(color: Color(0xff4D7FFF),fontSize: sp(24)),),
                   ),
                 ],
               ),
             ),
           )
         ],
       ),
       onTap: (){
         callBack?.call();
       },
     ),
   );
 }

 ///清单表单列表
 /// company:每一项数据
 /// i:第i项
 /// callBack:回调
 static  Widget repertoireRow({required Map company,required int i,Function? callBack}){
   return Container(
     margin: EdgeInsets.only(top: px(20),left: px(20),right: px(20)),
     padding: EdgeInsets.only(left: px(16),top: px(20),bottom: px(20)),
     decoration: BoxDecoration(
       color: Colors.white,
       borderRadius: BorderRadius.all(Radius.circular(px(4.0))),
     ),
     child: InkWell(
       child: Column(
         children: [
           Row(
             crossAxisAlignment: CrossAxisAlignment.start,
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
                   child: FittedBox(
                     fit: BoxFit.scaleDown, //不让自己调放大，可以缩小
                     child: Text(formatTime(company['updatedAt']),style: TextStyle(color: Color(0xff323233),fontSize: sp(30)),),
                   ),
                 ),
               ),
               Container(
                 alignment: Alignment.topLeft,
                 height: px(32),
                 width: px(32),
                 margin: EdgeInsets.only(top: px(8)),
                 child: (company['isImportant'] ?? false) ? Image.asset('lib/assets/icons/form/star.png') : Text(''),
               ),
               Spacer(),
               Container(
                 width: px(110),
                 height: px(48),
                 alignment: Alignment.center,
                 decoration: BoxDecoration(
                     color: Colorswitchs(company["status"]),
                     borderRadius: BorderRadius.only(
                       topLeft: Radius.circular(px(20)),
                       bottomLeft: Radius.circular(px(20)),
                     )
                 ),//状态；1,整改中;2,已归档;3,待审核;4,审核已通过;5,审核未通过;6,未提交;
                 child: Text(inventory(company["status"])
                   ,style: TextStyle(color: Colors.white,fontSize: sp(20)),),
               ),
             ],
           ),
           Container(
             margin: EdgeInsets.only(top: px(20)),
             child: Row(
               crossAxisAlignment: CrossAxisAlignment.start,
               mainAxisAlignment: MainAxisAlignment.start,
               children: [
                 Container(
                   margin: EdgeInsets.only(left: px(12)),
                   child: Text('排查人',style: TextStyle(color: Color(0xff969799),fontSize: sp(24))),
                 ),
                 Container(
                   margin: EdgeInsets.only(left: px(24),right: px(20)),
                   child: Text('${company["checkPersonnel"]}',style: TextStyle(color: Color(0xff969799),fontSize: sp(24)),),
                 ),
                 Visibility(
                   visible: company["isImportant"] ?? false,
                   child: SizedBox(
                     height: px(32),
                     width: px(32),
                     child: Image.asset('lib/assets/icons/check/sandClock.png'),//problem.png
                   ),
                 ),
                 Container(
                   margin: EdgeInsets.only(left: px(24),right: px(80)),
                   child: Text(formatTime(company["createdAt"]),style: TextStyle(color: Color(0xff969799),fontSize: sp(24)),),
                 ),
                 SizedBox(
                   height: px(32),
                   width: px(32),
                   child: Image.asset('lib/assets/icons/check/sandClockEnd.png'),
                 ),
                 Container(
                   margin: EdgeInsets.only(left: px(12)),
                   child: Text(formatTime(company['updatedAt']),style: TextStyle(color: Color(0xff969799),fontSize: sp(24)),),
                 ),
               ],
             ),
           ),
         ],
       ),
       onTap: (){
         callBack?.call();
       },
     ),
   );
 }

//颜色状态
 static Color Colorswitchs(status){
    switch(status){
      case 1 : return Color(0xffFAAA5A);
      case 2 : return Color(0xff7196F5);
      case 3 : return Color(0xff95C758);
      case 4 : return Color(0xffFAAA5A);
      default: return Color(0xffFAAA5A);
    }
  }
  //状态
  static String switchs(status){
    switch(status){
      case 1 : return '未整改';
      case 2 : return '整改中';
      case 3 : return '整改已通过';
      case 4 : return '整改未通过';
      default: return '未整改';
    }
  }
  //清单状态 1,整改中;2,已归档;3,待审核;4,审核已通过;5,审核未通过;6,未提交;
  static String inventory(status){
    switch(status){
      case 1 : return '整改中';
      case 2 : return '已归档';
      case 3 : return '待审核';
      case 4 : return '审核已通过';
      case 5 : return '审核未通过';
      case 6 : return '未提交';
      default: return '未整改';
    }
  }
 ///头部
 /// title :标题名
 /// left :左侧按钮/图标
 /// right :右侧按钮/图标
 /// callBack :回调
 /// left/right: true-展示，false-隐藏，
 static Widget topBar({String? title,bool left = true,bool right = false,Function? callBack}){
   return Container(
     color: Colors.white,
     height: px(88),
     margin: EdgeInsets.only(top: Adapt.padTopH()),
     child: Row(
       children: [
         InkWell(
           child: Container(
             height: px(40),
             width: px(41),
             margin: EdgeInsets.only(left: px(20)),
             child: left ? Image.asset('lib/assets/icons/other/chevronLeft.png',fit: BoxFit.fill,):
             Text(''),
           ),
           onTap: (){
             callBack?.call();
           },
         ),
         Expanded(
           flex: 1,
           child: Center(
             child: Text("$title",style: TextStyle(color: Color(0xff323233),fontSize: sp(32),fontFamily: 'M'),),
           ),
         ),
         Container(
           // width: px(40),
           height: px(50),
           margin: EdgeInsets.only(right: px(20)),
           child: right ? Image.asset('lib/assets/icons/form/alter.png',fit: BoxFit.cover,):
           // child: right ? Text('提交',style: TextStyle(fontSize: sp(24)),):
           Text(''),
         ),
       ],
     ),
   );
 }
  ///状态
  ///title:标题
  ///str:内容
  ///star:是否星标
  static Widget tabText({String? title, String? str,bool star = false,int status = 1}){
    return SizedBox(
      height: px(82),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(left: px(24),right: px(12)),
            child: Text("$title",style: TextStyle(
                fontSize: sp(28.0),
                color: Color(0xff4D7FFF),
                fontWeight: FontWeight.bold
            )),
          ),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: Adapt.screenW()-px(250),
            ),
            child: Container(
              margin: EdgeInsets.only(left: px(16),right: px(12)),
              child: Text("$str",style: TextStyle(
                  fontSize: sp(28.0),
                  color: Color(0XFF323233)
              ),maxLines: 1,overflow: TextOverflow.ellipsis,),
            ),
          ),
          Visibility(
            visible: star,
            child: Container(
              alignment: Alignment.topLeft,
              height: px(32),
              width: px(32),
              child: Image.asset('lib/assets/icons/form/star.png'),
            ),
          ),
          Spacer(),
          Container(
            width: px(110),
            height: px(48),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: Colorswitchs(status),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(px(20)),
                  bottomLeft: Radius.circular(px(20)),
                )
            ),//状态；1,未整改;2,已整改;3,整改已通过;4,整改未通过
            child: Text(switchs(status)
              ,style: TextStyle(color: Colors.white,fontSize: sp(20)),),
          )
        ],
      ),
    );
  }
 ///时间格式
 ///time:时间
 static String formatTime(time) {
    return utcToLocal(time.toString()).substring(0,10);
  }

}