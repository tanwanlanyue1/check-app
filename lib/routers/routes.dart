import 'package:flutter/material.dart';
import 'package:scet_check/components/generalduty/toast_widget.dart';
import 'package:scet_check/components/pertinence/companyFile/company_file.dart';
import 'package:scet_check/page/module_steward/check/hiddenParame/hidden_details.dart';
import 'package:scet_check/page/module_steward/check/hiddenParame/rectification_problem.dart';
import 'package:scet_check/page/module_steward/check/hiddenParame/steward_check.dart';
import 'package:scet_check/page/module_steward/check/potentialRisks/fill_in_form.dart';
import 'package:scet_check/page/module_steward/enterprise/enterprise_details.dart';
import 'package:scet_check/page/module_steward/home_page.dart';
import 'package:scet_check/page/module_steward/law/essential_details.dart';
import 'package:scet_check/page/module_steward/law/essential_list.dart';
import 'package:scet_check/page/module_steward/law/file_lists.dart';
import 'package:scet_check/page/module_login/guide_page.dart';
import 'package:scet_check/page/module_login/login_page.dart';


/// 配置静态路由
final routes = {
  '/': (context) =>  GuidePage(), //引导页  GuidePage
  '/logIn': (context) =>  LoginPage(), //登录页面
  '/steward': (context) =>  HomePage(), //管家 根路由
  '/rectificationProblem': (context,{arguments}) =>  RectificationProblem(arguments:arguments), //企业台账详情
  '/hiddenDetails': (context,{arguments}) =>  HiddenDetails(arguments:arguments), //隐患公司详情
  '/enterpriseDetails': (context,{arguments}) =>  EnterpriseDetails(arguments:arguments), //企业管理详情
  '/fillInForm': (context,{arguments}) =>  FillInForm(arguments:arguments), //排查问题填报
  '/fileLists': (context,{arguments}) =>  FileLists(arguments:arguments), //政策文件列表
  '/essentialList': (context,{arguments}) =>  EssentialList(), //排查要点列表
  '/essentialDetails': (context,{arguments}) =>  EssentialDetails(), //排查要点详情
  '/stewardCheck': (context,{arguments}) =>  StewardCheck(), //管家排查
  '/CompanyFile': (context,{arguments}) =>  CompanyFile(arguments:arguments), //一企一档
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
