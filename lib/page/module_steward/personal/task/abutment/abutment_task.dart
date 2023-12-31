import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scet_check/api/api.dart';
import 'package:scet_check/api/request.dart';
import 'package:scet_check/components/generalduty/down_input.dart';
import 'package:scet_check/components/generalduty/toast_widget.dart';
import 'package:scet_check/components/generalduty/upload_file.dart';
import 'package:scet_check/components/generalduty/upload_image.dart';
import 'package:scet_check/model/provider/provider_home.dart';
import 'package:scet_check/page/module_steward/check/statisticAnaly/components/form_check.dart';
import 'package:scet_check/page/module_steward/personal/components/task_compon.dart';
import 'package:scet_check/utils/screen/screen.dart';
import 'package:scet_check/utils/storage/data_storage_key.dart';
import 'package:scet_check/utils/storage/storage.dart';


///对接任务详情页面
///arguments：{"backlog":true,'id':任务详情}
class AbutmentTask extends StatefulWidget {
  final Map? arguments;
  const AbutmentTask({Key? key,this.arguments}) : super(key: key);

  @override
  _AbutmentTaskState createState() => _AbutmentTaskState();
}

class _AbutmentTaskState extends State<AbutmentTask> {
  Map taskDetails = {};//任务详情
  List checkImages = [];//检查图片列表
  bool backlog = true;//完成
  String userName = ''; //用户id
  String review = ''; //审批意见
  List taskFiles = [];//任务附件名称
  List taskFileList = [];//任务附件名称
  Map companyList = {};//任务企业列表
  List imgDetails = [];//任务图片列表
  String taskId = ''; //任务id
  String remark = ''; //备注
  List formDynamic = [];//动态表单id数组
  List getform = [];//缓存的动态表单
  int taskSource = 0;//任务来源（1：临时任务，2：在线监理，3：问题复查，4：计划主题）
  int taskStatus = 0;//任务状态 0 未执行，1 执行中，2 已提交 3 驳回 4 审核完结
  bool isImportant = true; //是否审批通过
  Map taskGuide = {};//指引
  HomeModel? _homeModel; //全局的选择企业

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    backlog = widget.arguments?['backlog'] ?? false;
    taskId = widget.arguments?['id'] ?? '';
    userName= jsonDecode(StorageUtil().getString(StorageKey.PersonalData))['nickname'];
    _getTasks();
  }
  /// 获取任务详情
  _getTasks() async {
    var response = await Request().get(Api.url['houseTaskById'],
      data: {
        'taskId':taskId,
        'source':'app',
      });
    if(response?['errCode'] == '10000') {
      taskDetails = response['result'];
      taskSource = taskDetails['taskSource'];
      taskStatus = taskDetails['taskStatus'];
      review = taskDetails['approvalOpinion'] ?? '';
      remark = taskDetails['description'] ?? '/';
      List imgList = taskDetails['imgList'] ?? [];
      List fileList = taskDetails['fileList'] ?? [];
      taskFileList = taskDetails['taskFileList'] ?? [];
      for(var i = 0; i < imgList.length; i++){
        checkImages.add(imgList[i]['filePath']);
      }
      taskFiles = fileList.isNotEmpty ? fileList : [];
      formDynamic = taskDetails['formList'];
      setState(() {});
    }else if(response?['errCode'] == '500') {
      Navigator.pop(context);
      ToastWidget.showToastMsg('查看详情失败，请重试！');
    }
  }

  ///处理排查人员
  String checkPeople({required List company}){
    String checkList = '';
    for(var i = 0; i < company.length; i++){
      if(i > 0){
        checkList = checkList + ',' + company[i]['name'];
      }else{
        checkList = company[i]['name'];
      }
    }
    return checkList;
  }

  /// 提交对接任务
  void _submiTask() async {
    // List imgList = [];
    // for(var i = 0; i < checkImages.length; i++){
    //   imgList.add({'filePath':checkImages[i]});
    // }
    var response = await Request().post(
      Api.url['submitTask'],
      data: {
        'id':taskId,
        'fileList':taskFiles,
        // 'imgList':imgList,
      },
    );
    if(response['errCode'] == '10000') {
      ToastWidget.showToastMsg('提交成功');
      Navigator.pop(context,true);
      setState(() {});
    }
  }

  /// 审核任务
  /// taskStatus 7:通过 3：驳回
  /// approvalOpinion：审核意见
  void _auditTask() async {
    if(review.isEmpty){
      ToastWidget.showToastMsg('审核意见不能为空');
    }else{
      var response = await Request().post(
        Api.url['approvalTask'],
        data: {
          'id':taskId,
          'approvalOpinion':review,
          'taskStatus': isImportant ? 7 : 3
        },
      );
      if(response['errCode'] == '10000') {
        ToastWidget.showToastMsg('审核完成');
        Navigator.pop(context,true);
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _homeModel = Provider.of<HomeModel>(context, listen: true);
    return Scaffold(
      endDrawer: Container(),
      body: Column(
        children: [
          TaskCompon.topTitle(
              title: '任务详情',
              left: true,
              child: backlog && taskStatus == 7 ?
              Container() :
              revocation(),
              callBack: (){
                Navigator.pop(context);
              }
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.only(top: 0),
              children: [
                taskDetails.isNotEmpty ?
                backLog() :
                Container(),
                taskSource == 2 ?
                dataSource() :
                Container(),
                relevanceFrom(),
                (taskDetails['managerOpName'] != userName && !backlog)
                ? Container() : incorrectMessage(),
                taskStatus == 6 && taskDetails['managerOpName'] == userName ?
                reviewDeclared() :
                Container(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ///任务详情
  ///DateTime.fromMillisecondsSinceEpoch 时间轴转时间类型
  Widget backLog(){
    return Container(
      margin: EdgeInsets.only(left: px(24),right: px(24),top: px(24)),
      padding: EdgeInsets.only(left: px(24),right: px(24),bottom: px(24)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(px(8.0))),
      ),
      child: Column(
        children: [
          Container(
            color: Colors.white,
            margin: EdgeInsets.only(top: px(12)),
            height: px(56),
            child: FormCheck.formTitle('任务详情'),
          ),
          FormCheck.rowItem(
            title: '任务名称:',
            child: Text('${taskDetails['taskItem']}',style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),),
          ),
          FormCheck.rowItem(
            title: '开始时间:',
            child: Text(
                taskDetails['startDate'] == null ? '/' :
              DateTime.fromMillisecondsSinceEpoch(taskDetails['startDate']).toString().substring(0,16),
              style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),),
          ),
          FormCheck.rowItem(
            title: '结束时间:',
            child: Text(
              taskDetails['startDate'] == null ? '/' :
              DateTime.fromMillisecondsSinceEpoch(taskDetails['endDate']).toString().substring(0,16),
              style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),),
          ),
          FormCheck.rowItem(
            title: '负责人员:',
            child: Text('${taskDetails['managerOpName']}',style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),),
          ),
          FormCheck.rowItem(
            title: '协助人员:',
            child: Text('${taskDetails['assistOpNames']}',style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),),
          ),
          FormCheck.rowItem(
            title: '任务描述:',
            child: Text('$remark',style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),),
          ),
          FormCheck.rowItem(
            title: '优先级:',
            child: Text(
              taskDetails['priority'] == 1 ? '高':
              taskDetails['priority'] == 2 ? '中' :'低',
              style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),),
          ),
          // 新增的任务附件
          // FormCheck.rowItem(
          //   title: '任务附件:',
          //   alignStart: true,
          //   child: UploadFile(
          //     url: '/',
          //     abutment: true,
          //     amend: false,
          //     fileList: taskFileList,
          //   ),
          // ),
          (taskStatus == 3 || taskStatus == 7) ?
          FormCheck.rowItem(
            title: '审批意见:',
            alignStart: true,
            child: Text(review,style: TextStyle(color: taskStatus == 3 ? Color(0xff7196F5) : Color(0xff323233),fontSize: sp(28)),),
          ) : Container(),
        ],
      ),
    );
  }

  ///管理表单卡片
  Widget relevanceFrom(){
    return  Container(
      margin: EdgeInsets.only(left: px(24),right: px(24),top: px(24),bottom: px(24)),
      padding: EdgeInsets.all(px(24)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(px(8.0))),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: FormCheck.formTitle(
                  '表单列表',
                ),
              ),
              Visibility(//添加表单——填报表单
                visible: !backlog,
                child: GestureDetector(
                  child: SizedBox(
                      width: px(40),
                      height: px(41),
                      child: Image.asset('lib/assets/icons/form/add.png')),
                  onTap: () async {
                    var res = await Navigator.pushNamed(context, '/fromSelect',arguments: {'taskId':taskId,'formList':formDynamic});
                    if(res != null){
                      _getTasks();
                    }
                  },
                ),
              ),
              Visibility(
                visible: !backlog,
                child: GestureDetector(
                  child: SizedBox(
                      child: Text(' 添加表单',style: TextStyle(color: Color(0xff323233),fontSize: sp(28)))),
                  onTap: () async {
                    var res = await Navigator.pushNamed(context, '/fromSelect',arguments: {'taskId':taskId,'formList':formDynamic});
                    if(res != null){
                      _getTasks();
                    }
                  },
                ),
              ),
            ],
          ),
          FormCheck.rowItem(
            title: '企业名称:',
            child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      child: Text(companyList.isEmpty ? '请选择企业' : companyList['name'],style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),),
                      onTap: () async{
                        if(companyList.isEmpty){
                          _homeModel?.setSelectCompany([]);
                          _homeModel?.setSelect([]);
                        }
                        var res = await Navigator.pushNamed(context, '/abutmentEnterprise',arguments: {"companyList":taskDetails['companyList'],});
                        if(res == true){
                          if(_homeModel?.selectCompany.length != 0){
                            companyList = _homeModel?.selectCompany[0];
                          }
                          setState(() {});
                        }
                      },
                    ),
                  ),
                     Icon(Icons.keyboard_arrow_right)
                ],
                )
                // child: DownInput(
                //   data: taskDetails['companyList'],
                //   value: companyList['name'],
                //   hitStr: '请选择企业',
                //   callback: (val){
                //     companyList = val;
                //     setState(() {});
                //   },
                // )
          ),
          Column(
            children: List.generate(formDynamic.length, (i) => taskDynamicForm(
              i: i,
              cycleList: formDynamic[i],
            )),
          ),
        ],
      ),
    );
  }

  ///检查信息卡片
  Widget dataSource(){
    return  Container(
      margin: EdgeInsets.only(left: px(24),right: px(24),top: px(24)),
      padding: EdgeInsets.all(px(24)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(px(8.0))),
      ),
      child: Column(
        children: [
          FormCheck.formTitle(
            '检查信息',
          ),
          Column(
            children: List.generate(taskDetails['dataList'].length, (index) => taskSourceForm(
                  i: index,
                  cycleList:taskDetails['dataList'][index],
              )),
          ),
        ],
      ),
    );
  }

  ///任务动态表单
  Widget taskDynamicForm({required int i,Map? cycleList}){
    return InkWell(
      child: Container(
        padding: EdgeInsets.only(bottom: px(12)),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(width: px(2),color: Color(0xffF6F6F6)),)
        ),
        child: FormCheck.rowItem(
          title: '关联表单:',
          child: Row(
            children: [
              Expanded(
                child: Text('${cycleList?['formName']}',style: TextStyle(color: Color(0xff323233),fontSize: sp(28),overflow: TextOverflow.ellipsis),),
              ),
              Icon(Icons.keyboard_arrow_right)
            ],
          ),
        ),
      ),
      onTap: () async {
        Navigator.pushNamed(context, '/relevanceList',arguments: {
          'taskId':taskId,
          'backlog':backlog,
          'companyList':companyList,
          'formId':formDynamic[i]['id'],
          'name':cycleList?['formName'],
        });
      },
    );
  }

  ///检查信息列表
  Widget taskSourceForm({required int i,Map? cycleList}){
    return InkWell(
      child: Container(
        padding: EdgeInsets.only(bottom: px(12)),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(width: px(4),color: Color(0xffF6F6F6)),),//0xffF6F6F6 0xff19191A
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(top: px(12),bottom: px(12)),
              child: Row(
                children: [
                  Expanded(
                    child: Text('${cycleList?['companyName']}—${cycleList?['name']}',style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),),
                  ),
                  Icon(Icons.keyboard_arrow_right)
                ],
              ),
            ),
          ],
        ),
      ),
      onTap: () async {
        Navigator.pushNamed(context, '/taskGuide',arguments: {'cycleList':cycleList,'id':cycleList?['id']});
      },
    );
  }

  ///任务填报信息
  Widget incorrectMessage(){
    return  Container(
      margin: EdgeInsets.only(left: px(24),right: px(24),top: px(24)),
      padding: EdgeInsets.all(px(24)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(px(8.0))),
      ),
      child: Column(
        children: [
          FormCheck.formTitle(
            '填报信息',
          ),
          // FormCheck.rowItem(
          //   alignStart: true,
          //   title: "现场照片:",
          //   child: UploadImage(
          //     imgList: checkImages,
          //     abutment: true,
          //     closeIcon: !backlog,
          //     callback: (List? data) {
          //       checkImages = data ?? [];
          //       setState(() {});
          //     },
          //   ),
          // ),
          FormCheck.rowItem(
            title: '任务附件:',
            alignStart: true,
            child: UploadFile(
              url: '/',
              abutment: true,
              amend: !backlog,
              fileList: taskFiles,
              callback: (val){
                taskFiles = val;
                setState(() {});
              },
            ),
          ),
        ],
      ),
    );
  }
  ///审核填报卡片
  Widget reviewDeclared(){
    return Container(
      margin: EdgeInsets.only(left: px(24),right: px(24),top: px(24)),
      padding: EdgeInsets.all(px(24)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(px(8.0))),
      ),
      child: Column(
        children: [
          FormCheck.formTitle(
            '审核填报',
          ),
          FormCheck.rowItem(
            title: '审批意见:',
            alignStart: true,
            child: FormCheck.inputWidget(
                hintText:  '请输入审批意见',
                hintVal: review,
                lines: 3,
                onChanged: (val){
                  review = val;
                }
            ),
          ),
          FormCheck.rowItem(
            title: "审批通过:",
            child: _radio(),
          ),
        ],
      ),
    );
  }

  ///单选
  Widget _radio() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          width: px(70),
          child: Radio(
            value: true,
            groupValue: isImportant,
            onChanged: (bool? val) {
              setState(() {
                isImportant = val!;
              });
            },
          ),
        ),
        InkWell(
          child: Text(
            "是",
            style: TextStyle(fontSize: sp(28)),
          ),
          onTap: (){
            setState(() {
              isImportant = true;
            });
          },
        ),
        SizedBox(
          width: px(70),
          child: Radio(
            value: false,
            groupValue: isImportant,
            onChanged: (bool? val) {
              setState(() {
                isImportant = val!;
              });
            },
          ),
        ),
        InkWell(
          child: Text(
            "否",
            style: TextStyle(fontSize: sp(28)),
          ),
          onTap: (){
            setState(() {
              isImportant = false;
            });
          },
        )
      ],
    );
  }

  ///按钮
  Widget revocation(){
    return GestureDetector(
      child: Container(
        height: px(56),
        alignment: Alignment.centerRight,
        margin: EdgeInsets.only(right: px(24)),
        child: Text(
          taskDetails['managerOpName'] == userName ? (taskStatus != 6 ? '提交任务' : '完成审核') : '',
          style: TextStyle(
              fontSize: sp(28),
              fontFamily: "M",
              color: Color(0xff19191A)),
        ),
      ),
      onTap: () {
        if(taskStatus == 6){
          _auditTask();
        }else{
          if(taskDetails['commitAuth']){
            _submiTask();
          }else{
            ToastWidget.showToastMsg('您没有提交该任务的权限!');
          }
        }
      },
    );
  }
  ///审核按钮
  Widget rev(){
    return Container(
      height: px(88),
      margin: EdgeInsets.only(top: px(24)),
      color: Colors.transparent,
      alignment: Alignment.center,
      child: GestureDetector(
        child: Container(
          width: px(240),
          height: px(56),
          alignment: Alignment.center,
          margin: EdgeInsets.only(left: px(40)),
          child: Text(
            taskStatus != 2 ? '提交' : '审核',
            style: TextStyle(
                fontSize: sp(24),
                fontFamily: "M",
                color: Color(0xff4D7FFF)),
          ),
          decoration: BoxDecoration(
            border: Border.all(width: px(2),color: Color(0xff4D7FFF)),
            borderRadius: BorderRadius.all(Radius.circular(px(28))),
          ),
        ),
        onTap: () {
          if(taskStatus == 2){
            _auditTask();
          }else{
            _submiTask();
          }
        },
      ),
    );
  }
}
