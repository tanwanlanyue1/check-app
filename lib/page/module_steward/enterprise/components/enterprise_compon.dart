import 'package:flutter/material.dart';
import 'package:scet_check/page/module_steward/check/statisticAnaly/components/form_check.dart';
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
          child: Text(title,style: TextStyle( color: color == 0 ? Color(0xffFAAA5A):
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

  ///一行俩个的分类循环
  ///data: 数据
  ///j*2+1 < data.length,判断具体数量为奇数还是偶数
  static Widget itemClassly(List data){
    return Column(
      children: List.generate((data.length/2).ceil(), (j) {
        return Container(
          padding: EdgeInsets.only(top: px(24),bottom: px(24)),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: classify(
                      title: '${data[j*2]['name']}',
                      type: '${data[j*2]['type']}',
                      color:  data[j*2]['color'] ?? 1,
                  ),
                ),
                Container(
                  width: px(1),
                  height: px(48),
                  color: Color(0xffE8E8E8),
                ),
                (j*2+1 < data.length) ?
                Expanded(
                  child: classify(
                    title: '${data[j*2+1]['name']}',
                    type: '${data[j*2+1]['type']}',
                    color: data[j*2+1]['color'] ?? 1,
                  ),
                ) : Expanded(
                  child: Container(),
                ),
              ]
          ),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(width: px(2.0),color: Color(0XffE8E8E8)),
            ),
          ),
        );
      }),
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

  ///污染物类型循环
  static List<Widget> type({bool color = false,int length = 2}){
    List<Widget> itemRow = [];
    for(var i = 0; i < 2; i++){
      itemRow.add(
        Column(
          children: List.generate(2, (index) {
            return Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: px(12)),
                  child: FormCheck.rowItem(
                      title: '1. 污泥',
                      titleColor: Color(0xff323233),
                      child: Text('危废编码：264-012-12',style: TextStyle(
                          color: color ? Color(0xff969799) : Color(0xff323233),fontSize: sp(26)),
                        textAlign: TextAlign.right,)
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(bottom: px(12)),
                  height: px(150),
                  child: Row(
                    children: List.generate(length, (i) =>
                        Expanded(
                          child: EnterPriseCompon.classify(
                              title:'否',
                              color: 0,
                              type:'纳入管理计划'
                          ),
                        )),
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(width: px(1.0),color: Color(0XffE8E8E8)),
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      );
    }
    return itemRow;
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