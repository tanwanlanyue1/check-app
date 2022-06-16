
class Api {

  // static const baseUrlApp = 'http://10.10.1.217:8687/';
  static const baseUrlApp = 'https://dev.scet.com.cn/yhpc/';
  static const baseUrlAppTwo = 'http://119.3.103.76:8119/';
  static const baseUrlAppImage = 'http://119.3.103.76:8119/housekeeperPlatform/';


  static final Map url = {
    'version': baseUrlApp + '/manualInsert/platFromXiaZai',//版本更新

    'user': baseUrlApp + 'user',//获取用户数据

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

    "uploadImg": baseUrlApp + 'file/upload?savePath=清单/',// 上传图片

    'problem': baseUrlApp + 'problem',//获取问题

    'problemSubmit': baseUrlApp + 'problem/submit',//问题提交

    'problemList': baseUrlApp + 'problem/list',//问题分页列表

    'problemSearch': baseUrlApp + 'problem/search',//问题搜索

    'problemStatistics': baseUrlApp + 'problem/statistics',//问题统计数目

    'problemCount': baseUrlApp + 'problem/count',//获取数据总数

    'problemType': baseUrlApp + 'problem_type',//问题类型

    'solution': baseUrlApp + 'solution',//整改

    'solutionList': baseUrlApp + 'solution/list',//整改分页列表

    'review': baseUrlApp + 'review',//复查

    'basis': baseUrlApp + 'basis',//排查依据

    'basisList': baseUrlApp + 'basis/list',//排查依据分页列表

    'reviewList': baseUrlApp + 'review/list',//复查分页列表

    'inventoryReport': baseUrlApp + 'inventory_report',//清单报告

    'addTask': baseUrlApp + 'task',//任务/任务详情

    'taskList': baseUrlApp + 'task/list',//任务分页列表

    'fileSearch': baseUrlApp + 'law/search',//法律文件搜索

    'versions':baseUrlApp + 'version/list',//检测App更新

    ///对接的借口
    'houseTask':baseUrlAppTwo + 'housekeeperPlatform/d-admin/task/findPageByApp',//任务工单管理

    'housekeeper':baseUrlAppTwo + 'housekeeperPlatform/d-admin/dynamic-form/getDynamicFormById',//表单管理

    'issueSave':baseUrlAppTwo + 'housekeeperPlatform/pm/issue/save',//表单问题提交

    'houseTaskList':'https://mock.apifox.cn/m1/1125332-0-default/housekeeperPlatform/d-admin/task/findPageByApp',//对接任务列表

    'houseTaskById':baseUrlAppTwo + 'housekeeperPlatform/d-admin/task/getTaskById',//对接任务id查询详情

    'submitTask':baseUrlAppTwo + 'housekeeperPlatform/d-admin/task/commitTask',//对接任务提交

    'findAcidityLiquidPage':baseUrlAppTwo + 'housekeeperPlatform/d-admin/company/findAcidityLiquidPage',//涉酸性液体信息-分页查询

    'findDetectDataPage':baseUrlAppTwo + 'housekeeperPlatform/d-admin/company/findDetectDataPage',//LDAR检测数据-分页查询

    'findEmergencyDrillPage':baseUrlAppTwo + 'housekeeperPlatform/d-admin/company/findEmergencyDrillPage',//应急演练信息-分页查询

    'findEmergencyExpertPage':baseUrlAppTwo + 'housekeeperPlatform/d-admin/company/findEmergencyExpertPage',//应急专家信息-分页查询

    'findEmergencyPage':baseUrlAppTwo + 'housekeeperPlatform/d-admin/company/findEmergencyPage',//应急信息-分页查询

    'findEmergencyPlanPage':baseUrlAppTwo + 'housekeeperPlatform/d-admin/company/findEmergencyPlanPage',//应急预案信息-分页查询

    'findEmergencyTrainingPage':baseUrlAppTwo + 'housekeeperPlatform/d-admin/company/findEmergencyTrainingPage',//应急培训信息-分页查询

    'findFacilityRunSafeSituationPage':baseUrlAppTwo + 'housekeeperPlatform/d-admin/company/findFacilityRunSafeSituationPage',//设施的运行安全情况-分页查询

    'findHazardousWastePage':baseUrlAppTwo + 'housekeeperPlatform/d-admin/company/findHazardousWastePage',//危险废物信息-分页查询

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

    'findRadiationEmergencyPage':baseUrlAppTwo + 'housekeeperPlatform/d-admin/company/findRadiationEmergencyPage',//辐射安全与防护设施运行和管理，高风险移动放射源在线-分页查询

    'addFile':baseUrlAppTwo + 'housekeeperPlatform/d-admin/file/uploadFile',//上传文件


  };
}