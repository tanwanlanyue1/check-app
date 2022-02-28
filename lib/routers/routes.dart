import 'package:flutter/material.dart';
import 'package:scet_check/components/toast_widget.dart';
import 'package:scet_check/page/environmental_stewardship/check/hiddenParame/rectification_problem.dart';
import 'package:scet_check/page/environmental_stewardship/check/potentialRisks/fill_in_form.dart';
import 'package:scet_check/page/environmental_stewardship/home_page.dart';
import 'package:scet_check/page/environmental_stewardship/law/essential_details.dart';
import 'package:scet_check/page/environmental_stewardship/law/essential_list.dart';
import 'package:scet_check/page/environmental_stewardship/law/file_lists.dart';
import 'package:scet_check/page/module_login/login_page.dart';


// 配置静态路由
final routes = {
  '/': (context) =>  HomePage(), //引导页 根路由
  '/logIn': (context) =>  LoginPage(), //登录页面
  '/rectificationProblem': (context,{arguments}) =>  RectificationProblem(arguments:arguments), //企业台账详情
  '/fillInForm': (context,{arguments}) =>  FillInForm(arguments:arguments), //排查问题填报
  '/fileLists': (context,{arguments}) =>  FileLists(arguments:arguments), //政策文件列表
  '/essentialList': (context,{arguments}) =>  EssentialList(), //排查要点列表
  '/essentialDetails': (context,{arguments}) =>  EssentialDetails(), //排查要点详情
};

// 使用
// Navigator.pushNamed(context, '/productsPage',arguments: val);

// 统一处理
onGenerateRoute (RouteSettings settings) {
  final String? name = settings.name;
  final Function? pageContentBuilder = routes[name];
  if (pageContentBuilder != null) {
    // print(settings.name);
    if (settings.arguments != null) {
      final Route route = MaterialPageRoute(
          builder: (context) =>
              pageContentBuilder(context, arguments: settings.arguments));
      return route;
    } else {
      final Route route =
          MaterialPageRoute(builder: (context) => pageContentBuilder(context));
      return route;
    }
  } else {
    ToastWidget.showToastMsg('跳转页面错误');
    return null;
  }
}
