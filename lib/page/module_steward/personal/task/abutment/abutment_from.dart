import 'dart:convert';
import 'dart:developer';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:scet_check/api/api.dart';
import 'package:scet_check/api/request.dart';
import 'package:scet_check/components/generalduty/down_input.dart';
import 'package:scet_check/components/generalduty/loading.dart';
import 'package:scet_check/components/generalduty/time_select.dart';
import 'package:scet_check/components/generalduty/toast_widget.dart';
import 'package:scet_check/components/generalduty/upload_image.dart';
import 'package:scet_check/page/module_steward/check/statisticAnaly/components/form_check.dart';
import 'package:scet_check/page/module_steward/personal/components/task_compon.dart';
import 'package:scet_check/utils/screen/screen.dart';

///任务表单
/// 'formId':formDynamic[i]['id'], 表单id
/// 'taskId':taskId, 任务id
/// 'content':content, 提交过的数据
/// 'backlog':backlog, 已办待办
/// 'companyList':companyList, 企业信息
/// id:编辑id
class AbutmentFrom extends StatefulWidget {
  final Map? arguments;
  const AbutmentFrom({Key? key,this.arguments}) : super(key: key);

  @override
  _AbutmentFromState createState() => _AbutmentFromState();
}

class _AbutmentFromState extends State<AbutmentFrom> {
  Map allField = {};//动态表单
  List fieldList = [];//动态表单
  List checkList = [];//多选数组
  List checkData = [];//多选数组数据
  Map data = {}; //动态表单请求
  Map fieldMap = {}; //单选选中
  DateTime startTime = DateTime.now();//开始期限
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>(); //时间选择key
  List getform = [];//缓存的动态表单
  String taskId = '';//任务id
  bool empty = true;
  bool backlog = true;//待办，已办
  bool problem = false;//问题分析类型
  List problemBig = [];//问题大类类型
  List problemSmall = [];//问题小类类型
  Map companyList = {};//企业列表
  String? uuid;//修改列表用的id

