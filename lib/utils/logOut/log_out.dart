import 'package:flutter/services.dart';
import 'package:scet_check/components/toast_widget.dart';
// 监听首页返回 退出
class LogOut {
  static int popTrue = 0;

  static Future<bool> onWillPop() {
    // print(popTrue);
    popTrue = popTrue + 1;
    ToastWidget.showToastMsg('再按一次退出园区预警');

    if (popTrue == 3) {
      // print('3');
      pop();
    }

    return Future.delayed(const Duration(seconds: 2), () {
      popTrue = 1;
      return false;
    });
  }

  static Future<void> pop() async {
    await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
  }
}
