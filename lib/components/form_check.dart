import 'package:flutter/material.dart';
import 'package:scet_check/components/status.dart';
import 'package:scet_check/utils/screen/screen.dart';

class FormCheck {

  static TextStyle nameStyle = TextStyle(
    fontSize: sp(30), 
    fontWeight: FontWeight.w600,
    fontFamily: 'Alibaba-PuHuiTi-M, Alibaba-PuHuiTi'
  );
  
  static Widget miniTitle(String title) {
    return Container(
      margin: EdgeInsets.fromLTRB(px(6.0), px(24.0), 0.0, px(12.0)),
      child: Text(title,
        style: TextStyle(
          fontSize: sp(34),
          fontFamily: 'M'
        )
      )
    );
  }

  //表单卡片
  static Widget fromCard({Widget? child,Function? close}) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(px(16.0)))
      ),
      child: Stack(
        children: [
          Container(
            width: Adapt.screenW(),
            padding: EdgeInsets.symmetric(
              horizontal: px(16.0),
              vertical: px(32.0),
            ),
            child: child
          ),
          if( close != null ) Positioned(
            right: 0.0,
            top: 0.0,
            child: InkWell(
              onTap: (){
                close();
              },
              child: Image.asset('lib/assets/icons/form/close.png',width: px(50),height: px(34),),
            ),
          )
        ],
      )
    );
  }
  //表格行项目
  static Widget rowItem({bool alignStart = false, bool padding = true, bool expanded = true, String? title,required Widget child}) {
    return Padding(
        padding: padding ? EdgeInsets.symmetric(vertical: px(24.0)) : EdgeInsets.zero,
        child: Row(
            crossAxisAlignment: alignStart ? CrossAxisAlignment.start : CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                  width: px(145.0),
                  child: Text(
                      '$title：',
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                          color: Color(0XFF787A80),
                          fontSize: sp(28.0),
                          fontWeight: FontWeight.w500
                      )
                  )
              ),
              expanded ? Expanded(child: child) : child
            ]
        )
    );
  }

  //输入框
  static Widget inputWidget({bool? disabled, String? hintText, Function? onChanged, String? unit}) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
              enabled: disabled,
              decoration: InputDecoration(
                isCollapsed: true,
                hintText: '$hintText',
                hintStyle: TextStyle(
                    color: Color(0XFFB0B2B8),
                    fontSize: sp(28.0)
                ),
                contentPadding: EdgeInsets.all(px(16.0)),
                filled: true,
                fillColor: Color(0XffF5F6FA),
                border: InputBorder.none,
              ),
              onChanged: (val){
                onChanged?.call(val);
              },
              style: TextStyle(
                color: Color(0XFF2E2F33),
                fontSize: sp(28.0),
              )
          ),
        ),
        if(unit != null)Text(
          unit,style: TextStyle( fontSize: sp(28.0)),
        )
      ],
    );
  }
  //下拉选择
  static Widget selectWidget({String? hintText, required List items, String? value, Function? onChanged}) {
    return Container(
      padding: EdgeInsets.only(left: px(8.0)),
      height: px(54.0),
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Color(0X99A1A6B3)),
        borderRadius: BorderRadius.circular(px(4.0)),
      ),
      child:  DropdownButton(
        isExpanded: true,
        underline: Container(),
        items: items.map((item) => DropdownMenuItem(
            child: Text('${item['name']}'),
            value: '${item['name']}'
        )
        ).toList(),
        hint: Text(
            '$hintText',
            style: TextStyle(
                color: Color(0XFFB0B2B8),
                fontSize: sp(24.0)
            )
        ),
        style: TextStyle(
            color: Color(0XFF45474D),
            fontSize: sp(28.0)
        ),
        onChanged: (val){
          onChanged?.call(val);
        },
        value: value,
        iconSize: sp(40.0),
        elevation: 10,
      ),
    );
  }
  //输入框可以展示四行
  static Widget textAreaWidget({String? hintText, Function? onChanged}) {
    return TextFormField(
      maxLines: 4,
      autofocus: false,
      decoration: InputDecoration(
        isCollapsed: true,
        hintText: '$hintText',
        hintStyle: TextStyle(
          color: Color(0XFFA8ABB3),
          fontSize: sp(28.0)
        ),
        contentPadding: EdgeInsets.all(px(10.0)),
        filled: true,
        fillColor: Color(0X29B8BDCC),
        border: InputBorder.none
      ),
      style: TextStyle(
        color: Color(0XFF45474D),
        fontSize: sp(28.0)
      ),
      onChanged: (val){
        onChanged?.call();
      }
    );
  }
  //每一行卡片
  static Widget dataCard({int? status,String? title,required List<Widget> children}){
    return Container(
      width: px(702),
      margin: EdgeInsets.only(left: px(24),right: px(24),bottom: px(16),top: px(16)),
      padding: EdgeInsets.all(px(16)),
      decoration: BoxDecoration(
          color: Color(0xffffffff),
          borderRadius: BorderRadius.circular(px(15)),
          boxShadow: const [
            BoxShadow(
                color: Color(0xffE9EBF3),
                offset: Offset(2.0, 2.0),
                blurRadius: 1.0,
                spreadRadius: 2.0
            ),
          ]
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "$title",
                style: TextStyle(
                  color: Color(0xff4D7CFF),
                  fontSize: sp(32),
                  fontFamily: "M",
                ),
              ),
              Spacer(),
              Status(status),
              Container(
                margin: EdgeInsets.only(left: px(14)),
                child: Row(
                  children: [
                    Text(
                      '详情',
                      style: TextStyle(color: Color(0xff8A9099),fontSize: sp(22)),
                    ),
                    Icon(Icons.keyboard_arrow_right,color: Color(0xffB5B8BD),size: sp(35),)
                  ],
                ),
              )
            ],
          ),
          Container(
            padding: EdgeInsets.only(top: px(10.0)),
            child: Column(
                children: children
            ),
          )
        ],
      ),
    );
  }

  static Widget textData({String? data,bool? color}) {
    return Padding(
      padding: EdgeInsets.only(left: px(12.0)),
      child: Text(
        '$data',
        style: TextStyle(
          color: color == true ? Colors.red : Color(0XFF2E2F33),
          fontSize: sp(28.0),
          fontWeight: FontWeight.w500
        )
      )
    );
  }

  static Widget tabText({String? title, String? str,bool colors = false}){
    return Row(
      children: [
        Text('$title：',style: TextStyle(color: Color(0xff787A80),fontSize: sp(26)),),
        Text(
          '$str',
          style: TextStyle(
              color: colors ? Colors.red : Color(0xff2E2F33),
              fontSize: sp(30.0)
          ),
        )
      ],
    );
  }
  
}