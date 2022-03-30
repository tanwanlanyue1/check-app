import 'package:flutter/material.dart';

/// 系统相应状态配置
class AppState with ChangeNotifier {

  bool _isGrayFilter = false;
  Color _primaryColor = colorsList[0];

  // 主题颜色数组

  get isGrayFilter => _isGrayFilter;
  get primaryColor => _primaryColor;

  // AppState({bool isGrayFilter = false}) {
  //   this._isGrayFilter = isGrayFilter;
  // }

  // 切换灰色滤镜夜晚模式
  switchGrayFilter() {
    _isGrayFilter = !_isGrayFilter;
    notifyListeners();
  }

  // 切换主题颜色
  switchPrimaryColor(int role) {
    switch(role) {
      case 1: _primaryColor = colorsList[role-1]; break;
      case 2: _primaryColor = colorsList[role-1]; break;
      case 3: _primaryColor = colorsList[role-1]; break;
      default: _primaryColor = colorsList[0]; break;
    }
    notifyListeners();
  }
  // 转主题色
  MaterialColor createMaterialColor() {
    Color color = _primaryColor;
    List strengths = <double>[.05];
    Map<int, Color> swatch = <int, Color>{};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    for (var strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }
    return MaterialColor(color.value, swatch);
  }
}
List<Color> colorsList = [
  // Color(0xff19191A),
  Color(0xff7196F5),
  Color(0xFF49B8A4),
  Color(0xFF16AADB),
];