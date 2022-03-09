import 'package:flutter/material.dart';
import 'package:scet_check/utils/screen/adapter.dart';

class ProviderDetaild with ChangeNotifier {
  bool _pieChart = false; //展示图表或者echart
  int _cloumnChart = 0;// 0-饼图 1-竖状图 2-横状图
  double _offestLeft = 0.0; // 偏移量

  get pieChart => _pieChart;
  get cloumnChart => _cloumnChart;
  get offestLeft => _offestLeft;



  //饼图
  setPie(){
    if(_pieChart == false){
      _pieChart = true;
      notifyListeners();
    }else{
      _pieChart = false;
      notifyListeners();
    }
  }

  //柱状图
  setcloumn(int index){
    _cloumnChart = index;
    notifyListeners();
  }

  //改变
  setOffest(double off){
    _offestLeft = ((Adapter.designWidth-40)/4) * off;
    notifyListeners();
  }

  //初始化
  initOffest(){
    _offestLeft = 0;
    notifyListeners();
  }
}