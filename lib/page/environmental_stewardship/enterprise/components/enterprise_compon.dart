import 'package:flutter/material.dart';
import 'package:scet_check/utils/screen/screen.dart';


class EnterPriseCompon{

  static Widget classify({required String title,required String type,int color = 1}){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: px(24)),
          child: Text(title,style: TextStyle(color: color == 0 ? Color(0xffFAAA5A):
          color == 1 ? Color(0xff323233):Color(0xff6089F0),
              fontSize: sp(28),fontFamily: 'R'),),
        ),
        Container(
          margin: EdgeInsets.only(top: px(24)),
          child: Text(type,style: TextStyle(color: Color(0xff969799),fontSize: sp(28))),
        ),
      ],
    );
  }
  //表头
  static List<Widget> topRow(item){
    List<Widget> bodyRow = [];
    for(var i = 0; i < item.length; i++){
      bodyRow.add(
          Expanded(
            child: Container(
              height: px(71),
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Container(
                alignment: Alignment.topCenter,
                child: Text(
                    '${item[i]}',
                    style: TextStyle(
                        color: Color(0XFF969799),
                        fontSize: sp(24.0)
                    )
                ),
              ),
            ),
          )
      ) ;
    }
    return bodyRow;
  }
  //表单
  static List<Widget> bodyRow(item){
    List<Widget> bodyRow = [];
    for(var i = 0; i < item.length; i++){
      bodyRow.add(
          Row(
            children: List.generate(item[i]['data'].length, (index){
              return  Expanded(
                child: Container(
                  height: px(71),
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Container(
                    alignment: Alignment.topCenter,
                    child: Text(
                        '${item[i]['data'][index]['name']}',
                        style: TextStyle(
                            color: Color(0XFF969799),
                            fontSize: sp(24.0)
                        )
                    ),
                  ),
                ),
              );
            },)
          )
      );
    }
    return bodyRow;
  }
}