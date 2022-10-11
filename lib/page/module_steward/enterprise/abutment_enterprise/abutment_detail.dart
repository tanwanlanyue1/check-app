import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:scet_check/api/api.dart';
import 'package:scet_check/api/request.dart';
import 'package:scet_check/components/generalduty/upload_file.dart';
import 'package:scet_check/components/generalduty/upload_image.dart';
import 'package:scet_check/page/module_steward/check/statisticAnaly/components/form_check.dart';
import 'package:scet_check/page/module_steward/personal/components/task_compon.dart';
import 'package:scet_check/utils/screen/screen.dart';
import 'package:scet_check/utils/time/utc_tolocal.dart';


///问题管理详情
class AbutmentDetails extends StatefulWidget {
  Map? arguments;
  AbutmentDetails({Key? key, this.arguments}) : super(key: key);

  @override
  _AbutmentDetailsState createState() => _AbutmentDetailsState();
}

class _AbutmentDetailsState extends State<AbutmentDetails> {
  Map problemDetail = {}; //问题详情
  Map dynamicFormDTO = {}; //问题详情表单内容
  Map content = {}; //表单的内容
  String companyId = ''; //问题的id
  String title = ''; //企业分类标题
  String url = ''; //企业分类网址
  List steps = [];//整改,复查集合
  List sourceList = [];//任务来源
  bool app = false;//问题来自哪来
  @override
  void initState() {
    // TODO: implement initState
    url = widget.arguments?['url'] ?? '';
    title = widget.arguments?['name'] ?? '';
    companyId = widget.arguments?['id'] ?? '';
    _getTaskList();
    _findDicByTypeCode();
    super.initState();
  }
  /// 发布任务任务来源
  _findDicByTypeCode() async {
    var response = await Request().get(Api.url['findDicByTypeCode']+'?dicTypeCode=TASK_SOURCE_TYPE');
    if(response?['errCode'] == '10000') {
      sourceList = response['result'];
      setState(() {});
    }
  }
  /// 查询企业问题详情
  _getTaskList() async {
    var response = await Request().get(Api.url[url]+'/$companyId',
        data: {"companyId": companyId});
    if (response['errCode'] == '10000') {
      problemDetail = response['result'];
      content = jsonDecode(problemDetail['content']) ?? {};
      dynamicFormDTO = problemDetail['dynamicFormDTO'];
      steps = problemDetail['steps'] ?? [];
      app = problemDetail['formId'] == 99999 ? true : false; //表单id为99999时，表示来自app生成的问题
      setState(() {});
    }
  }

  ///渲染表单
  ///表单类型 1：整改通知详情 2:整改详情 3:任务项 4:审核详情
  fromType({required int i,int type = 1}){
    switch(type){
      case 1:
        return inform(informs: steps[i]);
      case 2:
        return rectify(rectifys: steps[i]);
      case 3:
        return taskItem(taskItems: steps[i]);
      case 4:
        return review(reviews: steps[i]);
      default:
        return Text('暂无该类型',style: TextStyle(color: Color(0xff323233),fontSize: sp(30)),);
    }
  }

  ///数据来源
  /// 1:临时任务 2:在线监理 3:问题汇总 4；计划任务 5:预警响应 6:运维任务 7:其他任务
  String dataSource(int type){
    switch(type){
      case 1:
        return '临时任务';
      case 2:
        return '在线监理';
      case 3:
        return '问题复查';
      case 4:
        return '计划任务';
      case 5:
        return '预警响应';
      case 6:
        return '运维任务';
      case 7:
        return '其他任务';
      default:
        return '/';
    }
  }

  ///紧急程度
  /// 1:高 2:中 3:低
  String priority(int type){
    switch(type){
      case 1:
        return '高';
      case 2:
        return '中';
      case 3:
        return '低';
      default:
        return '中';
    }
  }

  ///企业名称
  String company(List companyList){
    String companyName = '/';
    for(var i = 0; i < companyList.length; i++){
      if(i > 0){
        companyName = companyName + ',' + companyList[i]['name'];
      }else{
        companyName = companyList[i]['name'];
      }
    }
    return companyName;
  }

