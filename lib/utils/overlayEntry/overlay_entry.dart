import 'dart:async';
import 'package:flutter/material.dart';
import 'package:scet_check/utils/screen/screen.dart';

class MyToast {

  static Map<String, OverlayEntry> _toasts = Map();

  static int _times = 5;

  static initToast(BuildContext context,{ String? str,required String name}) {


    OverlayState? overlayState = Overlay.of(context);

    _toasts[name] = OverlayEntry(builder: (context) {
      return Positioned(
        top: MediaQuery.of(context).size.height - 150,
        left: px(90),
        child: Material(
          color: Colors.transparent,
          child:  Container(
            width:px(600),
            height:px(90),
            decoration: BoxDecoration(
                color: Color(0xFFFFFFFF),
                borderRadius: BorderRadius.all(Radius.circular(px(76))),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 2, //阴影范围
                    spreadRadius: 1, //阴影浓度
                    color: Color(0x26000000), //阴影颜色
                  ),
                ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                    child: Container(
                      padding: EdgeInsets.only(left: px(38),right: px(30)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.asset('lib/assets/icons/other/remind.png',width: px(34),),
                          Text('$str',style: TextStyle(
                              fontSize: sp(28),
                              color: Color(0xFF333333),
                              fontFamily: "M"
                          ),),
                        ],
                      ),
                    )
                ),
                InkWell(
                  child: Container(
                    width: px(100),
                    height:px(90),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        border: Border(left: BorderSide(width: px(1),color: Color(0xFF999999)))
                    ),
                    child: Text('关闭',style: TextStyle(fontSize: sp(28),color: Color(0xFFF44236),fontFamily: "M"),),
                  ),
                  onTap: (){
                    MyToast.hide(name);
                    _toasts.remove(name);
                    _times = 0;
                  },
                )
              ],
            ),
          ),
        ),
      );
    });

    overlayState!.insert(_toasts[name]!);
    startTimer(name);
  }

  static startTimer(String name){
    _times = 10;
    Timer.periodic(Duration(milliseconds: 1000), (timer) async{
      if(_toasts.length>0){
        _toasts[name]!.markNeedsBuild();
        _times -= 1;
        if (_times <= 0) {
          _times = 0;
          MyToast.hide(name);
          _toasts.remove(name);
          timer.cancel();
        }
      }else{
        timer.cancel();
      }
    });
  }

  static hide(String name) {
    if(_toasts.length>0){
      MyToast._toasts[name]!.remove();
      _toasts.remove(name);
    }
    return;
  }
}
