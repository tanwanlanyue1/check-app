
class Api {

  // static const baseUrlApp = 'http://10.10.1.217:8687/';
  static const baseUrlApp = 'https://dev.scet.com.cn/yhpc/';

  static const baseUrlAppTwo = 'http://gjpt.scet.com.cn:18002/';
  static const baseUrlAppImage = 'http://gjpt.scet.com.cn:18002/housekeeperPlatform/';

  static final Map url = {
    'version': baseUrlApp + '/manualInsert/platFromXiaZai',//版本更新

    'user': baseUrlApp + 'user',//获取用户数据

    'userList': baseUrlApp + 'user/list',//获取片区用户

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
    'houseTask':baseUrlAppTwo + 'housekeeperPlatform/d-admin/task/findPageByApp',//任务工单管理

    'teamFindList':baseUrlAppTwo + 'housekeeperPlatform/d-admin/team/findMemberList',//条件查询所有团队

    'housekeeper':baseUrlAppTwo + 'housekeeperPlatform/d-admin/dynamic-form/getDynamicFormById',//表单管理

    'issueSave':baseUrlAppTwo + 'housekeeperPlatform/d-admin/issue/save',//表单问题提交

    'saveForm':baseUrlAppTwo + 'housekeeperPlatform/d-admin/issue/saveForm',//动态表单单条提交

    'findList':baseUrlAppTwo + 'housekeeperPlatform/d-admin/dynamic-form/findList',//条件查询所有动态表单

    'addTaskForm':baseUrlAppTwo + 'housekeeperPlatform/d-admin/task/addTaskForm',//条件查询所有动态表单

    'mainType':baseUrlAppTwo + 'housekeeperPlatform/d-admin/issue-type/mainType',//动态表单问题大类列表

    'subType':baseUrlAppTwo + 'housekeeperPlatform/d-admin/issue-type/',//动态表单问题小类列表

    'modelAnalyzeById':baseUrlAppTwo + 'housekeeperPlatform/d-admin/model-analyze/getModelAnalyzeById',//根据id获取核查操作

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