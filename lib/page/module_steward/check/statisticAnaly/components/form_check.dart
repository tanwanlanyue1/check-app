import 'package:flutter/material.dart';
import 'package:scet_check/utils/screen/screen.dart';

///表单组件
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

  ///标签头部
  ///title : 标题
  ///left:图标是否显示
  ///showUp : 是否展示
  ///onTaps : 回调
  ///tidy : 图标样式
  ///showUp ：是否显示图标
  ///tidy：显示上图标/下图标
  static Widget formTitle(String title,{bool left = true,bool showUp = false,Function? onTaps,bool tidy = true}){
    return Row(
      children: [
        Visibility(
          visible: left,
          child: Container(
            margin: EdgeInsets.only(right: px(8)),
            width: px(4),
            height: px(24),
            decoration: BoxDecoration(
                color: Color(0xFF4D7FFF),
                borderRadius: BorderRadius.all(Radius.circular(px(1)))
            ),
          ),
        ),
        Expanded(
          child: Text(title,
            style: TextStyle(
              fontSize: sp(26),
              fontFamily: 'M',
              color: Color(0xff323233),
            ),overflow: TextOverflow.ellipsis,
        )),
        Visibility(
          visible: showUp,
          child: GestureDetector(
            child: SizedBox(
              height: px(50),
              width: px(80),
              child: Icon(tidy?
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

  ///表格行项目
  ///titleColor:标题颜色
  ///title:标题
  ///alignStart:居上
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
              Visibility(
                visible: expandedLeft,
                child: Expanded(
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
                ),
                replacement: SizedBox(
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
              ),
              expanded ? Expanded(child: child) : child
            ]
        )
    );
  }

  ///输入框
  ///disabled:启用
  ///isPassWord: 是否密码
  ///filled:填充的背景色
  ///hintText:提示的值
  ///hintVal:默认值
  ///onChanged:回调
  ///unit:单位
  ///TextInputType 键盘类型
  static Widget inputWidget({bool? disabled, bool filled = true, bool isPassWord = false,String? hintText = '请输入', String hintVal = '',Function? onChanged,int lines = 1, String? unit,TextInputType? keyboardType}) {
    TextEditingController _controller = TextEditingController();
    _controller.text = hintVal;
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
                filled: filled,
                fillColor: Color(0XffF5F6FA),
                border: InputBorder.none,
              ),
              maxLines: lines,
              controller: _controller,
              onChanged: (val){
                onChanged?.call(val);
              },
              keyboardType: keyboardType ?? TextInputType.text,
              obscureText: isPassWord,
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
  ///表单卡片
  ///title：标题
  ///children：表单内容
  static Widget dataCard({String? title,required List<Widget> children,bool top = true,bool padding = true}){
    return Container(
      width: px(750),
      margin: EdgeInsets.only(top: top ? px(4):0),
      padding: padding ? EdgeInsets.all(px(16)) : EdgeInsets.all(px(0)),
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

  ///提交按钮
  ///cancel:取消回调
  ///submit:提交回调
 static Widget submit({Function? cancel,Function? submit,String? cancels,String? submits,Color? canColors,Color? subColors}){
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
                  cancels ?? '取消',
                  style: TextStyle(
                      fontSize: sp(24),
                      fontFamily: "R",
                      color: canColors ?? Color(0xFF323233)),
                ),
                decoration: BoxDecoration(
                  border: Border.all(width: px(2),color: canColors ?? Color(0XffE8E8E8)),
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
                  submits ?? '提交',
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