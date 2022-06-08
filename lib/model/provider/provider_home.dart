import 'package:flutter/material.dart';

///首页配置
class HomeModel with ChangeNotifier {

  String _pageType = '1'; //首页数据

  int _currentIndex = 0; // 底部导航下标
  FocusNode verifyNode = FocusNode(); //声明一个焦点
  List _selectCompany = []; //选中的企业
  List _select = []; //选中的企业

  get currentIndex => _currentIndex;
  get verifyNodes => verifyNode;
  get selectCompany => _selectCompany;
  get select => _select;

  // 切换底部导航
  onChangeIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  // 关闭焦点
  onVerifyNodes() {
    verifyNode.unfocus();
    notifyListeners();
  }
  //改变选择的企业
  setSelect(List company){
    _select = company;
    notifyListeners();
  }
  //改变选择的企业
  setSelectCompany(List company){
    _selectCompany = company;
    notifyListeners();
  }
}