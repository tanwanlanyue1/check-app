import 'package:flutter/material.dart';
import 'package:scet_check/utils/dateUtc/date_utc.dart';
import 'package:scet_check/utils/screen/screen.dart';

//整改插件
class RectifyComponents{

  //整改表单
 static Widget rectifyRow({required List company,required int i,bool review = false,Function? callBack}){
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
                  margin: EdgeInsets.only(top: px(5)),
                  child: Text(i < 9 ?'0${i+1}':'${i+1}',style: TextStyle(color: Color(0xff4D7FFF),fontSize: sp(28)),),
                ),
                Container(
                  margin: EdgeInsets.only(left: px(16),right: px(16),top: px(5)),
                  child: Text('${company[i]["name"]}',style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),),
                ),
                SizedBox(
                  height: px(28),
                  width: px(28),
                  child: Icon(Icons.star,color: Color(0xffE65C5C),),
                ),
                Spacer(),
                Container(
                  width: px(100),
                  height: px(48),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: company[i]['type'] == -1 ? Color(0xffFAAA5A):
                      company[i]['type'] == 1 ? Color(0xff7196F5):
                      Color(0xff95C758),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(px(20)),
                        bottomLeft: Radius.circular(px(20)),
                      )
                  ),//状态；-1：未处理;0:处理完；1：处理中
                  child: Text(company[i]['type'] == -1 ? '未整改':
                  company[i]['type'] == 1 ? '整改中':'整改完成'
                    ,style: TextStyle(color: Colors.white,fontSize: sp(24)),),
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
                    margin: EdgeInsets.only(left: px(24),right: px(80)),
                    child: Text('${company[i]["tag"]}',style: TextStyle(color: Color(0xff969799),fontSize: sp(24)),),
                  ),
                  SizedBox(
                    height: px(32),
                    width: px(32),
                    child: Image.asset('lib/assets/icons/check/time.png'),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: px(24),right: px(80)),
                    child: Text(formatTime(company[i]["updateTime"]),style: TextStyle(color: Color(0xff969799),fontSize: sp(24)),),
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

  //头部
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
           width: px(40),
           height: px(50),
           margin: EdgeInsets.only(right: px(20)),
           child: right ? Image.asset('lib/assets/icons/form/alter.png',fit: BoxFit.cover,):
           Text(''),
         ),
       ],
     ),
   );
 }
 static String formatTime(time) {
    return dateUtc(time.toString()).substring(0,10);
  }

}