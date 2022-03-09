import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:scet_check/utils/screen/screen.dart';
///toast弹窗
class ToastWidget {
  static showToastMsg(String? msg) {
    BotToast.showText(
      text: "$msg",
      align: const Alignment(0, 0),
      borderRadius: const BorderRadius.all(Radius.circular(6.0)),
      contentPadding:const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 10),
      textStyle: TextStyle(
        color: Colors.white,
        fontSize: px(32.0)
      )
    );
  }
  ///弹窗
  static showDialog({String? msg, Function? cancel, Function? ok}) {
    BotToast.showWidget(
        toastBuilder: (cancelFunc){
          return Material(
              color: const Color.fromRGBO(0, 0, 0, 0.5),
              child:  Center(
                child: Container(
                  decoration:const ShapeDecoration(
                      color: Color(0xffF9F9F9),
                      shape: RoundedRectangleBorder(
                          borderRadius:  BorderRadius.all( Radius.circular(5))
                      )
                  ),
                  width: px(400),
                  height: px(220),
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          child: Text("$msg",style: TextStyle(fontSize: sp(30)),),
                          alignment: Alignment.center,
                        ),
                      ),
                      // CircularProgressIndicator(),
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: (){
                                BotToast.cleanAll();
                                if(cancel != null ) {
                                  cancel();
                                }
                              },
                              child: Container(
                                height:px(80),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  border: Border(
                                    top: BorderSide(width: px(1.0),color: Color(0X99A1A6B3)),
                                    right: BorderSide(width: px(1.0),color: Color(0X99A1A6B3)),
                                  ),
                                ),
                                child: Text('取消',style: TextStyle(fontSize: sp(25)),),
                              ),
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: (){
                                if(ok != null ) {
                                  ok();
                                }
                                BotToast.cleanAll();
                              },
                              child: Container(
                                height:px(80),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  border: Border(top: BorderSide(width: px(1.0),color: Color(0X99A1A6B3))),
                                ),
                                child: Text('确定',style: TextStyle(fontSize: sp(25),color: Colors.blue),),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              )
          );
        }
    );
  }
}