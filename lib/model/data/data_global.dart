import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scet_check/api/Request.dart';
import 'package:scet_check/model/provider/provider_app.dart';
import 'package:scet_check/page/module_login/guide_page.dart';
import 'package:scet_check/utils/storage/data_storage_key.dart';
import 'package:scet_check/utils/storage/storage.dart';
import 'package:path_provider/path_provider.dart';

/// 全局配置
class Global {
  // 是否第一次打开
  static bool isFirstOpen = false;

  // 离线用户token
  static String? token;

  // 是否离线登录
  static bool isOfflineLogin = false;

  static String? router;

  // provider 应用状态,
  static AppState appState = AppState();

  // 是否 release
  static bool get isRelease => bool.fromEnvironment("dart.vm.product");

  // app文件本地保存路径
  static String appDownload ='';

  // 三个字体文件路径
  static String fontFileM ='';
  static String fontFileB ='';
  static String fontFileR ='';

  // init 工具统一初始化
  static Future init({context}) async {
    // 运行初始
    WidgetsFlutterBinding.ensureInitialized();
    // 网络请求初始化
    Request();

    // 本地存储工具初始化
    await StorageUtil.init();

    appDownload = (await getApplicationDocumentsDirectory()).path + "/fontDownload/";

    // 读取设备是否已经打开过
    isFirstOpen = StorageUtil().getBool(StorageKey.STORAGE_DEVICE_ALREADY_OPEN_KEY);

    // 读取离线用户token
    var _token = StorageUtil().getString(StorageKey.Token);
    GuidePage().createState().initData();

    if(isFirstOpen){
      if (_token != null && _token != 'null'  &&  _token != '') {
        token = _token;
        isOfflineLogin = true;
        Map? _personalData = StorageUtil().getJSON(StorageKey.PersonalData);
        if (_personalData != null) {
          for(var i = 0; i < _personalData['roles'].length; i++){
            if(_personalData['roles'][i]['name'] == '环保管家' || _personalData['roles'][i]['name'] == '项目经理'){
              router = '/steward';return;
            }else if(_personalData['roles'][i]['name'] == '企业'){
              if(_personalData['company'] != null){
                router = '/enterpriseHome';return;
              }
            }else if(_personalData['roles'][i]['name'] == '环保局'){
              router = '/protectionAgencyHome';return;
            }else{
              if(_personalData['roles'].length == i){
                router = '/';
              }
            }
          }
        }
      }else{
        router = '/logIn';
      }
    }else{
      router = '/';
    }

    // //读取离线用户信息
    // Map _personalData = StorageUtil().getJSON(StorageKey.PersonalData);
    // if (_personalData != null) {
    //   isOfflineLogin = true;
    // }
    // android 状态栏为透明的沉浸
    if (Platform.isAndroid) {
      SystemUiOverlayStyle systemUiOverlayStyle =
      SystemUiOverlayStyle(statusBarColor: Colors.transparent);
      SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    }
  }

  ///  加载字体的方法
  static Future<void> readFont(String path,String name) async {
    var fontLoader = FontLoader(name);
    fontLoader.addFont(getCustomFont(path));
    print('文件 $path --->读取成功');
    await fontLoader.load();
  }

  static Future<ByteData> getCustomFont(String path) async {
    var byteData = await File(path).readAsBytes();
    return ByteData.view(byteData.buffer);
  }
}