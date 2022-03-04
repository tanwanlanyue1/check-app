import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scet_check/api/api.dart';
import 'package:scet_check/api/request.dart';
import 'package:scet_check/routers/router_animate/router_animate.dart';
import 'package:scet_check/utils/screen/adapter.dart';
import 'package:scet_check/utils/screen/screen.dart';
import 'package:scet_check/utils/storage/data_storage_key.dart';
import 'package:scet_check/utils/storage/storage.dart';

import 'login_page.dart';

class GuidePage extends StatefulWidget {
  @override
  _GuidePageState createState() => _GuidePageState();
}

class _GuidePageState extends State<GuidePage> {

  int _index = 0;
  bool _visible = true;
  bool _change = false;

  @override
  void initState() {
    super.initState();
    initData();
    var _token = StorageUtil().getString(StorageKey.Token);
    // 第一次打开应用时引导页图片自动切换下一张
    if (StorageUtil().getBool(StorageKey.STORAGE_DEVICE_ALREADY_OPEN_KEY) != true) {
      Future.delayed(Duration(seconds: 1)).then(
        (_) {
          setState(() {
            _visible = false;
            _change = true;
          });
        },
      );
    } else if (_token == null || _token == 'null' || _token == '') {
      // 第一次打开未登录，下次打开直接跳过引导页直接进入登陆页
      Future.microtask(() {
        Navigator.of(context).pushAndRemoveUntil(
            CustomRoute(LoginPage()), (router) => router == null);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
        BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height),
        designSize: Size(Adapter.designWidth, Adapter.designHeight),
        context: context,
        minTextAdapt: true,
        orientation: Orientation.portrait);
    return Scaffold(// 判断是否首次打开，不是首次打开使用启动页图片衔接安卓原生启动页
        body: Stack(
          children: [
            CustomPaint(painter: MyPainter(),),
            AnimatedOpacity(
              opacity: _visible ? 1 : 0,
              onEnd: _onEnd,
              duration: Duration(seconds: 1),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: px(200),
                    height: px(200),
                    margin: EdgeInsets.only(top: px(252),bottom: px(34)),
                    child: Image.asset('lib/assets/images/login/logo.png',),
                  ),
                  GradientText(
                  '排查工具',
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,end: Alignment.bottomCenter,
                      colors: const [Color(0xff80D4FF), Color(0xff5778FF),Color(0xff5778FF )]
                  ),
                  style: TextStyle(fontSize: sp(46),fontFamily: 'M'
                  )),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: (){
                          Navigator.pushNamed(context, '/logIn');
                        },
                        child: _icon(),
                      )
                    ],
                  ),
                ],
              ),
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

  /// AnimatedOpacity 动画结束回调方法
  void _onEnd() {
    if (_visible && _change) {
      setState(() {
        _visible = false;
      });
    }
    if (_change) {
      setState(() {
        _index += 1;
        _visible = true;
        _change = false;
      });
    }
  }
  void initData() async {
    // PackageInfo _packageInfo = PackageInfo(
    //   appName: 'Unknown',
    //   packageName: 'Unknown',
    //   version: 'Unknown',
    //   buildNumber: 'Unknown',
    // );
    // _packageInfo = await PackageInfo.fromPlatform();

    // if (Platform.isIOS) {
    //   _upApp(packageInfo: 2, version: _packageInfo.version);
    //   //ios相关代码
    // } else if (Platform.isAndroid) {
    //   _upApp(packageInfo: 1, version: _packageInfo.version);
    //   //android相关代码
    // }
  }

  // 获取版本信息
  void _upApp({required int packageInfo, required String version}) async {
    Map<String, dynamic> _data = {
      'platformName': version,
      'type': packageInfo,
    };
    var response = await Request().post(Api.url['version'], data: _data);
    if (response['code'] == 200 && response['data']['seccut'] == true) {
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
          version: response['data']['version'],
          msg: response['data']['msgName'],
          isForced: true,
          path: response['data']['path'],
        );
        //android相关代码
      }
    }
  }

// 跳转下载页
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
                // child: UpApp(
                //   msg: msg,
                //   version: version,
                //   isForced: isForced,
                //   path: Api.BASE_URL_APP + '$path',
                // ),
              ),
          );
        },
      );
    });
  }
}

class MyPainter extends CustomPainter {
  @override

  Rect rect2 = Rect.fromCircle(center: Offset(200.0, Adapt.screenH()+px(50)), radius: px(600));

  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..shader = LinearGradient(colors: [Color(0xff80A2FF), Color(0xff4D7DFF)]).createShader(rect2);
    const PI = 3.1415;

    canvas.drawArc(rect2, 0.0, -PI, true, paint);
  }


  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class GradientText extends StatelessWidget {
  GradientText(this.data, {required this.gradient,
        this.style,
        this.textAlign = TextAlign.left});

  final String data;
  final TextStyle? style;
  final Gradient gradient;
  final TextAlign textAlign;

  // Gradient gradient = LinearGradient(begin: Alignment.topCenter,end: Alignment.bottomCenter,
  //     colors: [Color.fromRGBO(254, 117, 66, 1),Color.fromRGBO(255, 44, 70, 1)]);

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) {
        return gradient.createShader(Offset.zero & bounds.size);
      },
      blendMode: BlendMode.srcIn,
      child: Text(
        data,
        textAlign: textAlign,
        style: (style == null)
            ? TextStyle(color: Colors.white)
            : style?.copyWith(color: Colors.white),
      ),
    );
  }
}