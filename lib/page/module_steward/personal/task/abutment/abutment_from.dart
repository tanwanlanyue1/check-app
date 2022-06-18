import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:scet_check/api/api.dart';
import 'package:scet_check/api/request.dart';
import 'package:scet_check/components/generalduty/date_range.dart';
import 'package:scet_check/components/generalduty/down_input.dart';
import 'package:scet_check/components/generalduty/time_select.dart';
import 'package:scet_check/components/generalduty/toast_widget.dart';
import 'package:scet_check/page/module_steward/check/statisticAnaly/components/form_check.dart';
import 'package:scet_check/page/module_steward/personal/components/task_compon.dart';
import 'package:scet_check/utils/screen/screen.dart';
import 'package:scet_check/utils/storage/storage.dart';


class AbutmentFrom extends StatefulWidget {
  final Map? arguments;
  const AbutmentFrom({Key? key,this.arguments}) : super(key: key);

  @override
  _AbutmentFromState createState() => _AbutmentFromState();
}

class _AbutmentFromState extends State<AbutmentFrom> {
  Map allfield = {};//动态表单
  List fieldList = [];//动态表单
  List checkList = [];//多选数组
  List checkData = [];//多选数组数据
  Map data = {}; //动态表单请求
  Map fieldMap = {}; //单选选中
  DateTime startTime = DateTime.now();//开始期限
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>(); //时间选择key
  List getform = [];//缓存的动态表单
  Map content = {};//动态表单是否有数据
  String taskId = '';//任务id
  bool empty = true;

