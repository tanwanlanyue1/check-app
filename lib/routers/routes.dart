import 'package:flutter/material.dart';
import 'package:scet_check/components/generalduty/pdf_view.dart';
import 'package:scet_check/components/generalduty/toast_widget.dart';
import 'package:scet_check/components/pertinence/companyEchart/column_echarts.dart';
import 'package:scet_check/components/pertinence/companyFile/company_file.dart';
import 'package:scet_check/page/module_enterprise/abarbeitung/abarbeitung_from.dart';
import 'package:scet_check/page/module_enterprise/abarbeitung/enterprise_inventory.dart';
import 'package:scet_check/page/module_enterprise/abarbeitung/fill_abarbeitung.dart';
import 'package:scet_check/page/module_enterprise/enterprise_home.dart';
import 'package:scet_check/page/module_protection_agency/protection_agency_home.dart';
import 'package:scet_check/page/module_steward/check/check_page.dart';
import 'package:scet_check/page/module_steward/check/hiddenParame/hidden_details.dart';
import 'package:scet_check/page/module_steward/check/hiddenParame/hidden_parameter.dart';
import 'package:scet_check/page/module_steward/check/hiddenParame/problem_schedule.dart';
import 'package:scet_check/page/module_steward/check/hiddenParame/rectification_problem.dart';
import 'package:scet_check/page/module_steward/check/hiddenParame/steward_check.dart';
import 'package:scet_check/page/module_steward/check/potentialRisks/fill_in_form.dart';
import 'package:scet_check/page/module_steward/check/potentialRisks/screening_based.dart';
import 'package:scet_check/page/module_steward/check/statisticAnaly/home_classify.dart';
import 'package:scet_check/page/module_steward/check/targetClassify/target_classify.dart';
import 'package:scet_check/page/module_steward/check/targetClassify/target_classify_list.dart';
import 'package:scet_check/page/module_steward/check/targetClassify/target_details.dart';
import 'package:scet_check/page/module_steward/enterprise/abutment_enterprise/abutment_enterprise_details.dart';
import 'package:scet_check/page/module_steward/enterprise/enterprise_details.dart';
import 'package:scet_check/page/module_steward/enterprise/enterprise_page.dart';
import 'package:scet_check/page/module_steward/home_page.dart';
import 'package:scet_check/page/module_steward/law/essential_details.dart';
import 'package:scet_check/page/module_steward/law/essential_list.dart';
import 'package:scet_check/page/module_steward/law/file_lists.dart';
import 'package:scet_check/page/module_login/guide_page.dart';
import 'package:scet_check/page/module_login/login_page.dart';
import 'package:scet_check/page/module_steward/law/fill_details.dart';
import 'package:scet_check/page/module_steward/law/law_page.dart';
import 'package:scet_check/page/module_steward/law/policy_stand.dart';
import 'package:scet_check/page/module_steward/message/message_details.dart';
import 'package:scet_check/page/module_steward/message/message_page.dart';
import 'package:scet_check/page/module_steward/personal/audit_list.dart';
import 'package:scet_check/page/module_steward/personal/audit_problem.dart';
import 'package:scet_check/page/module_steward/personal/task/abutment/abutment_from.dart';
import 'package:scet_check/page/module_steward/personal/task/abutment/abutment_list.dart';
import 'package:scet_check/page/module_steward/personal/task/abutment/abutment_task.dart';
import 'package:scet_check/page/module_steward/personal/task/back_task_details.dart';
import 'package:scet_check/page/module_steward/personal/task/backlog_task.dart';
import 'package:scet_check/page/module_steward/personal/task/abutment/check_task.dart';
import 'package:scet_check/page/module_steward/personal/task/have_done_task.dart';
import 'package:scet_check/page/module_steward/personal/history_task.dart';
import 'package:scet_check/page/module_steward/personal/task/task_details.dart';


