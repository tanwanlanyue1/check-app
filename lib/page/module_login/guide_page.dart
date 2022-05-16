import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:scet_check/api/api.dart';
import 'package:scet_check/api/request.dart';
import 'package:scet_check/page/module_login/components/my_painter.dart';
import 'package:scet_check/utils/screen/screen.dart';
import 'package:scet_check/utils/storage/data_storage_key.dart';
import 'package:scet_check/utils/storage/storage.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'components/update_app.dart';

///引导页
class GuidePage extends StatefulWidget {
  @override
  _GuidePageState createState() => _GuidePageState();
}

class _GuidePageState extends State<GuidePage> {
  @override
  void initState() {
    super.initState();
    initData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(// 判断是否首次打开，不是首次打开使用启动页图片衔接安卓原生启动页
        body: Stack(
          children: [
            CustomPaint(painter: MyPainter(),),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: px(200),
                  height: px(200),
                  margin: EdgeInsets.only(top: px(252),bottom: px(24)),
                  child: Image.asset('lib/assets/images/login/logo.png',),
                ),
                ShaderMask(
                  shaderCallback: (bounds) {
                    return LinearGradient(
                    begin: Alignment.topCenter,end: Alignment.bottomCenter,
                    colors: const [Color(0xff80D4FF), Color(0xff5778FF),Color(0xff5778FF)]
                    ).createShader(Offset.zero & bounds.size);
                  },
                  child: Text(
                    '排查工具',
                    textAlign: TextAlign.left,
                    style: TextStyle(color: Colors.white,fontSize: sp(48),fontFamily: 'M'),
                  ),
                ),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: (){
                        _tap();
                      },
                      child: _icon(),
                    )
                  ],
                ),
              ],
            ),
          ],
        ),
    );
  }

  /// 箭头icon
  Widget _icon() {
    return Container(
      width: px(132),
      height: px(132),
      margin: EdgeInsets.only(bottom: px(200)),
      child: Image.asset('lib/assets/images/login/nextLog.png'),
    );
  }

  /// 箭头icon的点击事件
  void _tap() {
    StorageUtil().setBool(StorageKey.STORAGE_DEVICE_ALREADY_OPEN_KEY, true); // 设置本机为非首次打开app的状态
    /// 跳转至登陆页面
    Navigator.pushNamedAndRemoveUntil(context, '/logIn', (route) => false);
  }

  void initData() async {
    PackageInfo _packageInfo = PackageInfo(
      appName: 'Unknown',
      packageName: 'Unknown',
      version: 'Unknown',
      buildNumber: 'Unknown',
    );
    _packageInfo = await PackageInfo.fromPlatform();

    if (Platform.isIOS) {
      _upApp(packageInfo: '2', version: _packageInfo.version);
      //ios相关代码
    } else if (Platform.isAndroid) {
      _upApp(packageInfo: '1', version: _packageInfo.version);
      //android相关代码
    }
  }

  /// 获取版本信息
  /// packageInfo :包信息
  /// version :版本号
  void _upApp({required String packageInfo, required String version}) async {
    Map<String, dynamic> params = Map();
    params['type'] = packageInfo;

    var response = await Request().get(Api.url['versions'], data: params);

    if(response['statusCode'] == 200 &&
        response['data']['list'].length > 0 &&
        version != response['data']['list'][0]?['number']){
      if (Platform.isIOS) {
        _upAppPage(
          version: response['data']['version'],
          msg: response['data']['msgName'],
          isForced: true,
          path: '',
        );
        //ios相关代码
      } else if (Platform.isAndroid) {
        _upAppPage(
          version: response['data']['list'][0]?['number'],
          msg: response['data']['list'][0]['remark'],
          isForced: true,
          path: Api.baseUrlApp + response['data']['list'][0]['file']
        );
        //android相关代码
      }
    }
  }

/// 跳转下载页
/// version:版本号
/// msg:消息
/// isForced:是否下载
/// path:路径
/// isForced true-强制下载/false-非强制下载
  _upAppPage({String? version, String? msg, bool isForced = false, String? path,}) async {
    Future.microtask(() {
      showDialog<Null>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return GestureDetector(
              onTap: () {},
              child: Material(
                color: Color.fromRGBO(0, 0, 0, 0.3),
                child: UpdateApp(
                  msg: msg,
                  version: version,
                  isForced: isForced,
                  path:'$path',
                ),
              ),
          );
        },
      );
    });
  }
}
