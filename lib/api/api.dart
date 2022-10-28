
class Api {

  // static const baseUrlApp = 'http://10.10.1.217:8687/';
  // static const baseUrlApp = 'https://dev.scet.com.cn/yhpc/';
  static const baseUrlApp = 'http://121.199.24.82:8350/';

  static const baseUrlAppTwo = 'http://121.199.24.82:18002/';
  static const baseUrlAppImage = 'http://121.199.24.82:18002/housekeeperPlatform';
  // static const baseUrlAppTwo = 'http://119.3.103.76:8119/';
  // static const baseUrlAppImage = 'http://119.3.103.76:8119/housekeeperPlatform/';

  static final Map url = {
    'version': baseUrlApp + '/manualInsert/platFromXiaZai',//版本更新

    'user': baseUrlApp + 'user',//获取用户数据

    'synchronize': baseUrlApp + 'schedule/synchronize',//修改密码后同步用户数据

    'login': baseUrlApp + 'auth/login',//登录

    'district': baseUrlApp + 'district',//片区统计

    'industry': baseUrlApp + 'industry',//行业

    'lawFile': baseUrlApp + 'law',//法律文件

    'company': baseUrlApp + 'company',//获取全部企业

    'companyId': baseUrlApp + 'company',//获取企业详情

    'companyList': baseUrlApp + 'company/list',//企业分页列表

    'companyCount': baseUrlApp + 'company/count',//获取企业数据总数

    'inventory': baseUrlApp + 'inventory',//保存清单

    'inventoryList': baseUrlApp + 'inventory/list',//清单分页列表

    "uploadImg": baseUrlApp + 'file/upload?savePath=',// 上传图片/文件

    'problem': baseUrlApp + 'problem',//获取问题

    'problemSubmit': baseUrlApp + 'problem/submit',//问题提交

    'problemList': baseUrlApp + 'problem/list',//问题分页列表

    'problemSearch': baseUrlApp + 'problem/search',//问题搜索

    'problemStatistics': baseUrlApp + 'problem/statistics',//问题统计数目

    'statistics': baseUrlApp + 'industry/statistics/problem',//按照行业统计数目

    'problemCount': baseUrlApp + 'problem/count',//获取数据总数

    'problemType': baseUrlApp + 'problem_type',//问题类型

    'problemTypeList': baseUrlApp + 'problem_type/list',//问题类型list

    'solution': baseUrlApp + 'solution',//整改

    'solutionList': baseUrlApp + 'solution/list',//整改分页列表

    'review': baseUrlApp + 'review',//复查

    'basis': baseUrlApp + 'basis',//排查依据

    'basisList': baseUrlApp + 'basis/list',//排查依据分页列表

    'target': baseUrlApp + 'target',//指标详情查询

    'targetList': baseUrlApp + 'target/list',//指标分页列表

    'targetCompany': baseUrlApp + 'target_company',//保存指标企业

    'targetCompanyList': baseUrlApp + 'target_company/list',//指标企业分页列表

    'reviewList': baseUrlApp + 'review/list',//复查分页列表

    'inventoryReport': baseUrlApp + 'inventory_report',//清单报告

    'addTask': baseUrlApp + 'task',//任务/任务详情

    'taskList': baseUrlApp + 'task/list',//任务分页列表

    'fileSearch': baseUrlApp + 'law/search',//法律文件搜索

    'versions':baseUrlApp + 'version/list',//检测App更新

    ///对接的借口
    'modifyPassword':baseUrlAppTwo + 'housekeeperPlatform/d-admin/operator/modifyPassword',//修改密码

    'findNoticeManagePage':baseUrlAppTwo + 'housekeeperPlatform/d-admin/notice-manage/findNoticeManagePage',//分页查询通知公告

    'findMyNoticeManagePage':baseUrlAppTwo + 'housekeeperPlatform/d-admin/notice-manage/findMyNoticeManagePage',//分页查询我的通知公告

    'findNoticeReadPage':baseUrlAppTwo + 'housekeeperPlatform/d-admin/notice-read/findNoticeReadPage',//分页查询通知公告查阅记录表/查询反馈列表

    'feedbackNotice':baseUrlAppTwo + 'housekeeperPlatform/d-admin/notice-read/feedbackNotice',//回复通知公告

    'notify':baseUrlAppTwo + 'housekeeperPlatform/d-admin/issue/notify',//问题状态修改通知

    'knowledge':baseUrlAppTwo + 'housekeeperPlatform/d-admin/knowledge/findList',//知识库/法律文件

    'findKnowledgeSelector':baseUrlAppTwo + 'housekeeperPlatform/d-admin/knowledge/findKnowledgeSelector',//获取知识类型（小类）下拉列表

    'loginCount':baseUrlAppTwo + 'housekeeperPlatform/d-admin/login-log/loginCount',//登录统计

    'groupList':baseUrlAppTwo + 'housekeeperPlatform/d-admin/group/list',//选择分组

    'byOp':baseUrlAppTwo + 'housekeeperPlatform/d-admin/statistic/workLoad/byOp',//个人工作量

    'summaryFindPage':baseUrlAppTwo + 'housekeeperPlatform/d-admin/data-exception-summary/findPage',//在线监理，数据来源

    'problemIssue':baseUrlAppTwo + 'housekeeperPlatform/d-admin/issue/page',//问题复查，数据来源

    'problemDetail':baseUrlAppTwo + 'housekeeperPlatform/d-admin/issue',//问题复查

    'addBatchTask':baseUrlAppTwo + 'housekeeperPlatform/d-admin/task/addBatchTask',//批量新增任务工单

    'findDicByTypeCode':baseUrlAppTwo + 'housekeeperPlatform/d-admin/dictionary/findDicByTypeCode',//发布任务任务来源

    'houseTask':baseUrlAppTwo + 'housekeeperPlatform/d-admin/task/findPageByApp',//任务工单管理

    'teamFindList':baseUrlAppTwo + 'housekeeperPlatform/d-admin/team/findMemberList',//查询所有团队

    'findMemberList':baseUrlAppTwo + 'housekeeperPlatform/d-admin/team/findList',//条件查询所有团队

    'housekeeper':baseUrlAppTwo + 'housekeeperPlatform/d-admin/dynamic-form/getDynamicFormById',//表单管理

    'relevanceIssue':baseUrlAppTwo + 'housekeeperPlatform/d-admin/issue/list',//获取记录列表

    'issueSave':baseUrlAppTwo + 'housekeeperPlatform/d-admin/issue/save',//表单问题提交

    'saveForm':baseUrlAppTwo + 'housekeeperPlatform/d-admin/issue/saveForm',//动态表单单条提交

    'findList':baseUrlAppTwo + 'housekeeperPlatform/d-admin/dynamic-form/findList',//条件查询所有动态表单

    'addTaskForm':baseUrlAppTwo + 'housekeeperPlatform/d-admin/task/addTaskForm',//绑定动态表单

    'mainType':baseUrlAppTwo + 'housekeeperPlatform/d-admin/issue-type/mainType',//动态表单问题大类列表

    'subType':baseUrlAppTwo + 'housekeeperPlatform/d-admin/issue-type/',//动态表单问题小类列表

    'modelAnalyzeById':baseUrlAppTwo + 'housekeeperPlatform/d-admin/model-analyze/getModelAnalyzeById',//根据id获取核查操作

    'getSummaryById':baseUrlAppTwo + 'housekeeperPlatform/d-admin/data-exception-summary/getSummaryById',//查询研判汇总详情（查询单次研判所有异常）

    'findExceptionPage':baseUrlAppTwo + 'housekeeperPlatform/d-admin/data-exception-record/findExceptionPage',//分页查询研判记录的异常数据

    'houseTaskList':baseUrlAppTwo + 'housekeeperPlatform/d-admin/task/findPageByApp',//对接任务列表

    'houseTaskById':baseUrlAppTwo + 'housekeeperPlatform/d-admin/task/getTaskById',//对接任务id查询详情

    'submitTask':baseUrlAppTwo + 'housekeeperPlatform/d-admin/task/commitTask',//对接任务提交

    'approvalTask':baseUrlAppTwo + 'housekeeperPlatform/d-admin/task/approvalTask',//审批任务工单

    'findEnvironProtectDetail':baseUrlAppTwo + 'housekeeperPlatform/d-admin/company/findEnvironProtectDetail',//环保扩展信息-根据企业id查看详情

    'findAcidityLiquidPage':baseUrlAppTwo + 'housekeeperPlatform/d-admin/company/findAcidityLiquidPage',//涉酸性液体信息-分页查询

    'findDetectDataPage':baseUrlAppTwo + 'housekeeperPlatform/d-admin/company/findDetectDataPage',//LDAR检测数据-分页查询

    'findEmergencyDrillPage':baseUrlAppTwo + 'housekeeperPlatform/d-admin/company/findEmergencyDrillPage',//应急演练信息-分页查询

    'findEmergencyExpertPage':baseUrlAppTwo + 'housekeeperPlatform/d-admin/company/findEmergencyExpertPage',//应急专家信息-分页查询

    'findEmergencyPage':baseUrlAppTwo + 'housekeeperPlatform/d-admin/company/findEmergencyPage',//应急信息-分页查询

    'findEmergencyPlanPage':baseUrlAppTwo + 'housekeeperPlatform/d-admin/company/findEmergencyPlanPage',//应急预案信息-分页查询

    'findEmergencyTrainingPage':baseUrlAppTwo + 'housekeeperPlatform/d-admin/company/findEmergencyTrainingPage',//应急培训信息-分页查询

    'findFacilityRunSafeSituationPage':baseUrlAppTwo + 'housekeeperPlatform/d-admin/company/findFacilityRunSafeSituationPage',//设施的运行安全情况-分页查询

    'findHazardousWastePage':baseUrlAppTwo + 'housekeeperPlatform/d-admin/company/findHazardousWastePage',//危险废物信息-分页查询

    'findEmergencyMaterialsPage':baseUrlAppTwo + 'housekeeperPlatform/d-admin/company/findEmergencyMaterialsPage',//应急物资信息-分页查询

    'findNoiseEmissionPage':baseUrlAppTwo + 'housekeeperPlatform/d-admin/company/findNoiseEmissionPage',//噪声排放信息-分页查询

    'findOffRoadMechanicalPage':baseUrlAppTwo + 'housekeeperPlatform/d-admin/company/findOffRoadMechanicalPage',//非道路机械信息-分页查询

    'findOnlineMonitorPage':baseUrlAppTwo + 'housekeeperPlatform/d-admin/company/findOnlineMonitorPage',//在线监测信息-分页查询

    'findPollutionSourcePage':baseUrlAppTwo + 'housekeeperPlatform/d-admin/company/findPollutionSourcePage',//污染源信息-分页查询

    'findProblemPage':baseUrlAppTwo + 'housekeeperPlatform/d-admin/company/findProblemPage',//问题信息-分页查询

    'findProductCraftPage':baseUrlAppTwo + 'housekeeperPlatform/d-admin/company/findProductCraftPage',//生产工艺信息-分页查询

    'findProductFacilitiesPage':baseUrlAppTwo + 'housekeeperPlatform/d-admin/company/findProductFacilitiesPage',//生产设施信息-分页查询

    'findProductPage':baseUrlAppTwo + 'housekeeperPlatform/d-admin/company/findProductPage',//产品信息-分页查询

    'findProjectPage':baseUrlAppTwo + 'housekeeperPlatform/d-admin/company/findProjectPage',//建设项目信息-分页查询

    'findRadiationAccidentHandlePage':baseUrlAppTwo + 'housekeeperPlatform/d-admin/company/findRadiationAccidentHandlePage',//辐射事故应急响应和处理能力-分页查询

    'findRadiationEmergencyPage':baseUrlAppTwo + 'housekeeperPlatform/d-admin/company/findRadiationEmergencyPage',//辐射事故应急情况-分页查询

    'findRadiationSafeManagementPage':baseUrlAppTwo + 'housekeeperPlatform/d-admin/company/findRadiationSafeManagementPage',//辐射安全与防护设施运行和管理，高风险移动放射源在线-分页查询

    'findRawMaterialPage':baseUrlAppTwo + 'housekeeperPlatform/d-admin/company/findRawMaterialPage',//原辅材料信息-分页查询

    'findRiskDevicePage':baseUrlAppTwo + 'housekeeperPlatform/d-admin/company/findRiskDevicePage',//风险装置信息-分页查询

    'findRiskSubstancePage':baseUrlAppTwo + 'housekeeperPlatform/d-admin/company/findRiskSubstancePage',//风险物质信息-分页查询

    'findSewageLicensePage':baseUrlAppTwo + 'housekeeperPlatform/d-admin/company/findSewageLicensePage',//排污许可信息-分页查询

    'findSolidWastePage':baseUrlAppTwo + 'housekeeperPlatform/d-admin/company/findSolidWastePage',//一般固废信息-分页查询

    'findThreeWasteManagementPage':baseUrlAppTwo + 'housekeeperPlatform/d-admin/company/findThreeWasteManagementPage',//辐射防护、辐射流出物和三废管理-分页查询

    'findViceProductPage':baseUrlAppTwo + 'housekeeperPlatform/d-admin/company/findViceProductPage',//副产品信息-分页查询

    'findWasteGasEmissionPage':baseUrlAppTwo + 'housekeeperPlatform/d-admin/company/findWasteGasEmissionPage',//废气排放信息-分页查询

    'findWasteGasTreatmentFacilitiesPage':baseUrlAppTwo + 'housekeeperPlatform/d-admin/company/findWasteGasTreatmentFacilitiesPage',//废气治理设施信息-分页查询

    'findWasteOrganicSolventPage':baseUrlAppTwo + 'housekeeperPlatform/d-admin/company/findWasteOrganicSolventPage',//废有机溶剂信息-分页查询

    'findWasteWaterEmissionPage':baseUrlAppTwo + 'housekeeperPlatform/d-admin/company/findWasteWaterEmissionPage',//废水排放信息-分页查询

    'findWasteWaterHandlePage':baseUrlAppTwo + 'housekeeperPlatform/d-admin/company/findWasteWaterHandlePage',//废水处理设施运行及排放情况-分页查询

    'findWasteWaterTreatmentFacilitiesPage':baseUrlAppTwo + 'housekeeperPlatform/d-admin/company/findWasteWaterTreatmentFacilitiesPage',//废水治理设施信息-分页查询

    'addFile':baseUrlAppTwo + 'housekeeperPlatform/d-admin/file/uploadFile',//上传文件


  };
}