import 'package:flutter/material.dart';
import 'package:scet_check/utils/screen/screen.dart';

class ProviderDetaild with ChangeNotifier {

  List _cache = [];

  get getCacheOffest => pageOffestLeft;
  get getCachePageindex => cachePageindex;

  //改变缓存中某一項的值
  setOffest(String pageName,{double? off,int? pageIndex}){
    int index = _cache.indexWhere((item) => item['name'] == pageName);
    if(index != -1){
      if(off != null){
        _cache[index]['offestLeft'] = off;
      }else{
        _cache[index]['pageIndex'] = pageIndex;
      }
    } else {
      if(off != null){
        _cache.add({'name': pageName, 'offestLeft': off, pageIndex: 0});
      }else{
        _cache.add({'name': pageName, 'offestLeft': 0.0, pageIndex: pageIndex});
      }

    }
    notifyListeners();
  }

  //  获取缓存的偏移量
  double pageOffestLeft(String pageName){
    int index = _cache.indexWhere((item) => item['name'] == pageName);
    if(index != -1){
      return _cache[index]['offestLeft'];
    }else{
      return 0.0;
    }
  }

  //  获取缓存的下标
  int cachePageindex(String pageName){
    int index = _cache.indexWhere((item) => item['name'] == pageName);
    if(index != -1){
      return _cache[index]['pageIndex'];
    }else{
      return 0;
    }
  }

  // 移除某一项缓存
  removeCache(String pageName){
    int index = _cache.indexWhere((item) => item['name'] == pageName);
    if(index != -1){
      return _cache.removeAt(index);
    }
  }

}