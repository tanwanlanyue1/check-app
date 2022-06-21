import 'package:flutter/services.dart';
import 'package:scet_check/components/generalduty/toast_widget.dart';

/// 监听首页返回 退出
class LogOut {
  static int popTrue = 0; //记录返回次数 为3就是退出app
///判断是否退出
  static Future<bool> onWillPop() {
    // print(popTrue);
    popTrue = popTrue + 1;
    ToastWidget.showToastMsg('再按一次退出排查管家');

    if (popTrue == 3) {
      pop();
    }

    return Future.delayed(const Duration(seconds: 2), () {
      popTrue = 1;
      return false;
    });
  }

///退出事件
  static Future<void> pop() async {
    await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
  }
}
