import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scet_check/api/api.dart';
import 'package:scet_check/api/request.dart';
import 'package:scet_check/components/generalduty/date_range.dart';
import 'package:scet_check/components/generalduty/down_input.dart';
import 'package:scet_check/components/generalduty/toast_widget.dart';
import 'package:scet_check/components/generalduty/upload_file.dart';
import 'package:scet_check/model/provider/provider_home.dart';
import 'package:scet_check/page/module_steward/check/statisticAnaly/components/form_check.dart';
import 'package:scet_check/page/module_steward/personal/components/task_compon.dart';
import 'package:scet_check/utils/screen/screen.dart';
import 'package:scet_check/utils/storage/data_storage_key.dart';
import 'package:scet_check/utils/storage/storage.dart';

///对接平台的发布任务
class ReleaseTask extends StatefulWidget {
  const ReleaseTask({Key? key}) : super(key: key);

  @override
  _ReleaseTaskState createState() => _ReleaseTaskState();
}

class _ReleaseTaskState extends State<ReleaseTask> {
  List company = []; //选中的企业
  List charge = []; //协助人员/督导人/统计人
  List assist = []; //负责人
  List findList = []; //动态表单
  List assistOpList = []; //协助人员opId集合
  List groupList = []; //分组管理
  List typeList = [
    {'name':'临时任务','id':1},
    {'name':'在线监理','id':2},
    {'name':'问题复查','id':3},
    {'name':'预警响应','id':5},
    {'name':'运维任务','id':6},
    {'name':'其他任务','id':7},
  ];//数据来源
  List emergencyList = [
    {'name':'高','id':1},
    {'name':'中','id':2},
    {'name':'低','id':3},
  ];//紧急程度
  List sourceList = [];//任务来源
  List dataIds = [];//数据来源id
  List companyIds = [];//企业id
  List formId = [];//动态表单id
  List taskFiles = [];//发布的任务附件
  String checkName = ''; //负责人
  String assistName = ''; //协助人员
  String councilorName = ''; //督导人
  String statisticsName = ''; //统计人
  String typeName = '临时任务'; //数据来源
  String groupName = ''; //分组人员
  String sourceName = ''; //任务来源
  String companyName = ''; //企业名
  String taskDetail = ''; //任务详情/任务项
  String emergencyName = '中'; //紧急程度
  String findName = ''; //动态表单
  String remark = ''; //备注
  String userId = ''; //用户id
  int taskType = 1;//数据来源
  String typeId = ''; //任务来源id
  int? countOpId;//统计人员id
  int? groupId;//分组id
  int? managerOpId;//负责人id
  int priority = 2;//优先级
  int? superviseOpId;//督导人id
  DateTime startTime = DateTime.now();//选择开始时间
  DateTime endTime = DateTime.now().add(Duration(days: 7));//选择结束时间
  HomeModel? _homeModel; //全局的选择企业

  /// 查询所有团队
  void _getUserList() async {
    var response = await Request().post(
        Api.url['teamFindList'],
        data: {}
    );
    if(response['errCode'] == '10000') {
      charge = response['result'];
      for(var i = 0; i < charge.length; i++){
        charge[i]['id'] = i;
      }
      setState(() {});
    }
  }

  /// 条件查询所有团队
  void _findMemberList() async {
    var response = await Request().post(
        Api.url['findMemberList'],
        data: {}
    );
    if(response['errCode'] == '10000') {
      assist = response['result'];
      setState(() {});
    }
  }
  ///  分组管理->获取分组列表
  void _groupList() async {
    var response = await Request().get(
        Api.url['groupList'],
    );
    if(response['errCode'] == '10000') {
      groupList = response['result'];
      setState(() {});
    }
  }
  /// 发布任务任务来源
  _findDicByTypeCode() async {
    var response = await Request().get(Api.url['findDicByTypeCode']+'?dicTypeCode=TASK_SOURCE_TYPE');
    if(response?['errCode'] == '10000') {
      sourceList = response['result'];
      setState(() {});
    }else if(response?['errCode'] == '500') {
      ToastWidget.showToastMsg('查询失败，请重试！');
    }
  }