/// 配置静态路由
final routes = {
  '/': (context) =>  GuidePage(), //引导页  GuidePage
  '/logIn': (context) =>  LoginPage(), //登录页面
  '/steward': (context,{arguments}) =>  HomePage(index: arguments,), //管家 根路由
  '/enterpriseHome': (context) =>  EnterpriseHome(), //企业 根路由
  '/protectionAgencyHome': (context) =>  ProtectionAgencyHome(), //环保局 根路由
  '/checkPage': (context) =>  CheckPage(), //隐患排查
  '/rectificationProblem': (context,{arguments}) =>  RectificationProblem(arguments:arguments), //企业台账详情
  '/hiddenDetails': (context,{arguments}) =>  HiddenDetails(arguments:arguments), //隐患公司详情
  '/enterpriseDetails': (context,{arguments}) =>  EnterpriseDetails(arguments:arguments), //企业管理详情
  '/fillInForm': (context,{arguments}) =>  FillInForm(arguments:arguments), //排查问题填报
  '/fileLists': (context,{arguments}) =>  FileLists(arguments:arguments), //政策文件列表
  '/fillDetails': (context,{arguments}) =>  FillDetails(arguments:arguments), //政策文件详情
  '/essentialList': (context,{arguments}) =>  EssentialList(arguments:arguments), //排查要点列表
  '/essentialDetails': (context,{arguments}) =>  EssentialDetails(arguments:arguments), //排查要点详情
  '/screeningBased': (context,{arguments}) =>  ScreeningBased(arguments:arguments), //排查要点/法律法规
  '/stewardCheck': (context,{arguments}) =>  StewardCheck(arguments:arguments), //管家排查
  '/PDFView': (context,{arguments}) =>  PDFView(pathPDF:arguments), //PDF页面
  '/companyFile': (context,{arguments}) =>  CompanyFile(arguments:arguments), //一企一档
  '/messageDetailsPage': (context) =>  MessageDetailsPage(), //通知消息详情
  '/homeClassify': (context) =>  HomeClassify(), //首页分类
  '/historyTask': (context,{arguments}) =>  HistoryTask(arguments:arguments), //历史台账
  '/backlogTask': (context,{arguments}) =>  BacklogTask(arguments:arguments), //待办任务
  '/backTaskDetails': (context,{arguments}) =>  BackTaskDetails(arguments:arguments), //待办任务详情
  '/haveDoneTask': (context) =>  HaveDoneTask(), //已办任务
  '/taskDetails': (context,{arguments}) =>  TaskDetails(arguments:arguments), //任务详情
  '/policyStand': (context,{arguments}) =>  PolicyStand(topBar: arguments,), //规范标准
  '/targetClassifyPage': (context) =>  TargetClassifyPage(), //指标分类页
  '/targetClassifyList': (context,{arguments}) =>  TargetClassifyList(arguments:arguments), //指标详情列表
  '/targetDetails': (context,{arguments}) =>  TargetDetails(arguments:arguments), //指标详情
  '/enterprisePage': (context,{arguments}) =>  EnterprisePage(arguments:arguments), //企业管理
  '/hiddenParameter': (context) =>  HiddenParameter(), //隐患台账
  '/columnEcharts': (context) =>  ColumnEcharts(), //隐患台账
  '/messagePage': (context,{arguments}) =>  MessagePage(arguments:arguments), //通知中心
  '/checkTask': (context,{arguments}) =>  CheckTask(arguments:arguments), //选择任务
  '/lawPage': (context,{arguments}) =>  LawPage(skip:arguments), //工具箱
  '/problemSchedule': (context,{arguments}) =>  ProblemSchedule(arguments:arguments), //问题进度
  '/auditList': (context,{arguments}) =>  AuditList(), //清单审核列表
  '/auditProblem': (context,{arguments}) =>  AuditProblem(arguments:arguments), //清单问题审核

  '/abutmentList': (context,{arguments}) =>  AbutmentList(arguments:arguments), //对接任务列表页面
  '/abutmentTask': (context,{arguments}) =>  AbutmentTask(arguments:arguments), //对接任务详情页面
  '/abutmentFrom': (context,{arguments}) =>  AbutmentFrom(arguments:arguments), //对接任务动态表单详情
  '/abutmentEnterpriseDetails': (context,{arguments}) =>  AbutmentEnterpriseDetails(arguments:arguments), //对接一企一档信息

///企业端
  '/enterprisInventory': (context,{arguments}) =>  EnterprisInventory(arguments:arguments), //企业清单详情
  '/abarbeitungFrom': (context,{arguments}) =>  AbarbeitungFrom(arguments:arguments), //企业清单详情
  '/fillAbarbeitung': (context,{arguments}) =>  FillAbarbeitung(arguments:arguments), //填报整改问题 / 复查填报
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
          // settings: RouteSettings(name: name),
          builder: (context) =>
              pageContentBuilder(context, arguments: settings.arguments));
      return route;
    } else {
      final Route route =
          MaterialPageRoute(
              // settings: RouteSettings(name: name),
              builder: (context) => pageContentBuilder(context));
      return route;
    }
  } else {
    ToastWidget.showToastMsg('跳转页面错误');
    return null;
  }
}