  ///动态表单
  ///1:文本框,2:文本域, 3:数字4:单选框 5复选框 6:时间选择7:图片
  dynamicForm({required int i,int type = 0}){
    switch(type){
      case 1:
        return FormCheck.rowItem(
            title: "${fieldList[i]['fieldName']}:",
            child: backlog ?
                Text('${data[fieldList[i]['fieldValue']] ?? '/'}',style: TextStyle(
                    color: Color(0XFF323232),
                    fontSize: sp(28.0),
                    fontWeight: FontWeight.w500
                )):
            FormCheck.inputWidget(
                hintText: data.isEmpty ?
                '请输入${fieldList[i]['fieldName']}' :
                (data[fieldList[i]['fieldValue']] ?? '请输入${fieldList[i]['fieldName']}'),
                hintVal: data.isEmpty ? '' : (data[fieldList[i]['fieldValue']] ?? ''),
                lines: 1,
                onChanged: (val){
                  if(data.isEmpty){
                    data.addAll({"${fieldList[i]['fieldValue']}":val});
                  }else{
                    data[fieldList[i]['fieldValue']] = val;
                  }
                }
            ));
      case 2:
        return FormCheck.rowItem(
            alignStart: true,
            title: "${fieldList[i]['fieldName']}:",
            child: backlog ?
            Text('${data[fieldList[i]['fieldValue']] ?? '/'}',style: TextStyle(
                color: Color(0XFF323232),
                fontSize: sp(28.0),
                fontWeight: FontWeight.w500
            )): FormCheck.inputWidget(
                hintText: data.isEmpty ?
                '请输入${fieldList[i]['fieldName']}' :
                (data[fieldList[i]['fieldValue']] ?? '请输入${fieldList[i]['fieldName']}'),
                hintVal: data.isEmpty ? '' : (data[fieldList[i]['fieldValue']] ?? ''),
                lines: 4,
                onChanged: (val){
                  if(data.isEmpty){
                    data.addAll({"${fieldList[i]['fieldValue']}":val});
                  }else{
                    data[fieldList[i]['fieldValue']] = val;
                  }
                }
            ));
      case 3:
        return FormCheck.rowItem(
            title: "${fieldList[i]['fieldName']}:",
            child: backlog ?
            Text('${data[fieldList[i]['fieldValue']] ?? '/'}',style: TextStyle(
                color: Color(0XFF323232),
                fontSize: sp(28.0),
                fontWeight: FontWeight.w500
            )): FormCheck.inputWidget(
                hintText: data.isEmpty ?
                '请输入${fieldList[i]['fieldName']}' :
                (data[fieldList[i]['fieldValue']] ?? '请输入${fieldList[i]['fieldName']}'),
                hintVal: data.isEmpty ? '' : (data[fieldList[i]['fieldValue']] ?? ''),
                keyboardType: TextInputType.number,
                onChanged: (val){
                  if(data.isEmpty){
                    data.addAll({"${fieldList[i]['fieldValue']}":val});
                  }else{
                    data[fieldList[i]['fieldValue']] = val;
                  }
                }
            ));
      case 4:
        //backlog 表示已经提交，直接展示数据就好
        // issueMainType 代表问题大类的类型，数据需要查询
        //issueSubType 问题小类字段，根据问题大类的id查询
        return FormCheck.rowItem(
          title: "${fieldList[i]['fieldName']}:",
          child: backlog ?
          Text(radioVal(i),style: TextStyle(
              color: Color(0XFF323232),
              fontSize: sp(28.0),
              fontWeight: FontWeight.w500
          )):
          DownInput(
            data: fieldList[i]['fieldValue'] == 'issueMainType' ? problemBig :
            fieldList[i]['fieldValue'] == 'issueSubType' ? problemSmall :
            fieldList[i]['contentList'],
            value: radioVal(i),
            //contentList 单选所需的数组字段
            dataKey: (fieldList[i]['contentList']?.length ?? 0) > 0 ? 'fieldContent' : 'typeName',
            callback: (val){
              fieldMap = val;
              //大类小类需要typeCode,typeName
              if(fieldList[i]['fieldValue'] == 'issueMainType' || fieldList[i]['fieldValue'] == 'issueSubType'){
                if(data.isEmpty){
                  data.addAll({"${fieldList[i]['fieldValue']}":{'typeCode':fieldMap['typeCode'],'typeName':fieldMap['typeName']}});
                }else{
                  data[fieldList[i]['fieldValue']] = {'typeCode':fieldMap['typeCode'],'typeName':fieldMap['typeName']};
                }
              }else{
                if(data.isEmpty){
                  data.addAll({"${fieldList[i]['fieldValue']}":fieldMap['fieldContent']});
                }else{
                  data[fieldList[i]['fieldValue']] = val['fieldContent'];
                }
              }
              //请求问题小类列表 并清空之前的小类选项
              if(fieldList[i]['fieldValue'] == 'issueMainType'){
                data.remove('issueSubType');
                _getSubType(val['id']);
              }
              setState(() {});
            },
          ),
        );
      case 5:
        fieldData(data[fieldList[i]['fieldValue']] ?? []);
        return FormCheck.rowItem(
            title: "${fieldList[i]['fieldName']}:",
            alignStart: true,
            child: Wrap(
              children: List.generate(fieldList[i]['contentList'].length, (j) =>
                  _checkBox(
                      index: j,
                      i:i,
                      contentList: fieldList[i]['contentList']
                  )),
            ));
      case 6:
        return FormCheck.rowItem(
          title: "${fieldList[i]['fieldName']}:",
          child: backlog ?
          Text('${data[fieldList[i]['fieldValue']] ?? '/'}',style: TextStyle(
              color: Color(0XFF323232),
              fontSize: sp(28.0),
              fontWeight: FontWeight.w500
          )):  Container(
            height: px(72),
            width: px(580),
            color: Colors.white,
            child: TimeSelect(
              scaffoldKey: _scaffoldKey,
              hintText: "请选择${fieldList[i]['fieldName']}",
              time: data.isEmpty || data[fieldList[i]['fieldValue']] == null ? startTime : DateTime.parse(data[fieldList[i]['fieldValue']]),
              callBack: (time) {
                startTime = time;
                if(data.isEmpty){
                  data.addAll({"${fieldList[i]['fieldValue']}":'$startTime'});
                }else{
                  data[fieldList[i]['fieldValue']] = '$startTime';
                }
                setState(() {});
              },
            ),
          ),);
      case 7:
        return FormCheck.rowItem(
          title: "${fieldList[i]['fieldName']}:",
          child: UploadImage(
            imgList: data.isEmpty || data[fieldList[i]['fieldValue']] == null ?
            [] :
            data[fieldList[i]['fieldValue']],
            closeIcon: backlog ? false : true,
            abutment: true,
            callback: (List? img) {
              if(data.isEmpty){
                data.addAll({"${fieldList[i]['fieldValue']}":img ?? []});
              }else{
                data[fieldList[i]['fieldValue']] = img ?? [];
              }
              setState(() {});
            },
          ),
        );

      default:
        return Text('暂无该类型',style: TextStyle(color: Color(0xff323233),fontSize: sp(30)),);
    }
  }

