import 'package:flutter/material.dart';
import 'package:scet_check/components/form_check.dart';
import 'package:scet_check/utils/screen/screen.dart';


class EnterPriseCompon{

  ///分类
  ///title:标题
  ///type:类型
  ///color: 颜色分类
  /// 0：未验收/否，1: 黑色 2: 已验收/确定 蓝色
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

  /// 概况列表
  /// title：左边标题
  /// data：右边标题
  /// color： true 蓝色  false 白色
  /// color：判断字体
  static Widget surveyItem(String? title,String? data,{color = false}){
    return Container(
      height: px(96),
      child: FormCheck.rowItem(
        title: title,
        expandedLeft: true,
        child: Text('$data',style: TextStyle(color: Color(color ? 0xff6089F0 : 0xff323233),fontSize: sp(28)),textAlign: TextAlign.right,),
      ),
      decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Color(0xffE8E8E8),width: px(2)))
      ),
    );
  }

  ///表头
  ///item List
  static List<Widget> topRow(List item){
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

  ///表单内容
  ///item: 数据
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