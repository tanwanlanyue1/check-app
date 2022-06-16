import 'package:flutter/material.dart';
import 'package:scet_check/utils/screen/screen.dart';

class ProviderDetaild with ChangeNotifier {

  double _offestLeft = 0.0; // 偏移量

  get offestLeft => _offestLeft;

  //改变
  setOffest(double off){
    _offestLeft = px(206*off);
    notifyListeners();
  }

  //初始化
  initOffest(){
    _offestLeft = 0;
    notifyListeners();
  }

}