  ///任务来源
  String taskSource(String dicCode){
    String companyName = '/';
    for(var i = 0; i < sourceList.length; i++){
      if(sourceList[i]['dicCode'] == dicCode){
        companyName =  sourceList[i]['dicName'];
      }
    }
    return companyName;
  }
  ///关联表单
  String relevanceForm(List formList){
    String companyName = '/';
    for(var i = 0; i < formList.length; i++){
      if(i > 0){
        companyName = companyName + ',' + formList[i]['formName'];
      }else{
        companyName = formList[i]['formName'];
      }
    }
    return companyName;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TaskCompon.topTitle(
              title: title,
              left: true,
              callBack: (){
                Navigator.pop(context);
              }
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.only(top: 0),
              children: [
                problemDetail.isNotEmpty ? problemDetails() : Container(),
                Column(
                  children: List.generate(steps.length, (index) {
                    return fromType(i: index,type: steps[index]['flowType']);
                  }),
                ),
            ],
          ),
          )
        ],
      ),
    );
  }

  ///问题详情
  Widget problemDetails(){
    return Container(
      padding: EdgeInsets.only(left: px(24),right: px(24)),
      margin: EdgeInsets.only(top: px(20),left: px(24),right: px(24),bottom: px(20)),
      color: Colors.white,
      child: FormCheck.dataCard(
          padding: false,
          children: [
            Container(
              color: Colors.white,
              height: px(56),
              child: FormCheck.formTitle('问题详情'),
            ),
            FormCheck.rowItem(
              title: '发现日期:',
              child: Text( DateTime.fromMillisecondsSinceEpoch(dynamicFormDTO['createDate']).toString().substring(0,16) ,style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),),
            ),
            FormCheck.rowItem(
              title: '选择表单:',
              child: Text('${dynamicFormDTO['formName'] ?? '/'}',style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),),
            ),
            Column(
              children: List.generate(dynamicFormDTO['fieldList'].length, (i) => FormCheck.rowItem(
                title: '${dynamicFormDTO['fieldList'][i]['fieldName']}:',
                alignStart: true,
                child:
                //判断大类小类
                (dynamicFormDTO['fieldList'][i]['fieldValue'] == "issueMainType" || dynamicFormDTO['fieldList'][i]['fieldValue'] == "issueSubType" ) ?
                Text('${content[dynamicFormDTO['fieldList'][i]['fieldValue']]?['typeName'] ?? '/'}',style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),) :
                //app问题图片
                (dynamicFormDTO['fieldList'][i]['fieldValue'] == "images" && app ) ?
                UploadImage(
                  imgList: content['images'] ?? [],
                  closeIcon: false,
                ):
                //app整改期限
                (dynamicFormDTO['fieldList'][i]['fieldValue'] == "solvedAt" && app ) ?
                Text(formatTime(content['solvedAt']),style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),):
                //app排查时间
                (dynamicFormDTO['fieldList'][i]['fieldValue'] == "createdAt" && app ) ?
                Text(formatTime(content['createdAt']),style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),):
                Text('${content[dynamicFormDTO['fieldList'][i]['fieldValue']] ?? '/'}',style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),),
              ),),
            ),
          ]
      ),
    );
  }

  ///整改通知详情
  Widget inform({required Map informs}){
    return Container(
      padding: EdgeInsets.only(left: px(24),right: px(24)),
      margin: EdgeInsets.only(bottom: px(20),left: px(24),right: px(24)),
      color: Colors.white,
      child: FormCheck.dataCard(
          padding: false,
          children: [
            Container(
              color: Colors.white,
              height: px(56),
              child: FormCheck.formTitle(' 整改通知详情'),
            ),
            FormCheck.rowItem(
              title: '整改标题:',
              child: Text('${informs['title'] ?? '/'}',style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),),
            ),
            FormCheck.rowItem(
              title: '整改报告:',
              alignStart: true,
              child: UploadFile(
                url: '/',
                abutment: !app,
                amend: false,
                fileList: informs['fileList'],
              ),
            ),
          ]
      ),
    );
  }

  ///整改详情
  Widget rectify({required Map rectifys}){
    return Container(
      padding: EdgeInsets.only(left: px(24),right: px(24)),
      margin: EdgeInsets.only(bottom: px(20),left: px(24),right: px(24)),
      color: Colors.white,
      child: FormCheck.dataCard(
          padding: false,
          children: [
            Container(
              color: Colors.white,
              height: px(56),
              child: FormCheck.formTitle('整改详情'),
            ),
            FormCheck.rowItem(
              title: '整改描述:',
              child: Text('${rectifys['description'] ?? '/'}',style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),),
            ),
            FormCheck.rowItem(
              alignStart: true,
              title: "整改照片",
              child: Container(
                margin: EdgeInsets.only(left: px(12)),
                child: UploadImage(
                  imgList: rectifys['imgs'] ?? [],
                  closeIcon: false,
                  abutment: !app,
                ),
              ),
            ),
            // FormCheck.rowItem(
            //   title: '整改报告:',
            //   alignStart: true,
            //   child: UploadFile(
            //     url: '/',
            //     abutment: !app,
            //     amend: false,
            //     fileList: rectifys['files'] ?? [],
            //   ),
            // ),
          ]
      ),
    );
  }

  ///任务项
  Widget taskItem({required Map taskItems}){
    return Container(
      padding: EdgeInsets.only(left: px(24),right: px(24)),
      margin: EdgeInsets.only(top: px(20),left: px(24),right: px(24)),
      color: Colors.white,
      child: FormCheck.dataCard(
          padding: false,
          children: [
            Container(
              color: Colors.white,
              height: px(56),
              child: FormCheck.formTitle('任务项详情'),
            ),
            FormCheck.rowItem(
              title: '数据来源:',
              child: Text(taskSource(taskItems['taskSourceType']),style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),),
            ),
            FormCheck.rowItem(
              title: '任务项:',
              child: Text('${taskItems['taskItem'] ?? '/'}',style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),),
            ),
            FormCheck.rowItem(
              title: '任务来源:',
              child: Text(dataSource(taskItems['taskSource']),style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),),
            ),
            FormCheck.rowItem(
              title: '企业名称:',
              alignStart: true,
              child: Text(company(taskItems['companyList'] ?? []),style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),),
            ),
            FormCheck.rowItem(
              title: '任务项关联表单:',
              alignStart: true,
              child: Text(relevanceForm(taskItems['formList'] ?? []),style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),),
            ),
            FormCheck.rowItem(
              title: '负责人:',
              child: Text('${taskItems['managerOpName'] ?? '/'}',style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),),
            ),
            FormCheck.rowItem(
              title: '协助人员:',
              child: Text('${taskItems['assistOpNames'] ?? '/'}',style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),),
            ),
            FormCheck.rowItem(
              title: '紧急程度:',
              child: Text(priority(taskItems['priority']),style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),),
            ),
            FormCheck.rowItem(
              title: '任务起止时间:',
              alignStart: true,
              child: Text('${DateTime.fromMillisecondsSinceEpoch(taskItems['startDate']).toString().substring(0,10)}至${DateTime.fromMillisecondsSinceEpoch(taskItems['endDate']).toString().substring(0,10)}',style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),),
            ),
          ]
      ),
    );
  }

  ///审核详情
  Widget review({required Map reviews}){
    return Container(
      padding: EdgeInsets.only(left: px(24),right: px(24)),
      margin: EdgeInsets.only(left: px(24),right: px(24),bottom: px(24)),
      color: Colors.white,
      child: FormCheck.dataCard(
          padding: false,
          children: [
            Container(
              color: Colors.white,
              height: px(56),
              child: FormCheck.formTitle('审核详情'),
            ),
            FormCheck.rowItem(
              title: '审批结果:',

              child: Text(reviews['pass'] ? '通过' : "驳回",style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),),
            ),
            FormCheck.rowItem(
              title: '审批意见:',
              child: Text('${reviews['comment'] ?? '无'}',style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),),
            ),
          ]
      ),
    );
  }
}