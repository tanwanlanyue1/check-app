import 'package:flutter/material.dart';
import 'package:scet_check/utils/screen/screen.dart';

/// 登录页组件
class LoginComponents{
  /// 登录输入框
  /// icon: 图标
  /// hitStr: 默认值
  /// isPassWord: 是否是密码
  /// onChange: 回调事件
  /// isPassWord:  true-变为省略号，false-正常渲染
  static Widget loginInput({
    String? icon,
    String? hitStr,
    String? hintVal,
    bool isPassWord = false,
    Function? onChange,
  }) {
    TextEditingController _controller = TextEditingController();
    _controller.text = hintVal ?? '';
    return Container(
      width: px(550),
      height: px(113),
      padding: EdgeInsets.only(left: px(24)),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: px(1), color: Color(0x4DA8ABB3))
        )
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            '$icon',
            width: px(40),
            height: px(40),
            color: Color(0xff6089F0),
          ),
          Expanded(
            child: TextField(
              style: TextStyle(
                fontSize: sp(28.0),
                textBaseline: TextBaseline.ideographic
              ),
              obscureText: isPassWord,
              controller: _controller,
              onChanged: (val){
                onChange?.call(val);
              },
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(top: px(10), left: px(15.0)),
                border: InputBorder.none,
                hintText: hitStr,
                hintStyle: TextStyle(
                  fontSize: sp(28), color: Color(0xFFA8ABB3)
                )
              ),
            ),
          )
        ],
      ),
    );
  }

  /// 登录按钮
  /// onTap: 回调事件
  static Widget loginBtn({Function? onTap}){
    return Padding(
      padding: EdgeInsets.only(top: px(120)),
      child: InkWell(
        child: Container(
          width: px(550),
          height: px(76),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(px(20))),
            gradient: LinearGradient(//渐变位置
                begin: Alignment.topCenter,end: Alignment.bottomCenter,
                stops: const [0.0, 1.0], //[渐变起始点, 渐变结束点]
                colors: const [Color(0xff99C0FF), Color(0xff4D7CFF)]//渐变颜色[始点颜色, 结束颜色]
            ),
          ),
          child: Text(
            '登录',
            style: TextStyle(color: Colors.white, fontSize: sp(32)),
          ),
        ),
        onTap: (){
          onTap?.call();
        },
      ),
    );
  }
}