  ///单选值
  ///backlog 表示已经提交，直接展示数据就好
  /// issueMainType 代表问题大类的类型，数据需要查询
  ///issueSubType 问题小类字段，根据问题大类的id查询
  String radioVal(int i){
    if(data.isEmpty){
      return backlog ? '/':'请选择${fieldList[i]['fieldName']}';
    }else{
      if(data[fieldList[i]['fieldValue']] != null){
        return fieldList[i]['fieldValue'] == 'issueMainType' || fieldList[i]['fieldValue'] == 'issueSubType'?
        (data[fieldList[i]['fieldValue']]?['typeName'] ?? ''):
        (data[fieldList[i]['fieldValue']] is Map ? (data[fieldList[i]['fieldValue']]?['fieldContent'] ):
        data[fieldList[i]['fieldValue']]
        );
      }else{
        return '请选择${fieldList[i]['fieldName']}';
      }
    }
  }
  ///复选框id
  ///存放已被选中的每一项
  void fieldData(List fieldDatas){
    for(var i = 0; i < fieldDatas.length; i++){
      checkList.add(fieldDatas[i]['id']);
    }
  }
  /// 获取表单问题大类列表
  void _getMainType() async {
    var response = await Request().get(Api.url['mainType']);
    if(response?['errCode'] == '10000') {
      problemBig = response['result'];
      setState(() {});
    }else if(response?['errCode'] == '500') {
      Navigator.pop(context);
      ToastWidget.showToastMsg('查看详情失败，请重试！');
    }
  }

  /// 获取表单问题小类列表
  void _getSubType(int id) async {
    var response = await Request().get(Api.url['subType']+'$id/subType');
    if(response?['errCode'] == '10000') {
      problemSmall = response['result'][0]['children'];
      setState(() {});
    }else if(response?['errCode'] == '500') {
      Navigator.pop(context);
      ToastWidget.showToastMsg('查看详情失败，请重试！');
    }
  }

