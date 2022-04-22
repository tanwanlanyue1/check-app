import 'package:flutter/material.dart';
import 'package:scet_check/utils/screen/screen.dart';

class TaskCompon{

  static Widget taskList(int i){
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
        onTap: (){
        },
      ),
    );
  }

}