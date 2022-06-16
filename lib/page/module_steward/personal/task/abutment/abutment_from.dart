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
  Map data = {}; //动态表单请求
  Map fieldMap = {}; //单选选中
  DateTime startTime = DateTime.now();//开始期限
  DateTime endTime = DateTime.now().add(Duration(days: 14));//结束时间
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>(); //时间选择key
  List getform = [];//缓存的动态表单

  ///动态表单
  dynamicForm({required int i,int type = 0}){
    switch(type){
      case 1:
        return FormCheck.rowItem(
            title: "${fieldList[i]['fieldName']}:",
            titleColor: Color(0XFF323232),
            child: FormCheck.inputWidget(
                hintText: '请输入文本',
                lines: 1,
                onChanged: (val){
                  data.addAll({"${fieldList[i]['fieldValue']}":val});
                  setState(() {});
                }
            ));
      case 2:
        return FormCheck.rowItem(
            alignStart: true,
            title: "${fieldList[i]['fieldName']}:",
            titleColor: Color(0XFF323232),
            child: FormCheck.inputWidget(
                hintText: '请输入文本',
                lines: 4,
                onChanged: (val){
                  data.addAll({"${fieldList[i]['fieldValue']}":val});
                  setState(() {});
                }
            ));
      case 3:
        return FormCheck.rowItem(
            title: "${fieldList[i]['fieldName']}:",
            titleColor: Color(0XFF323232),
            child: FormCheck.inputWidget(
                hintText: '请输入数字',
                keyboardType: TextInputType.number,
                onChanged: (val){
                  data.addAll({"${fieldList[i]['fieldValue']}":val});
                  setState(() {});
                }
            ));
      case 4:
        return FormCheck.rowItem(
          title: "${fieldList[i]['fieldName']}:",
          titleColor: Color(0XFF323232),
          child: DownInput(
            //fieldList[i]['contentList']
            data: fieldList[i]['contentList'],
            value: fieldMap['fieldContent'],
            dataKey: 'fieldContent',
            callback: (val){
              fieldMap = val;
              data.addAll({"${fieldList[i]['fieldValue']}":fieldMap['id']});
              setState(() {});
            },
          ),
        );
      case 5:
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
              time: startTime,
              callBack: (time) {
                startTime = time;
                setState(() {});
              },
            ),
            // child: DateRange(
            //   start: startTime,
            //   end: endTime,
            //   showTime: false,
            //   callBack: (val) {
            //     data.addAll({"${fieldList[i]['fieldValue']}":val});
            //   },
            // ),
          ),);
      default:
        return Text('暂无该类型',style: TextStyle(color: Color(0xff323233),fontSize: sp(30)),);
    }
  }

  /// 提交对接任务
  void _getTask({bool inventory = false}) async {
    bool empty = true;
    // for(var i = 0; i < fieldList.length; i++){
    //   if(fieldList[i]['requiredFlag']){
    //     if(data.keys.contains(fieldList[i]['fieldValue']) == false){
    //       empty = false;
    //       ToastWidget.showToastMsg('${fieldList[i]['fieldName']}不能为空！');
    //     }
    //   }
    // }
    if(empty){
      ToastWidget.showToastMsg('提交成功');
      var response = await Request().post(
        Api.url['issueSave'],
          data: {
            'formId':'18',
            'taskId':'18',
            'issueFormJsonStr':'{}',
        },);
      print('提交成功response===$response');
      // if(response['statusCode'] == 200) {
      //   setState(() {});
      // }
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    allfield = widget.arguments?['allfield'] ?? {};
    fieldList = allfield['fieldList'] ?? [];
  }
  /// 缓存事件
  void getInfo() {
    getform = StorageUtil().getJSON('taskFrom') ?? [];
    setState(() {});
    print("get=========${StorageUtil().getJSON('taskFrom')}");
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
                    // checkList.add(index);
                    checkList.add(contentList[index]['id']);
                  }else{
                    // checkList.remove(index);
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
            }else{
              checkList.remove(contentList[index]['id']);
            }
            data.addAll({"${fieldList[i]['fieldValue']}":checkList});
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
          print("data==${data}");
          _getTask();
          // Navigator.pop(context);
        },
      ),
    );
  }
}