  /// 条件查询所有动态表单
  _findList() async {
    var response = await Request().post(Api.url['findList'],data: {});
    if(response?['errCode'] == '10000') {
      findList = response['result'];
      setState(() {});
    }else if(response?['errCode'] == '500') {
      ToastWidget.showToastMsg('查询失败，请重试！');
    }
  }

  /// 新增任务
  /// 1：临时任务，2：在线监理，3：问题复查，4：计划主题，5.预警响应，6.运维任务，7.其他任务）
  _getTask() async {
    Map _data = {};
    if(managerOpId == null){
      ToastWidget.showToastMsg('请选择负责人！');
    }else if(assistOpList.isEmpty){
      ToastWidget.showToastMsg('请选择协助人员！');
    }
    else if(superviseOpId == null){
      ToastWidget.showToastMsg('请选择督导人员！');
    }else if(countOpId == null){
      ToastWidget.showToastMsg('请选择统计人员！');
    }
    else if(taskDetail.isEmpty){
      ToastWidget.showToastMsg('请输入任务项！');
    }else if(formId.isEmpty){
      ToastWidget.showToastMsg('请选择填报表单！');
    }else if(taskType == 1 && groupId == null){
      ToastWidget.showToastMsg('请选择分组！');
    }else if((taskType == 2 || taskType == 3) && dataIds.isEmpty){
      ToastWidget.showToastMsg('请选择数据来源！');
    }else if((taskType == 5 || taskType == 6 || taskType == 7) && company.isEmpty){
      ToastWidget.showToastMsg('请选择企业！');
    }else{
      _data = {
        'assistOpList': assistOpList,//协助参与人员集合
        'companyList': (taskType == 2 || taskType == 3) ? [] : companyIds,//企业
        'countOpId': countOpId,//统计人员id
        'dataIds': dataIds,//数据来源id集合
        'endDate': endTime.millisecondsSinceEpoch,//计划结束时间
        'formList': formId,//关联动态表单id
        'groupId': groupId,//分组id
        'managerOpId': managerOpId,//负责人id
        'priority': priority,//优先级（1：高，2：中，3：低）
        'startDate': startTime.millisecondsSinceEpoch,//计划开始时间 13毫秒时间戳
        'superviseOpId': superviseOpId,//督导人员id
        'taskItem': taskDetail,//任务详情
        'taskSource': taskType,//任务来源（1：临时任务，2：在线监理，3：问题复查，）
        'taskSourceType': typeId,//	任务来源类型（字典 TASK_SOURCE_TYPE）
        "taskFileList":taskFiles,//任务附件
      };
      var response = await Request().post(
        Api.url['addBatchTask'],data: [_data],
      );
      if(response?['errCode'] == '10000') {
        ToastWidget.showToastMsg('已成功发布任务!');
        Navigator.pop(context);
        setState(() {});
      }
    }
  }
  ///数据来源跳转
  ///1:选择企业
  ///2:选择来源
  void source() async {
    if(company.isEmpty){
      _homeModel?.setSelectCompany([]);
      _homeModel?.setSelect([]);
    }
    company = [];
    dataIds = [];
    companyIds = [];
    if(taskType == 5 || taskType == 6 || taskType == 7){
      var res = await Navigator.pushNamed(context, '/enterprisePage',arguments: {"task":true,'name':"发布任务"});
      if(res == true){
        company = _homeModel?.selectCompany;
        if(company.isEmpty){
          companyName = '';
        }else{
          for(var i = 0; i < company.length; i++){
            companyIds.add({"id":company[i]['id']});
            if(i > 0){
              companyName = companyName + ',' + company[i]['name'];
            }else{
              companyName = company[i]['name'];
            }
          }
        }
      }
    }else{
      var res = await Navigator.pushNamed(context, '/dataSource',arguments: {"taskType":taskType});
      if(res == true){
        company = _homeModel?.selectCompany;
        if(company.isEmpty){
          companyName = '';
        }else{
          for(var i = 0; i < company.length; i++){
            dataIds.add(company[i]['id']);
            if(i > 0){
              companyName = companyName + ',' + company[i]['name'];
            }else{
              companyName = company[i]['name'];
            }
          }
        }
        setState(() {});
      }
    }
    setState(() {});
  }
  @override
  void initState() {
    // TODO: implement initState
    _findList();
    _groupList();
    _getUserList();
    _findMemberList();
    _findDicByTypeCode();
    userId= jsonDecode(StorageUtil().getString(StorageKey.PersonalData))['id'].toString();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    _homeModel = Provider.of<HomeModel>(context, listen: true);
    return Scaffold(
      body: Column(
        children: [
          TaskCompon.topTitle(
              title: '发布任务',
              home: true,
              font: 32,
              callBack: (){
                Navigator.pop(context);
              }
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.only(top: 0),
              children: [
                backLog(),
                submit(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ///待办任务信息
  Widget backLog(){
    return Container(
      margin: EdgeInsets.only(left: px(24),right: px(24),top: px(24)),
      padding: EdgeInsets.only(left: px(12),right: px(12),bottom: px(12)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(px(8.0))),
      ),
      child: Column(
        children: [
          Container(
            color: Colors.white,
            margin: EdgeInsets.only(top: px(4)),
            height: px(56),
            child: FormCheck.formTitle('任务内容'),
          ),
          FormCheck.rowItem(
            title: '任务项:',
            titleColor: Color(0XFF323232),
            alignStart: true,
            child: FormCheck.inputWidget(
                hintText: '请输入任务内容',
                hintVal: taskDetail,
                lines: 3,
                onChanged: (val){
                  taskDetail = val;
                }
            ),
          ),
          FormCheck.rowItem(
            title: '任务来源:',
            titleColor: Color(0XFF323232),
            child: DownInput(
              value: sourceName,
              data: sourceList,
              hitStr: '选择任务来源',
              dataKey: 'dicName',
              callback: (val){
                sourceName = val['dicName'];
                typeId = val['dicCode'];
                setState(() {});
              },
            ),
          ),
          FormCheck.rowItem(
            title: '数据来源:',
            titleColor: Color(0XFF323232),
            child: DownInput(
              value: typeName,
              data: typeList,
              hitStr: '选择数据来源',
              callback: (val){
                ///清空掉企业选择/来源
                _homeModel?.setSelectCompany([]);
                _homeModel?.setSelect([]);
                company = [];//企业/溯源
                dataIds = [];
                companyIds = [];
                companyName = '';
                groupName = '';//分组
                groupId = null;
                typeName = val['name'];
                taskType = val['id'];
                setState(() {});
              },
            ),
          ),
          FormCheck.rowItem(
            title: taskType == 1 ?
            '选择分组:': (taskType == 2 || taskType == 3) ? '数据来源' : '选择企业',
            titleColor: Color(0XFF323232),
            child: taskType == 1 ?
            DownInput(
              value: groupName,
              data: groupList,
              hitStr: '请选择分组',
              callback: (val){
                company = [];
                dataIds = [];
                companyIds = [];
                groupName = val['name'];
                groupId = val['id'];
                setState(() {});
              },
            ):
            GestureDetector(
              child: Text(
                (taskType != 2 || taskType != 3) ?
              (companyName.isNotEmpty ? companyName : '请选择') : (companyName.isNotEmpty ? companyName : '请选择'),style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),),
              onTap: () {
                source();
              },
            ),
          ),
          FormCheck.rowItem(
            title: '选择填报表单:',
            titleColor: Color(0XFF323232),
            child: DownInput(
              value: findName,
              data: findList,
              more: true,
              hitStr: '选择任务管理表单',
              dataKey: 'formName',
              callback: (val){
                formId = [];
                for(var i = 0; i < val.length;i++){
                  formId.add({'id':val[i]['id']});
                  if(i > 0){
                    findName = findName + ',' + val[i]['formName'];
                  }else{
                    findName = val[i]['formName'];
                  }
                }
                setState(() {});
              },
            ),
          ),
          FormCheck.rowItem(
            title: '任务起止时间:',
            titleColor: Color(0XFF323232),
            child: DateRange(
              start: startTime,
              end: endTime,
              showTime: false,
              callBack: (val) {
                startTime = val[0];
                endTime = val[1];
                setState(() {});
              },
            ),
          ),
          FormCheck.rowItem(
            title: '负责人:',
            titleColor: Color(0XFF323232),
            child: DownInput(
              value: checkName,
              data: assist,
              hitStr: '选择负责人',
              dataKey: 'managerOpName',
              callback: (val){
                checkName = val['managerOpName'];
                managerOpId = val['managerOpId'];
                setState(() {});
              },
            ),
          ),
          FormCheck.rowItem(
            title: '协助人员:',
            titleColor: Color(0XFF323232),
            child: DownInput(
              value: assistName,
              data: charge,
              more: true,
              hitStr: '选择协助人员',
              dataKey: 'opName',
              callback: (val){
                assistOpList = [];
                for(var i = 0; i < val.length;i++){
                  assistOpList.add({"opId":val[i]['opId']});
                  if(i > 0){
                    assistName = assistName + ',' + val[i]['opName'];
                  }else{
                    assistName = val[i]['opName'];
                  }
                }
                setState(() {});
              },
            ),
          ),
          // FormCheck.rowItem(
          //   title: '督导人:',
          //   titleColor: Color(0XFF323232),
          //   child: DownInput(
          //     value: councilorName,
          //     data: charge,
          //     hitStr: '选择督导人',
          //     dataKey: 'opName',
          //     callback: (val){
          //       councilorName = val['opName'];
          //       superviseOpId = val['opId'];
          //       setState(() {});
          //     },
          //   ),
          // ),
          // FormCheck.rowItem(
          //   title: '统计人:',
          //   titleColor: Color(0XFF323232),
          //   child: DownInput(
          //     value: statisticsName,
          //     data: charge,
          //     hitStr: '选择统计人',
          //     dataKey: 'opName',
          //     callback: (val){
          //       statisticsName = val['opName'];
          //       countOpId = val['opId'];
          //       setState(() {});
          //     },
          //   ),
          // ),
          FormCheck.rowItem(
            title: '紧急程度:',
            titleColor: Color(0XFF323232),
            child: DownInput(
              value: emergencyName,
              data: emergencyList,
              hitStr: '选择紧急程度',
              callback: (val){
                emergencyName = val['name'];
                priority = val['id'];
                setState(() {});
              },
            ),
          ),
          // FormCheck.rowItem(
          //   title: '任务附件:',
          //   titleColor: Color(0XFF323232),
          //   alignStart: true,
          //   child: UploadFile(
          //     url: '/',
          //     abutment: true,
          //     amend: true,
          //     fileList: taskFiles,
          //     callback: (val){
          //       taskFiles = val;
          //       setState(() {});
          //     },
          //   ),
          // ),
          FormCheck.rowItem(
            title: '备注:',
            titleColor: Color(0XFF323232),
            alignStart: true,
            child: FormCheck.inputWidget(
                hintText: '请输入备注',
                hintVal: taskDetail,
                lines: 3,
                onChanged: (val){
                  taskDetail = val;
                }
            ),
          ),
        ],
      ),
    );
  }


  ///提交按钮
  Widget submit(){
    return InkWell(
      child: Container(
        height: px(60),
        margin: EdgeInsets.only(top: px(12),left: px(24),right: px(24),bottom: px(24)),
        alignment: Alignment.center,
        child: Text('提交', style: TextStyle(
            fontSize: sp(32),
            fontFamily: "R",
            color: Colors.white),),
        decoration: BoxDecoration(
          color: Color(0xff4D7FFF),
          border: Border.all(width: px(2),color: Color(0XffE8E8E8)),
          borderRadius: BorderRadius.all(Radius.circular(px(12))),),
      ),
      onTap: () async {
        _getTask();
      },
    );
  }
}