  /// 提交动态表单
  /// formId 表单id
  /// taskId 任务id
  /// companyId 企业id
  /// companyName 企业名称
  /// issueFormJsonStr 表单填报数据
  /// requiredFlag 是否是必填字段
  void _getTask() async {
    for(var i = 0; i < fieldList.length; i++){
      if(fieldList[i]['requiredFlag']){
        if(data.keys.contains(fieldList[i]['fieldValue']) == false){
          ToastWidget.showToastMsg('${fieldList[i]['fieldName']}不能为空！');
          empty = false;
        }
      }
    }
    if(empty){
      BotToast.showCustomLoading(
          ignoreContentClick: true,
          toastBuilder: (cancelFunc) {
            return Loading(cancelFunc: cancelFunc);
          }
      );
      var dataForm = uuid == null ? {
        'formId':allField['id'],
        'taskId':taskId,
        'companyId':companyList['id'],
        'companyName':companyList['name'],
        'issueFormJsonStr': jsonEncode(data),
      }:{
        'id':uuid,
        'formId':allField['id'],
        'taskId':taskId,
        'companyId':companyList['id'],
        'companyName':companyList['name'],
        'issueFormJsonStr': jsonEncode(data),
      };
      var response = await Request().post(
        Api.url['saveForm'],
        data:dataForm,
      );
      if(response['errCode'] == '10000') {
        ToastWidget.showToastMsg('提交成功');
        Navigator.pop(context,true);
        BotToast.cleanAll();
      }else{
        BotToast.cleanAll();
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    taskId = widget.arguments?['taskId'] ?? '';
    backlog = widget.arguments?['backlog'] ?? false;
    companyList = widget.arguments?['companyList'] ?? {};
    _getKeeper(id: widget.arguments?['formId']);
    if(widget.arguments?['content'] != null && widget.arguments?['content'].length > 0){
      data = widget.arguments?['content'] ?? {};
      uuid = widget.arguments?['id'].toString();
    }
  }

  /// 获取动态表单详情
  void _getKeeper({required int id}) async {
    var response = await Request().get(Api.url['housekeeper']+'?id=$id',);
    if(response['errCode'] == '10000') {
      allField = response['result'];
      fieldList = allField['fieldList'] ?? [];
      problem = allField['formType'] == '3' ? true : false;
      if(problem){
        _getMainType();
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Column(
        children: [
          TaskCompon.topTitle(
              title: '${allField['formTypeStr'] ?? '表单详情'}',
              left: true,
              child: backlog == false ?
              revocation() :
              Container(),
              callBack: (){
                Navigator.pop(context);
              }
          ),
          Expanded(
            child:  ListView(
              padding: EdgeInsets.only(top: 24.px),
              children: List.generate(fieldList.length, (i) => Container(
                margin: EdgeInsets.only(left: px(24),right: px(24)),
                padding: EdgeInsets.only(left: px(12),right: px(12),bottom: px(24)),
                child: dynamicForm(
                    i:i,
                    type: int.parse(fieldList[i]['fieldType'])
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(px(8.0))),
                ),
              )),
            ),
          ),
        ],
      ),
    );
  }

  ///复选
  ///index: 复选框内的第几项
  ///i:复选框是第几项
  ///contentList：每一项复选框
  Widget _checkBox({required int index, required int i, required List contentList}){
    return Row(
      children: [
        SizedBox(
            width: px(70),
            child: Checkbox(
                value: checkList.contains(contentList[index]['id']),
                onChanged: (bool? onTops){
                  if(!backlog){ // 判断是否允许点击更改
                    if(checkList.contains(contentList[index]['id']) == false){
                      checkList.add(contentList[index]['id']);// 选中这一项id，用来判断是否选中
                      checkData.add(contentList[index]);// 存放这一项数据，用来上传
                    }else{
                      checkList.remove(contentList[index]['id']);
                      checkData.remove(contentList[index]);
                    }
                    if(data.isEmpty){
                      data.addAll({"${fieldList[i]['fieldValue']}":checkData});
                    }else{
                      data[fieldList[i]['fieldValue']] = checkData;
                    }
                  }
                  setState(() {});
                })
        ),
        InkWell(
          child: Text(
            contentList[index]['fieldContent'],
            style: TextStyle(fontSize: sp(28)),
          ),
          onTap: (){
            if(!backlog){
              if(checkList.contains(contentList[index]['id']) == false){
                checkList.add(contentList[index]['id']);
                checkData.add(contentList[index]);
              }else{
                checkList.remove(contentList[index]['id']);
                checkData.remove(contentList[index]);
              }
              if(data.isEmpty){
                data.addAll({"${fieldList[i]['fieldValue']}":checkData});
              }else{
                data[fieldList[i]['fieldValue']] = checkData;
              }
            }
            setState(() {});
          },
        ),
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
          '提交',
          style: TextStyle(
              fontSize: sp(28),
              color: Color(0xff19191A)),
        ),
      ),
      onTap: () {
        empty = true;
        _getTask();
        setState(() {});
      },
    );
  }
}
