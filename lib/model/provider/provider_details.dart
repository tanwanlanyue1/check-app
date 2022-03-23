import 'package:flutter/material.dart';
import 'package:scet_check/utils/screen/adapter.dart';
import 'package:scet_check/utils/screen/screen.dart';

class ProviderDetaild with ChangeNotifier {
  bool _pieChart = false; //展示图表或者echart
  int _cloumnChart = 0;// 0-饼图 1-竖状图 2-横状图
  double _offestLeft = 0.0; // 偏移量
  String _law = ''; // 法律法规的id
  String _lawTitle = ''; // 法律法规的name
  bool _lawBool = false; //法律法规文件
  bool _basis = false; //排查文件

  get pieChart => _pieChart;
  get cloumnChart => _cloumnChart;
  get offestLeft => _offestLeft;
  get lawId => _law;
  get lawTitle => _lawTitle;
  get lawBool => _lawBool;
  get basis => _basis;



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
    _offestLeft = px(206*off);
    notifyListeners();
  }

  //初始化
  initOffest(){
    _offestLeft = 0;
    notifyListeners();
  }
  //获取id
  getLawId({String? id,String? name,bool basis = false}){
    _law = id ?? '';
    _lawTitle = name ?? '';
    _basis = basis;
    notifyListeners();
  }

  ///获取法律文件
  ///false 关闭法律文件列表提交按钮
  getLawBool(bool law){
    _lawBool = law;
    notifyListeners();
  }
}