  ///动态表单
  dynamicForm({required int i,int type = 0}){
    switch(type){
      case 1:
        return FormCheck.rowItem(
            title: "${fieldList[i]['fieldName']}:",
            titleColor: Color(0XFF323232),
            child: FormCheck.inputWidget(
                hintText: data.isEmpty ? '请输入文本' : data[fieldList[i]['fieldValue']],
                lines: 1,
                onChanged: (val){
                  if(data.isEmpty){
                    data.addAll({"${fieldList[i]['fieldValue']}":val});
                  }else{
                    data[fieldList[i]['fieldValue']] = val;
                  }
                  setState(() {});
                }
            ));
      case 2:
        return FormCheck.rowItem(
            alignStart: true,
            title: "${fieldList[i]['fieldName']}:",
            titleColor: Color(0XFF323232),
            child: FormCheck.inputWidget(
                hintText: data.isEmpty ? '请输入文本' : data[fieldList[i]['fieldValue']],
                lines: 4,
                onChanged: (val){
                  if(data.isEmpty){
                    data.addAll({"${fieldList[i]['fieldValue']}":val});
                  }else{
                    data[fieldList[i]['fieldValue']] = val;
                  }
                  setState(() {});
                }
            ));
      case 3:
        return FormCheck.rowItem(
            title: "${fieldList[i]['fieldName']}:",
            titleColor: Color(0XFF323232),
            child: FormCheck.inputWidget(
                hintText: data.isEmpty ? '请输入数字' : data[fieldList[i]['fieldValue']],
                keyboardType: TextInputType.number,
                onChanged: (val){
                  if(data.isEmpty){
                    data.addAll({"${fieldList[i]['fieldValue']}":val});
                  }else{
                    data[fieldList[i]['fieldValue']] = val;
                  }
                  setState(() {});
                }
            ));
      case 4:
        return FormCheck.rowItem(
          title: "${fieldList[i]['fieldName']}:",
          titleColor: Color(0XFF323232),
          child: DownInput(
            data: fieldList[i]['contentList'],
            value: data.isEmpty ? fieldMap['fieldContent'] : data[fieldList[i]['fieldValue']]?['fieldContent'],
            dataKey: 'fieldContent',
            callback: (val){
              fieldMap = val;
              if(data.isEmpty){
                data.addAll({"${fieldList[i]['fieldValue']}":fieldMap});
              }else{
                data[fieldList[i]['fieldValue']] = val;
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
            titleColor: Color(0XFF323232),
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
          titleColor: Color(0XFF323232),
          child: Container(
            height: px(72),
            width: px(580),
            color: Colors.white,
            child: TimeSelect(
              scaffoldKey: _scaffoldKey,
              hintText: "请选择整改期限",
              time: data.isEmpty ? startTime : DateTime.parse(data[fieldList[i]['fieldValue']]),
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
      default:
        return Text('暂无该类型',style: TextStyle(color: Color(0xff323233),fontSize: sp(30)),);
    }
  }

  ///复选框id
  void fieldData(List fieldDatas){
    for(var i = 0; i < fieldDatas.length; i++){
      checkList.add(fieldDatas[i]['id']);
    }
  }
  /// 缓存事件
  void saveInfo({required String taskId,required int fromId,Map? datas}) {
    getform.add({'taskId':taskId,'fromId':fromId,'data':datas});
    StorageUtil().setJSON('taskFrom', getform);
    setState(() {});
  }
  /// 提交对接任务
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
      var response = await Request().post(
        Api.url['issueSave'],
        data: [
          {
            'formId':allfield['id'],
            'taskId':taskId,
            'issueFormJsonStr': jsonEncode(data),
          }
        ],
      );
      if(response['errCode'] == '10000') {
        ToastWidget.showToastMsg('提交成功');
        getform = StorageUtil().getJSON('taskFrom') ?? [];
        int index = getform.indexWhere((item) => item['taskId'] == taskId && item['fromId'] == allfield['id']);
        if(index == -1){
          saveInfo(taskId: taskId,fromId: allfield['id'],datas: data);
        }else{
          getform[index]['data'] = data;
          StorageUtil().setJSON('taskFrom', getform);
        }
        Navigator.pop(context);
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    taskId = widget.arguments?['taskId'] ?? '';
    content = widget.arguments?['content'] ?? [];
    getform = StorageUtil().getJSON('taskFrom') ?? [];
    _getKeeper(id: widget.arguments?['allfield']['id']);
    if(content.isEmpty){
      int index = getform.indexWhere((item) => item['taskId'] == taskId && item['fromId'] == widget.arguments?['allfield']['id']);
      if(index != -1){
        data = getform[index]['data'];
      }
    }else{
      content = data;
    }
  }

  /// 获取动态表单详情
  void _getKeeper({required int id}) async {
    var response = await Request().get(Api.url['housekeeper']+'?id=$id',);
    if(response['errCode'] == '10000') {
      allfield = response['result'];
      fieldList = allfield['fieldList'] ?? [];
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
              title: '表单详情',
              left: true,
              callBack: (){
                Navigator.pop(context);
              }
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: px(24),right: px(24),top: px(24)),
              padding: EdgeInsets.only(left: px(12),right: px(12),bottom: px(24)),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(px(8.0))),
              ),
              child: ListView(
                padding: EdgeInsets.only(top: 0),
                children: List.generate(fieldList.length, (i) => dynamicForm(
                    i:i,
                    type: int.parse(fieldList[i]['fieldType'])
                )),
              ),
            ),
          ),
          revocation(),
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
                  if(checkList.contains(contentList[index]['id']) == false){
                    checkList.add(contentList[index]['id']);
                  }else{
                    checkList.remove(contentList[index]['id']);
                  }
                  data.addAll({"${fieldList[i]['fieldValue']}":checkList});
                  setState(() {});
                })
        ),
        InkWell(
          child: Text(
            contentList[index]['fieldContent'],
            style: TextStyle(fontSize: sp(28)),
          ),
          onTap: (){
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
            setState(() {});
          },
        ),
      ],
    );
  }
  ///按钮
  Widget revocation(){
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
            '保存',
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
          empty = true;
          _getTask();
          setState(() {});
        },
      ),
    );
  }
}
