import 'package:flutter/material.dart';
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

  //标签头部
  static Widget formTitle(String title,{bool showUp = false,Function? onTaps,bool packups = true}){
    return Row(
      children: [
        Container(
          margin: EdgeInsets.only(right: px(8)),
          width: px(4),
          height: px(24),
          decoration: BoxDecoration(
              color: Color(0xFF4D7FFF),
              borderRadius: BorderRadius.all(Radius.circular(px(1)))
          ),
        ),
        Text(title,
            style: TextStyle(
              fontSize: sp(26),
              fontFamily: 'M',
              color: Color(0xff323233),
            )
        ),
        Spacer(),
        Visibility(
          visible: showUp,
          child: GestureDetector(
            child: SizedBox(
              height: px(50),
              width: px(50),
              child: Icon(packups?
              Icons.keyboard_arrow_up:
              Icons.keyboard_arrow_down,
                color: Colors.grey,),
            ),
            onTap: (){
              onTaps?.call();
            },
          ),
        ),
      ],
    );
  }

  //表格行项目
  static Widget rowItem({
    Color? titleColor,
    bool alignStart = false,
    bool padding = true,
    bool expanded = true,
    bool expandedLeft = false,
    String? title,
    required Widget child}) {
    return Padding(
        padding: padding ? EdgeInsets.only(top: px(12),bottom: px(12)) : EdgeInsets.zero,
        child: Row(
            crossAxisAlignment: alignStart ? CrossAxisAlignment.start : CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              expandedLeft?
              Expanded(
                child: SizedBox(
                    child: Text(
                        '$title',
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                            color: titleColor ?? Color(0XFF969799),
                            fontSize: sp(28.0),
                            fontWeight: FontWeight.w500
                        )
                    )
                ),
              ):
              SizedBox(
                  width: px(150),
                  child: Text(
                      '$title',
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                          color: titleColor ?? Color(0XFF969799),
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
  static Widget inputWidget({bool? disabled, String? hintText = '请输入', Function? onChanged, String? unit}) {
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

  //表单卡片
  static Widget dataCard({int? status,String? title,required List<Widget> children}){
    return Container(
      width: px(750),
      margin: EdgeInsets.only(top: px(4)),
      padding: EdgeInsets.all(px(16)),
      decoration: BoxDecoration(
          color: Color(0xffffffff),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Visibility(
            visible: title?.isNotEmpty ?? false,
            child: Text(
              "$title",
              style: TextStyle(
                color: Color(0xff323233),
                fontSize: sp(28),
                fontFamily: "M",
              ),
            ),
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

//状态
  static Widget tabText({String? title, String? str,}){
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
          Text("$str",style: TextStyle(
              fontSize: sp(28.0),
              color: Color(0XFF323233)
          )),
          Container(
            alignment: Alignment.topLeft,
            height: px(32),
            width: px(32),
            child: Image.asset('lib/assets/icons/form/star.png'),
          ),
          Spacer(),
          Container(
            height: px(48),
            width: px(100),
            alignment: Alignment.center,
            child: Text(
              '已整改',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: sp(22.0)
              ),
            ),
            decoration: BoxDecoration(
                color: Color(0xff95C758),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(px(20)),
                  bottomLeft: Radius.circular(px(20)),
                )
            ),
          ),
        ],
      ),
    );
  }
  //提交按钮
 static Widget submit({Function? cancel,Function? submit}){
    return Container(
        height: px(88),
        margin: EdgeInsets.only(top: px(4)),
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              child: Container(
                width: px(240),
                height: px(56),
                alignment: Alignment.center,
                child: Text(
                  '取消',
                  style: TextStyle(
                      fontSize: sp(24),
                      fontFamily: "R",
                      color: Color(0xFF323233)),
                ),
                decoration: BoxDecoration(
                  border: Border.all(width: px(2),color: Color(0XffE8E8E8)),
                  borderRadius: BorderRadius.all(Radius.circular(px(28))),
                ),
              ),
              onTap: (){
                cancel?.call();
              },
            ),
            GestureDetector(
              child: Container(
                width: px(240),
                height: px(56),
                alignment: Alignment.center,
                margin: EdgeInsets.only(left: px(40)),
                child: Text(
                  '提交',
                  style: TextStyle(
                      fontSize: sp(24),
                      fontFamily: "R",
                      color: Colors.white),
                ),
                decoration: BoxDecoration(
                  color: Color(0xff4D7FFF),
                  border: Border.all(width: px(2),color: Color(0XffE8E8E8)),
                  borderRadius: BorderRadius.all(Radius.circular(px(28))),
                ),
              ),
              onTap: (){
                submit?.call();
                },
            ),
          ],
        ),
      );
  }

}