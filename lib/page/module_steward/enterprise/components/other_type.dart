import 'package:flutter/material.dart';
import 'package:scet_check/utils/screen/screen.dart';

/// 其他信息
class OtherType extends StatefulWidget {
  final String companyId;
  const OtherType({Key? key,required this.companyId}) : super(key: key);

  @override
  _OtherTypeState createState() => _OtherTypeState();
}

class _OtherTypeState extends State<OtherType> {
  String companyId = '4d7e400047754fb0fc9251b8e8aa8b24';//企业id
  final List _typeList = [
    {
      "name":"环保扩展信息",
      "path":'/abutmentEnterpriseDetails',
      'arguments':{
        'url': 'findEnvironProtectDetail',
        'id': '',
        "name":"环保扩展信息",
        'data':[
          {'title':'废水排放口数','valuer':'wasteWaterDisposalNum'},
          {'title':'噪音功能区类别','valuer':'noiseRibbonCategory'},
          {'title':'废气排放口数','valuer':'exhaustGasDisposalNum'},
          {'title':'空气质量功能区划级别','valuer':'airQualityRibbonLevel'},
          {'title':'COD 总量控制值','valuer':'controlValueCod'},
          {'title':'氨氮总量控制值','valuer':'controlValueNh3'},
          {'title':'氮氧化物总量控制值','valuer':'controlValueNo'},
          {'title':'SO2总量控制值','valuer':'controlValueSo2'},
          {'title':'海域功能区级别','valuer':'seaAreaRibbonLevel'},
          {'title':'是否水源区','valuer':'waterSourceArea'},
          {'title':'水源保护区级别','valuer':'waterSourceProtectionLevel'},
          {'title':'水源保护区代码','valuer':'waterSourceProtectionCode'},
          {'title':'水域功能区类别','valuer':'waterRibbonCategory'},
          {'title':'是否SO2控制区','valuer':'controlAreaSo2'},
          {'title':'是否酸雨控制区','valuer':'acidRainControlArea'},
        ]
      }
    },
    {
      "name":"产品信息",
      "path":'/abutmentEnterpriseDetails',
      'arguments':{
        'url': 'findProductPage',
        'id': '',
        "name":"产品信息",
        'data':[
          {'title':'主要成分','valuer':'mainIngredient'},
          {'title':'生产线','valuer':'productionLine'},
          {'title':'生产能力（t/a）','valuer':'productCapacity'},
          {'title':'批复产能（t/a）','valuer':'replyCapacity'},
          {'title':'产品状态','valuer':'productStatus'},
          {'title':'包装形式','valuer':'packageStyle'},
          {'title':'包装方式','valuer':'packingWay'},
          {'title':'储存方式','valuer':'storeStyle'},
          {'title':'运输方式','valuer':'transportWay'},
          {'title':'备注','valuer':'remark'},
        ]
      }
    },
    {
      "name":"原辅材料信息",
      "path":'/abutmentEnterpriseDetails',
      'arguments':{
        'url': 'findRawMaterialPage',
        'id': '',
        "name":"原辅材料信息",
        'data':[
          {'title':'原辅材料名称','valuer':'materialName'},
          {'title':'CAS号','valuer':'cas'},
          {'title':'主要成分','valuer':'mainIngredient'},
          {'title':'规格','valuer':'specification'},
          {'title':'产品状态','valuer':'productStatus'},
          {'title':'包装形式','valuer':'packageStyle'},
          {'title':'包装方式','valuer':'packingWay'},
          {'title':'储存方式','valuer':'storeStyle'},
          {'title':'运输方式','valuer':'transportWay'},
          {'title':'备注','valuer':'remark'},
        ]
      }
    },
    {
      "name":"生产设施信息",
      "path":'/abutmentEnterpriseDetails',
      'arguments':{
        'url': 'findProductFacilitiesPage',
        'id': '',
        "name":"生产设施信息",
        'data':[
          {'title':'主要工艺名称编号','valuer':'id'},
          {'title':'主要生产单元','valuer':'mainProductUnit'},
          {'title':'主要工艺名称','valuer':'mainCraftName'},
          {'title':'生产设施企业内部编号','valuer':'innerCode'},
          {'title':'生产设施排污许可证编号','valuer':'sewagePermitCode'},
          {'title':'生产设施参数','valuer':'param'},
          {'title':'生产设施位置','valuer':'location'},
          {'title':'生产设施经度','valuer':'lon'},
          {'title':'生产设施纬度','valuer':'lat'},
          {'title':'位置楼层','valuer':'floor'},
          {'title':'楼层高度','valuer':'floorHeight'},
          {'title':'原料投加方式','valuer':'dosingWay'},
          {'title':'反应时间','valuer':'reactionTime'},
          {'title':'反应温度','valuer':'reactionTemperature'},
          {'title':'反应压力','valuer':'reactionPressure'},
          {'title':'是否产生废水','valuer':'produceWasteWater'},
          {'title':'废水去向','valuer':'wasteWaterWhereabouts'},
          {'title':'废水是否收集处理','valuer':'wasteWaterHandled'},
          {'title':'是否产危废','valuer':'produceHazardousWaste'},
          {'title':'危废种类','valuer':'hazardousWasteCategory'},
          {'title':'危废去向','valuer':'hazardousWasteWhereabouts'},
          {'title':'是否产废气','valuer':'produceWasteGas'},
          {'title':'废气是否收集处理','valuer':'wasteGasHandled'},
          {'title':'废气预处理方式','valuer':'wasteGasHandleWay'},
          {'title':'废气最终治理设施编号','valuer':'treatmentFacilityCode'},
          {'title':'备注','valuer':'remark'},
        ]
      }
    },
    {
      "name":"排污许可信息",
      "path":'/abutmentEnterpriseDetails',
      'arguments':{
        'url': 'findSewageLicensePage',
        'id': '',
        "name":"排污许可信息",
        'data':[
          {'title':'是否有排污许可证/登记管理','valuer':'licenseCode'},
          {'title':'排污许可分类管理类型','valuer':'licenseType'},
          {'title':'排污许可证编号','valuer':'licenseCode'},
          {'title':'排污许可证核发部门','valuer':'licenseIssuedDept'},
          {'title':'排污许可证下发时间','valuer':'licenseDeliveryTime'},
          {'title':'排污许可证有效期','valuer':'licenseValidTime'},
          {'title':'是否有执行报告','valuer':'executiveReport'},
          {'title':'执行报告情况','valuer':'executiveReportType'},
          {'title':'是否按时提交执行报告','valuer':'executiveReportSubmitTimely'},
          {'title':'生产项目是否全部纳入排污许可中','valuer':'include'},
          {'title':'排污口是否与实际情况相符','valuer':'remark'},
          {'title':'是否整改证','valuer':'rectificationCertificate'},
          {'title':'整改时限','valuer':'rectificationDate'},
          {'title':'是否完成','valuer':'finish'},
          {'title':'是否建立环境管理台账','valuer':'buildLedger'},
          {'title':'是否制定自行监测方案','valuer':'formulateMonitorPlan'},
          {'title':'是否落实自行监测','valuer':'fulfilMonitorPlan'},
          {'title':'自行监测数据是否公开','valuer':'openMonitorData'},
          {'title':'备注','valuer':'remark'},
        ]
      }
    },
    {
      "name":"危险废物信息",
      "path":'/abutmentEnterpriseDetails',
      'arguments':{
        'url': 'findHazardousWastePage',
        'id': '',
        "name":"危险废物信息",
        'data':[
          {'title':'危险废物名称','valuer':'name'},
          {'title':'危废大代码','valuer':'bigCode'},
          {'title':'危废小代码','valuer':'smallCode'},
          {'title':'是否纳入管理计划','valuer':'includeManagePlan'},
          {'title':'是否纳入排污许可','valuer':'includeSewagePermit'},
          {'title':'排污许可许可量（t/a）','valuer':'sewageNum'},
          {'title':'上年度危废管理计划申报量（t）','valuer':'planDeclarationNum'},
          {'title':'上年度危废实际产生数量(t)','valuer':'actualProductNum'},
          {'title':'危废产生节点','valuer':'generateNode'},
          {'title':'危废处置方式','valuer':'handleWay'},
          {'title':'危废去向','valuer':'whereabouts'},
          {'title':'备注','valuer':'remark'},
        ]
      }
    },
    {
      "name":"一般固废信息",
      "path":'/abutmentEnterpriseDetails',
      'arguments':{
        'url': 'findSolidWastePage',
        'id': '',
        "name":"一般固废信息",
        'data':[
          {'title':'一般工业固废名称','valuer':'solidWasteName'},
          {'title':'是否纳入排污许可','valuer':'includeSewagePermit'},
          {'title':'排污许可许可量（t/a）','valuer':'sewageNum'},
          {'title':'产生节点','valuer':'generateNode'},
          {'title':'处置方式','valuer':'handleWay'},
          {'title':'去向','valuer':'whereabouts'},
          {'title':'备注','valuer':'remark'},
        ]
      }
    },
    {
      "name":"建设项目信息",
      "path":'/abutmentEnterpriseDetails',
      'arguments':{
        'url': 'findProjectPage',
        'id': '',
        "name":"建设项目信息",
        'data':[
          {'title':'建设项目名称','valuer':'projectName'},
          {'title':'环评编制单位','valuer':'compilationUnit'},
          {'title':'编制时间','valuer':'compilationTime'},
          {'title':'环评报告类型','valuer':'reportType'},
          {'title':'是否有环评批复','valuer':'reply'},
          {'title':'批复单位','valuer':'replyUnit'},
          {'title':'批复日期','valuer':'replyDate'},
          {'title':'批复文号','valuer':'replyCode'},
          {'title':'投产时间','valuer':'putProductTime'},
          {'title':'验收时间','valuer':'acceptTime'},
          {'title':'备注','valuer':'remark'},
        ]
      }
    },
    {
      "name":"在线监测信息",
      "path":'/abutmentEnterpriseDetails',
      'arguments':{
        'url': 'findOnlineMonitorPage',
        'id': '',
        "name":"在线监测信息",
        'data':[
          {'title':'在线监测设备名称','valuer':'monitorDeviceName'},
          {'title':'排污许可证编号','valuer':'sewagePermitCode'},
          {'title':'监测类型','valuer':'monitorType'},
          {'title':'排污许可证排口编号','valuer':'sewagePermitOutletNumber'},
          {'title':'排口名称','valuer':'outletName'},
          {'title':'在线监测因子','valuer':'onlineMonitoringFactor'},
          {'title':'污染物执行标准','valuer':'executiveStandard'},
          {'title':'污染物排放限值（mg/L或mg/m³）','valuer':'emissionLimitValue'},
          {'title':'安装时间','valuer':'installTime'},
          {'title':'是否联网','valuer':'networking'},
          {'title':'是否验收','valuer':'accept'},
          {'title':'验收单位','valuer':'acceptUnit'},
          {'title':'验收时间','valuer':'acceptTime'},
          {'title':'运维单位名称','valuer':'operationUnit'},
          {'title':'运维单位负责人姓名','valuer':'operationPeasonName'},
          {'title':'运维单位联系电话','valuer':'operationUnitPhone'},
          {'title':'备注','valuer':'remark'},
        ]
      }
    },
    {
      "name":"问题信息管理",
      "path":'/abutmentEnterpriseDetails',
      'arguments':{
        'url': 'findProblemPage',
        'id': '',
        "name":"问题信息管理",
        'data':[
          {'title':'检查日期','valuer':'checkDate'},
          {'title':'企业名称（单个企业不用显示）','valuer':'companyName'},
          {'title':'区域位置','valuer':'location'},
          {'title':'经度','valuer':'lon'},
          {'title':'纬度','valuer':'lat'},
          {'title':'问题类型','valuer':'problemType'},
          {'title':'具体问题','valuer':'content'},
          {'title':'整改措施','valuer':'correctiveMeasures'},
          {'title':'上传整改报告','valuer':'correctivePrincipal'},
          {'title':'整改负责人','valuer':'correctiveReport'},
          {'title':'备注','valuer':'remark'},
        ]
      }
    },
    {
      "name":"非道路机械信息",
      "path":'/abutmentEnterpriseDetails',
      'arguments':{
        'url': 'findOffRoadMechanicalPage',
        'id': '',
        "name":"非道路机械信息",
        'data':[
          {'title':'非道路移动机械名称','valuer':'mechanicalName'},
          {'title':'机械类型','valuer':'mechanicalType'},
          {'title':'机械型号','valuer':'mechanicalModel'},
          {'title':'燃料类型','valuer':'fuelType'},
          {'title':'排放阶段','valuer':'emissionStage'},
          {'title':'环保登记号码','valuer':'registerCode'},
          {'title':'是否进行尾气检测','valuer':'exhaustDetect'},
          {'title':'检测日期','valuer':'detectDate'},
          {'title':'检测报告编号','valuer':'detectReportCode'},
          {'title':'检测公司名称','valuer':'detectCompanyName'},
          {'title':'是否安装尾气净化装置','valuer':'installExhaustPurifyDevice'},
          {'title':'备注','valuer':'remark'},
        ]
      }
    },
    {
      "name":"污染源信息",
      "path":'/abutmentEnterpriseDetails',
      'arguments':{
        'url': 'findPollutionSourcePage',
        'id': '',
        "name":"污染源信息",
        'data':[
          {'title':'污染物类型','valuer':'pollutantsType'},
          {'title':'污染因子','valuer':'pollutionFactor'},
          {'title':'污染物排放标准','valuer':'emissionTandards'},
          {'title':'排放因子限值','valuer':'emissionFactorLimitValue'},
          {'title':'环评污染物排放总量（t/a）','valuer':'eiaEmissionTotal'},
          {'title':'排污许可污染物排放总量','valuer':'sewagePermitEmissionTotal'},
          {'title':'企业上年度实际污染物排放总量（t/a）','valuer':'actualEmissionTotal'},
          {'title':'是否超出排污许可证许可量/环评量','valuer':'exceed'},
          {'title':'备注','valuer':'remark'},
        ]
      }
    },
    {
      "name":"废气排放信息",
      "path":'/abutmentEnterpriseDetails',
      'arguments':{
        'url': 'findWasteGasEmissionPage',
        'id': '',
        "name":"废气排放信息",
        'data':[
          {'title':'废气排放口编号','valuer':'code'},
          {'title':'废气排放口名称','valuer':'name'},
          {'title':'废气排放口位置','valuer':'location'},
          {'title':'废气排放口经度','valuer':'lon'},
          {'title':'废气排放口纬度','valuer':'lat'},
          {'title':'废气排放口类型','valuer':'type'},
          {'title':'排气筒截取面积(㎡)','valuer':'exhaustPipeArea'},
          {'title':'排气筒高度(m)','valuer':'exhaustPipeHeight'},
          {'title':'废气排放标准','valuer':'emissionStandards'},
          {'title':'污染物种类','valuer':'pollutantsCategory'},
          {'title':'产废环节','valuer':'link'},
          {'title':'废气治理设施及工艺','valuer':'governanceFacilities'},
          {'title':'所在地区空气质量功能区划级别','valuer':'divisionLevel'},
          {'title':'自动监测设备安装情况','valuer':'deviceInstall'},
          {'title':'废气治理工艺与现场是否一致','valuer':'consistent'},
          {'title':'废气排放口标志牌安装','valuer':'installSign'},
          {'title':'备注','valuer':'remark'},
        ]
      }
    },
    {
      "name":"废水排放信息",
      "path":'/abutmentEnterpriseDetails',
      'arguments':{
        'url': 'findWasteWaterEmissionPage',
        'id': '',
        "name":"废水排放信息",
        'data':[
          {'title':'废水排放口编号','valuer':'code'},
          {'title':'废水排放口名称','valuer':'name'},
          {'title':'废水排放口位置','valuer':'location'},
          {'title':'废水排放口经度','valuer':'lon'},
          {'title':'废水排放口纬度','valuer':'lat'},
          {'title':'受纳水体功能区类别','valuer':'category'},
          {'title':'废水排口属性','valuer':'outletAttributes'},
          {'title':'废水排放去向','valuer':'whereabouts'},
          {'title':'排入污水处理厂名称','valuer':'treatmentPlantName'},
          {'title':'自动监测设备安装情况','valuer':'deviceInstall'},
          {'title':'废水排放标准','valuer':'emissionStandards'},
          {'title':'污染物种类','valuer':'pollutantsCategory'},
          {'title':'产废环节','valuer':'link'},
          {'title':'废水治理设施及工艺','valuer':'governanceFacilities'},
          {'title':'废水治理工艺与现场是否一致','valuer':'consistent'},
          {'title':'废水排放口标志牌安装','valuer':'installSign'},
          {'title':'备注','valuer':'remark'},
        ]
      }
    },
    {
      "name":"噪声排放信息",
      "path":'/abutmentEnterpriseDetails',
      'arguments':{
        'url': 'findNoiseEmissionPage',
        'id': '',
        "name":"噪声排放信息",
        'data':[
          {'title':'生产时段','valuer':'daytimeProductPeriod'},
          {'title':'厂界噪声排放限值','valuer':'daytimeEmissionLimitValue'},
        ]
      }
    },
    {
      "name":"生产工艺信息",
      "path":'/abutmentEnterpriseDetails',
      'arguments':{
        'url': 'findProductCraftPage',
        'id': '',
        "name":"生产工艺信息",
        'data':[
          {'title':'企业简称','valuer':'companyAbbreviation'},
          {'title':'工艺名称','valuer':'craftName'},
          {'title':'原料','valuer':'rawMaterial'},
          {'title':'中间产物','valuer':'midProduct'},
          {'title':'主要产品','valuer':'mainProducts'},
          {'title':'备注','valuer':'remark'},
        ]
      }
    },
    {
      "name":"风险装置信息",
      "path":'/abutmentEnterpriseDetails',
      'arguments':{
        'url': 'findRiskDevicePage',
        'id': '',
        "name":"风险装置信息",
        'data':[
          {'title':'装置名称','valuer':'deviceName'},
          {'title':'反应单元/工段','valuer':'reactionUnit'},
          {'title':'所属车间','valuer':'belongWorkshop'},
          {'title':'涉及物质','valuer':'involvingSubstances'},
          {'title':'所属企业','valuer':'belongCompany'},
          {'title':'风险级别','valuer':'riskLevel'},
          {'title':'经度','valuer':'lon'},
          {'title':'纬度','valuer':'lat'},
          {'title':'备注','valuer':'remark'},
        ]
      }
    },
    {
      "name":"风险物资信息",
      "path":'/abutmentEnterpriseDetails',
      'arguments':{
        'url': 'findRiskSubstancePage',
        'id': '',
        "name":"风险物资信息",
        'data':[
          {'title':'物质名称','valuer':'substanceName'},
          {'title':'气味特征','valuer':'odorFeature'},
          {'title':'臭气强度斜率系数','valuer':'slopeCoefficient'},
          {'title':'臭气强度截距系数','valuer':'interceptCoefficient'},
          {'title':'所属工艺','valuer':'belongCraft'},
          {'title':'涉及车间/装置区','valuer':'involveWorkshop'},
          {'title':'储存位置','valuer':'storeLocation'},
          {'title':'嗅阈值','valuer':'threshold'},
          {'title':'备注','valuer':'remark'},
        ]
      }
    },
    {
      "name":"LDAR检测数据信息",
      "path":'/abutmentEnterpriseDetails',
      'arguments':{
        'url': 'findDetectDataPage',
        'id': '',
        "name":"LDAR检测数据信息",
        'data':[
          {'title':'企业名称','valuer':'companyName'},
          {'title':'设备/管线号','valuer':'deviceCode'},
          {'title':'标签号','valuer':'labelCode'},
          {'title':'组件类型','valuer':'componentType'},
          {'title':'检测时间','valuer':'detectTime'},
          {'title':'净值（ppm）','valuer':'netWorth'},
          {'title':'备注','valuer':'remark'},
        ]
      }
    },
    {
      "name":"辐射安全许可信息",
      "path":'/abutmentEnterpriseDetails',
      'arguments':{
        'url': 'findThreeWasteManagementPage',
        'id': '',
        "name":"辐射安全许可信息",
        'data':[
          {'title':'重点排查放射性沾污事件处置','valuer':'eventHandle'},
          {'title':'放射性固体废物的产生','valuer':'generateSolidWaste'},
          {'title':'人员剂量管理','valuer':'doseManagement'},
          {'title':'处理和贮存情况','valuer':'storageSituation'},
          {'title':'放射性废物处理','valuer':'wasteDisposal'},
          {'title':'放射性废物信息核对与管理情况','valuer':'checkSituation'},
          {'title':'贮存设施的运行情况','valuer':'facilityRunSituation'},
          {'title':'排放合法依规情况','valuer':'emissionLegalSituation'},
          {'title':'环境监测的程序和记录','valuer':'environMonitorRecord'},
          {'title':'周边辐射环境水平及放射性气态','valuer':'radiationAmbientLevel'},
          {'title':'液态流出物监测实施情况','valuer':'monitorProcessSituation'},
          {'title':'备注','valuer':'remark'},
        ]
      }
    },
    {
      "name":"应急信息管理",
      "path":'/abutmentEnterpriseDetails',
      'arguments':{
        'url': 'findEmergencyPage',
        'id': '',
        "name":"应急信息管理",
        'data':[
          {'title':'是否编制《突发环境事件应急预案》、《突发环境事件风险评估》、《资源调查报告》','valuer':'compose'},
          {'title':'预案编写单位','valuer':'planWriteUnit'},
          {'title':'编制时间','valuer':'composeDate'},
          {'title':'是否已合规备案','valuer':'filing'},
          {'title':'应急预案备案时间','valuer':'planDate'},
          {'title':'应急预案有效期','valuer':'planEffectiveDate'},
          {'title':'应急预案备案部门','valuer':'planDept'},
          {'title':'应急预案备案编号','valuer':'planCode'},
          {'title':'预案备案风险级别','valuer':'planRiskLevel'},
          {'title':'是否在省平台备案','valuer':'provincePlatformFiling'},
          {'title':'突发环境事件预案内是否制定“危险废物应急预案及防范措施','valuer':'formulatePrecautions'},
          {'title':'本年度是否有组织培训','valuer':'training'},
          {'title':'培训时间','valuer':'trainingDate'},
          {'title':'本年度是否有开展应急演练','valuer':'startDrill'},
          {'title':'演练时间','valuer':'drillDate'},
          {'title':'是否编制重污染天气应急预案','valuer':'composePollutedWeatherFiling'},
        ]
      }
    },
    {
      "name":"应急预案管理",
      "path":'/abutmentEnterpriseDetails',
      'arguments':{
        'url': 'findEmergencyPlanPage',
        'id': '',
        "name":"应急预案管理",
        'data':[
          {'title':'预案名称','valuer':'planName'},
          {'title':'备案单位','valuer':'filingUnit'},
          {'title':'预案编写单位','valuer':'planWriteUnit'},
          {'title':'编制时间','valuer':'composeDate'},
          {'title':'是否已合规备案','valuer':'filing'},
          {'title':'应急预案备案时间','valuer':'planDate'},
          {'title':'应急预案有效期','valuer':'planEffectiveDate'},
          {'title':'应急预案备案部门','valuer':'planDept'},
          {'title':'应急预案备案编号','valuer':'planCode'},
          {'title':'预案备案风险级别','valuer':'planRiskLevel'},
          {'title':'是否在省平台备案','valuer':'provincePlatformFiling'},
          {'title':'是否制定危险废物应急预案和防范措施','valuer':'formulatePrecautions'},
          {'title':'是否有组织培训','valuer':'training'},
          {'title':'培训时间','valuer':'trainingDate'},
          {'title':'是否有开展应急演练','valuer':'startDrill'},
          {'title':'演练时间','valuer':'drillDate'},
          {'title':'是否编制重污染天气应急预案','valuer':'composePollutedWeatherFiling'},
          {'title':'环境风险单元','valuer':'riskUnit'},
        ]
      }
    },
    {
      "name":"应急专家信息",
      "path":'/abutmentEnterpriseDetails',
      'arguments':{
        'url': 'findEmergencyExpertPage',
        'id': '',
        "name":"应急专家信息",
        'data':[
          {'title':'专家姓名','valuer':'name'},
          {'title':'性别','valuer':'sex'},
          {'title':'民族','valuer':'clan'},
          {'title':'年龄','valuer':'age'},
          {'title':'专业','valuer':'profession'},
          {'title':'擅长领域','valuer':'expertiseScopes'},
          {'title':'获得荣誉','valuer':'receiveHonor'},
          {'title':'联系电话','valuer':'mobilePhone'},
          {'title':'参与的应急案例','valuer':'participateCase'},
          {'title':'照片','valuer':'photoUrl'},
          {'title':'备注','valuer':'remark'},
        ]
      }
    },
    {
      "name":"应急物资信息",
      "path":'/abutmentEnterpriseDetails',
      'arguments':{
        'url': 'findEmergencyMaterialsPage',
        'id': '',
        "name":"应急物资信息",
        'data':[
          {'title':'应急物资名称','valuer':'materialName'},
          {'title':'应急物资用途','valuer':'used'},
          {'title':'物资数量','valuer':'num'},
          {'title':'数量单位','valuer':'unit'},
          {'title':'所属企业','valuer':'belongCompany'},
          {'title':'储存位置','valuer':'storageLocation'},
          {'title':'应急物资类型','valuer':'materialType'},
          {'title':'型号/规格','valuer':'model'},
          {'title':'是否在校验期内','valuer':'effective'},
          {'title':'是否储备齐全','valuer':'fullyStocked'},
          {'title':'经度','valuer':'lon'},
          {'title':'物资图片','valuer':'photoUrl'},
          {'title':'纬度','valuer':'lat'},
          {'title':'管理人员','valuer':'manager'},
          {'title':'联系电话','valuer':'mobilePhone'},
          {'title':'备注','valuer':'remark'},
        ]
      }
    },
    {
      "name":"应急演练信息",
      "path":'/abutmentEnterpriseDetails',
      'arguments':{
        'url': 'findEmergencyDrillPage',
        'id': '',
        "name":"应急演练信息",
        'data':[
          {'title':'演练标题','valuer':'title'},
          {'title':'演练地点','valuer':'place'},
          {'title':'演练规模（人数）','valuer':'scale'},
          {'title':'演练内容','valuer':'content'},
          {'title':'演练效果','valuer':'effect'},
          {'title':'演练总结报告','valuer':'reportAddress'},
          {'title':'演练现场照片','valuer':'photos'},
          {'title':'所属企业','valuer':'belongCompany'},
          {'title':'经度','valuer':'lon'},
          {'title':'纬度','valuer':'lat'},
          {'title':'备注','valuer':'remark'},
        ]
      }
    },
    {
      "name":"应急培训信息",
      "path":'/abutmentEnterpriseDetails',
      'arguments':{
        'url': 'findEmergencyTrainingPage',
        'id': '',
        "name":"应急培训信息",
        'data':[
          {'title':'培训主题','valuer':'theme'},
          {'title':'培训规模（人数）','valuer':'scale'},
          {'title':'培训地点','valuer':'place'},
          {'title':'培训内容','valuer':'content'},
          {'title':'培训效果','valuer':'effect'},
          {'title':'培训类型','valuer':'type'},
          {'title':'所属企业','valuer':'belongCompany'},
          {'title':'所属租户','valuer':'belongTenant'},
          {'title':'备注','valuer':'remark'},
        ]
      }
    },
    {
      "name":"涉酸性液体信息",
      "path":'/abutmentEnterpriseDetails',
      'arguments':{
        'url': 'findAcidityLiquidPage',
        'id': '',
        "name":"涉酸性液体信息",
        'data':[
          {'title':'酸或酸性液体名称','valuer':'name'},
          {'title':'酸或酸性液体规格','valuer':'specification'},
          {'title':'酸或酸性液体涉及类型','valuer':'involveType'},
          {'title':'酸或酸性液体产生或使用环节','valuer':'useLink'},
          {'title':'酸或酸性液体储存方式','valuer':'storageWay'},
          {'title':'酸或酸性液体处置类型','valuer':'handleType'},
          {'title':'年使用量（吨）','valuer':'usedNum'},
          {'title':'是否有够酸资质','valuer':'qualification'},
          {'title':'年产生量','valuer':'productNum'},
          {'title':'酸或酸性液体处置方式','valuer':'handleWay'},
          {'title':'年销售/处置量','valuer':'saledNum'},
          {'title':'销售/处置单位','valuer':'saledUnit'},
          {'title':'单价（元）','valuer':'price'},
          {'title':'备注','valuer':'remark'},
        ]
      }
    },
    {
      "name":"废有机溶剂信息",
      "path":'/abutmentEnterpriseDetails',
      'arguments':{
        'url': 'findWasteOrganicSolventPage',
        'id': '',
        "name":"废有机溶剂信息",
        'data':[
          {'title':'废有机溶剂种类或名称','valuer':'name'},
          {'title':'转换为废有机溶剂（其它废液）原辅材料名称','valuer':'rawMaterialName'},
          {'title':'原辅材料类型（有机/无机）','valuer':'rawMaterialType'},
          {'title':'产生环节','valuer':'productionLink'},
          {'title':'环评描述产生方式','valuer':'productionWay'},
          {'title':'实际产生方式','valuer':'actualProductionWay'},
          {'title':'环评产生量（吨）','valuer':'productionNum'},
          {'title':'环评处置方式','valuer':'handleWay'},
          {'title':'储存地点','valuer':'storagePlace'},
          {'title':'储存位置','valuer':'storageLocation'},
          {'title':'年处置量（吨','valuer':'handleNum'},
          {'title':'现场储存量（吨','valuer':'storageNum'},
          {'title':'处置费用（元/吨）','valuer':'handleFee'},
          {'title':'产品属性','valuer':'productAttributes'},
          {'title':'是否存在隐患','valuer':'existDanger'},
          {'title':'备注','valuer':'remark'},
        ]
      }
    },
    {
      "name":"副产品信息",
      "path":'/abutmentEnterpriseDetails',
      'arguments':{
        'url': 'findViceProductPage',
        'id': '',
        "name":"副产品信息",
        'data':[
          {'title':'环评副产品种类或名称','valuer':'eiaName'},
          {'title':'排污许可证副本副产品种类（名称','valuer':'sewageName'},
          {'title':'实际副产品种类（名称）','valuer':'actualEiaName'},
          {'title':'副产品状态（固态/液态）','valuer':'status'},
          {'title':'容器类型（桶、袋等）','valuer':'containerType'},
          {'title':'副产品是否有行业标准','valuer':'standard'},
          {'title':'是否委托检测机构对副产品进行检测','valuer':'detect'},
          {'title':'是否在质检部门备案','valuer':'filing'},
          {'title':'副产品储存场所','valuer':'storagePlace'},
          {'title':'副产品产生环节','valuer':'productionLink'},
          {'title':'环评产生量（吨/年','valuer':'eiaProduceNum'},
          {'title':'排污许可产生量（吨/年）','valuer':'sewageProduceNum'},
          {'title':'年实际产生量（吨','valuer':'actualProduceNum'},
          {'title':'处置方式（委托处置（花钱）/外售（卖钱）','valuer':'handleWay'},
          {'title':'委托处置/购买单位','valuer':'buyUnit'},
          {'title':'委托处置单位地点（省内/省外）','valuer':'entrustedPlace'},
          {'title':'委托处置/销售单价（元/吨）','valuer':'price'},
          {'title':'年处置/销售量（吨）','valuer':'saledNum'},
          {'title':'现场库存量（吨）','valuer':'stockNum'},
          {'title':'是否存在隐患','valuer':'danger'},
          {'title':'备注','valuer':'remark'},
        ]
      }
    },
    {
      "name":"废水治理设施信息",
      "path":'/abutmentEnterpriseDetails',
      'arguments':{
        'url': 'findWasteWaterTreatmentFacilitiesPage',
        'id': '',
        "name":"废水治理设施信息",
        'data':[
          {'title':'废水处理方法名称','valuer':'name'},
          {'title':'投入使用时间（年月日）','valuer':'useTime'},
          {'title':'处理废水类型（生活/工业）','valuer':'handleType'},
          {'title':'处理的主要污染物','valuer':'handlePollutants'},
          {'title':'设施运行状态','valuer':'runStatus'},
          {'title':'运行天数（天','valuer':'runDays'},
          {'title':'运行费用（万元）','valuer':'runFee'},
          {'title':'耗电量（万千瓦时）','valuer':'consumePowerNum'},
          {'title':'处理本单位废水量（吨）','valuer':'handleWasteWaterNum'},
          {'title':'处理外单位废水量（吨）','valuer':'handleOutUnitWasteWaterNum'},
          {'title':'进水口编号','valuer':'inletCode'},
          {'title':'进水口名称','valuer':'inletName'},
          {'title':'进水口经度','valuer':'inletLon'},
          {'title':'进水口纬度','valuer':'inletLat'},
          {'title':'集纳范围','valuer':'scope'},
          {'title':'进水口流量（m3/h）','valuer':'inletFlow'},
          {'title':'是/否安装在线监测设备','valuer':'installMonitorDevice'},
          {'title':'备注','valuer':'remark'},
        ]
      }
    },
    {
      "name":"废气治理设施信息",
      "path":'/abutmentEnterpriseDetails',
      'arguments':{
        'url': 'findWasteGasTreatmentFacilitiesPage',
        'id': '',
        "name":"废气治理设施信息",
        'data':[
          {'title':'排气筒名称','valuer':'pipeName'},
          {'title':'排气筒编号','valuer':'pipeCode'},
          {'title':'污染源','valuer':'pollutionSource'},
          {'title':'污染物','valuer':'pollutants'},
          {'title':'环评废气治理工艺','valuer':'eiaGovernCraft'},
          {'title':'排污许可证废气治理工艺','valuer':'wewageGovernCraft'},
          {'title':'实际治理工艺','valuer':'actualGovernCraft'},
          {'title':'是否喷淋','valuer':'spray'},
          {'title':'喷淋液类别','valuer':'sprayType'},
          {'title':'补充/更换物质名称','valuer':'supplementalSubstanceName'},
          {'title':'运行参数','valuer':'runParam'},
          {'title':'更换周期','valuer':'replaceCycle'},
          {'title':'更换量','valuer':'replaceNum'},
          {'title':'是否为RCO','valuer':'rco'},
          {'title':'是否为RTO','valuer':'rto'},
          {'title':'环评污染因子','valuer':'eiaPollutionFactor'},
          {'title':'排污许可因子','valuer':'pollutionErmitActor'},
          {'title':'实际污染因子','valuer':'actualPollutionFactor'},
          {'title':'污染物排放标准','valuer':'emissionStandards'},
          {'title':'排放因子限值','valuer':'emissionFactorLimitValue'},
          {'title':'排放因子实际浓度','valuer':'emissionFactorConcentration'},
          {'title':'进口采样直径（厘米）','valuer':'inletSamplingDiameter'},
          {'title':'进口采样口位置','valuer':'inletSamplingLocation'},
          {'title':'出口排气筒直径（米）','valuer':'outletPipeDiameter'},
          {'title':'出口排气筒高度（米）','valuer':'outletPipeHeight'},
          {'title':'出口采样口直径（米）','valuer':'outletSamplingDiameter'},
          {'title':'出口采样口位置','valuer':'outletSamplingLocation'},
          {'title':'是否安装在线','valuer':'installOnline'},
          {'title':'是否安装视频监控','valuer':'installMonitor'},
          {'title':'采样平台面积（m2）','valuer':'samplingPlatformArea'},
          {'title':'采样梯类型','valuer':'samplingLadderType'},
          {'title':'是否设置排放口标识','valuer':'setOutletSign'},
          {'title':'标识具体内容','valuer':'signContent'},
          {'title':'环评年排放量（吨）','valuer':'eiaEmissionNum'},
          {'title':'排污证年许可量（吨）','valuer':'sewagePermitNum'},
          {'title':'实际年排放量（吨）','valuer':'actualEmissionNum'},
          {'title':'除尘方法名称','valuer':'dustWayName'},
          {'title':'除尘效率','valuer':'dustEfficiency'},
          {'title':'除尘废水处理方法','valuer':'dustHandleWay'},
          {'title':'除尘装置运行小时（h/年）','valuer':'dustDeviceRunTime'},
          {'title':'脱硫方法名称','valuer':'desulfurizationWayName'},
          {'title':'脱硫工艺流程','valuer':'desulfurizationProcess'},
          {'title':'脱硫效率（%）','valuer':'desulfurizationEfficiency'},
          {'title':'脱硫装置运行小时（h/年','valuer':'desulfurizationDeviceRunTime'},
          {'title':'所在车间工段名称','valuer':'workshopName'},
          {'title':'装机容量（kW）','valuer':'capacity'},
          {'title':'燃料名称','valuer':'fuelName'},
          {'title':'燃烧方式','valuer':'combustionWay'},
          {'title':'备注','valuer':'remark'},
        ]
      }
    },
  ];

  @override
  void initState() {
    // TODO: implement initState
    companyId = widget.companyId;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        shrinkWrap: true,
        itemCount: _typeList.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 2,
        ),
        padding: EdgeInsets.all(5.0),
        itemBuilder: (_, index){
          String color = '0xff4D7C${index.toRadixString(16)}F';
          Map item = _typeList[index];
          return InkWell(
          child: Container(
            color: Color(int.parse(color)),
            alignment: Alignment.center,
            child: Text('${item['name']}',style: TextStyle(
              color: Colors.white
            ),),
          ),
            onTap: (){
              setState(() {
                item['arguments']['id'] = companyId;
              });
              Navigator.pushNamed(context, item['path'],arguments: item['arguments']);
            },
        );
        });
  }
}
