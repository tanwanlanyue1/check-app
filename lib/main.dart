import 'dart:async';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:scet_check/model/data/data_global.dart';
import 'package:scet_check/model/provider/provider_details.dart';
import 'package:scet_check/routers/routes.dart';
import 'package:scet_check/utils/screen/adapter.dart';

import 'model/provider/provider_app.dart';
import 'model/provider/provider_home.dart';

void main() {

  // 自定义报错页面（打包后显示）
  if (kReleaseMode) {
    ErrorWidget.builder = (FlutterErrorDetails flutterErrorDetails) {
      debugPrint(flutterErrorDetails.toString());
      return const Material(
        child: Center(
            child: Text(
              "发生了没有处理的错误\n请通知开发者",
              textAlign: TextAlign.center,
            )
        ),
      );
    };
  }

  // 捕获并上报 Dart 异常（开发版）
  runZonedGuarded(() async {
    await Global.init();
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<AppState>.value(value: Global.appState,),
          ChangeNotifierProvider(create: (_) => ProviderDetaild(),),
          ChangeNotifierProvider(create: (_) => HomeModel(),)
        ],
        child:MyApp(routerStr: Global.router,),
      ),
    );
  }, (Object error, StackTrace stack) {
    print('出错：error==>,$error \n 出错：stack==>,$stack\n');
  });
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

class MyApp extends StatelessWidget {
  final String? routerStr;
  MyApp({Key? key, this.routerStr,}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(Adapter.designWidth, Adapter.designHeight),
        minTextAdapt: false,
        splitScreenMode: true,
        builder: () => MaterialApp(
          navigatorKey: navigatorKey,
          builder:(context, child) {
            final botToastBuilder = BotToastInit();
            ScreenUtil.setContext(context);
            child = botToastBuilder(context,child);
            return  MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
              child: child,
            );
          },
          title: '隐患排查与整改',
          navigatorObservers: <NavigatorObserver>[
            BotToastNavigatorObserver(),
            routeObserver
          ],
          debugShowCheckedModeBanner: false,
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate, // 对应的Cupertino风格
          ],
          supportedLocales: const [
            Locale('en', 'US'),
            Locale('zh', 'CH'),
          ],
          locale: const Locale('zh'),
          theme: ThemeData(
              primarySwatch: Provider.of<AppState>(context,listen: true).createMaterialColor(),
              primaryColor: Provider.of<AppState>(context,listen: true).primaryColor,
              visualDensity: VisualDensity.adaptivePlatformDensity,
              scaffoldBackgroundColor: const Color(0XFFF2F4FA),
              fontFamily: "R"
          ),
          initialRoute: routerStr,
          // onGenerateRoute: onGenerateRoute(RouteSettings settings),
          onGenerateRoute:(RouteSettings settings) =>onGenerateRoute(settings),
        ),
      );
  }
}
