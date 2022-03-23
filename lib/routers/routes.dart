import 'package:flutter/material.dart';
import 'package:scet_check/components/generalduty/pdf_view.dart';
import 'package:scet_check/components/generalduty/toast_widget.dart';
import 'package:scet_check/components/pertinence/companyFile/company_file.dart';
import 'package:scet_check/page/module_enterprise/abarbeitung/abarbeitung_from.dart';
import 'package:scet_check/page/module_enterprise/abarbeitung/enterprise_inventory.dart';
import 'package:scet_check/page/module_enterprise/abarbeitung/fill_abarbeitung.dart';
import 'package:scet_check/page/module_enterprise/enterprise_home.dart';
import 'package:scet_check/page/module_protection_agency/protection_agency_home.dart';
import 'package:scet_check/page/module_steward/check/hiddenParame/hidden_details.dart';
import 'package:scet_check/page/module_steward/check/hiddenParame/rectification_problem.dart';
import 'package:scet_check/page/module_steward/check/hiddenParame/steward_check.dart';
import 'package:scet_check/page/module_steward/check/potentialRisks/fill_in_form.dart';
import 'package:scet_check/page/module_steward/check/potentialRisks/screening_based.dart';
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
  '/enterpriseHome': (context) =>  EnterpriseHome(), //企业 根路由
  '/protectionAgencyHome': (context) =>  ProtectionAgencyHome(), //环保局 根路由
  '/rectificationProblem': (context,{arguments}) =>  RectificationProblem(arguments:arguments), //企业台账详情
  '/hiddenDetails': (context,{arguments}) =>  HiddenDetails(arguments:arguments), //隐患公司详情
  '/enterpriseDetails': (context,{arguments}) =>  EnterpriseDetails(arguments:arguments), //企业管理详情
  '/fillInForm': (context,{arguments}) =>  FillInForm(arguments:arguments), //排查问题填报
  '/fileLists': (context,{arguments}) =>  FileLists(arguments:arguments), //政策文件列表
  '/essentialList': (context,{arguments}) =>  EssentialList(arguments:arguments), //排查要点列表
  '/essentialDetails': (context,{arguments}) =>  EssentialDetails(arguments:arguments), //排查要点详情
  '/screeningBased': (context,{arguments}) =>  ScreeningBased(arguments:arguments), //排查要点/法律法规
  '/stewardCheck': (context,{arguments}) =>  StewardCheck(arguments:arguments), //管家排查
  '/PDFView': (context,{arguments}) =>  PDFView(pathPDF:arguments), //PDF页面
  '/CompanyFile': (context,{arguments}) =>  CompanyFile(arguments:arguments), //一企一档

///企业端
  '/enterprisInventory': (context,{arguments}) =>  EnterprisInventory(arguments:arguments), //企业清单详情
  '/abarbeitungFrom': (context,{arguments}) =>  AbarbeitungFrom(arguments:arguments), //企业清单详情
  '/fillAbarabeitung': (context,{arguments}) =>  FillAbarabeitung(arguments:arguments), //填报整改问题 / 复查填报
};

// 使用
// Navigator.pushNamed(context, '/productsPage',arguments: val);

// 统一处理
onGenerateRoute (RouteSettings settings) {
  final String? name = settings.name;
  final Function? pageContentBuilder = routes[name];
  if (pageContentBuilder != null) {
    if (settings.arguments != null) {
      final Route route = MaterialPageRoute(
          settings: RouteSettings(name: name),
          builder: (context) =>
              pageContentBuilder(context, arguments: settings.arguments));
      return route;
    } else {
      final Route route =
          MaterialPageRoute(
              settings: RouteSettings(name: name),
              builder: (context) => pageContentBuilder(context));
      return route;
    }
  } else {
    ToastWidget.showToastMsg('跳转页面错误');
    return null;
  }
}
