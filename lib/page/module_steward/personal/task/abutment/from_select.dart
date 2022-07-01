import 'package:flutter/material.dart';
import 'package:scet_check/api/api.dart';
import 'package:scet_check/api/request.dart';
import 'package:scet_check/components/generalduty/toast_widget.dart';
import 'package:scet_check/page/module_steward/check/statisticAnaly/components/form_check.dart';
import 'package:scet_check/page/module_steward/personal/components/task_compon.dart';
import 'package:scet_check/utils/screen/screen.dart';

///表单选择
/// 任务的id taskId
class FromSelect extends StatefulWidget {
  final Map? arguments;
  const FromSelect({Key? key,this.arguments}) : super(key: key);

  @override
  _FromSelectState createState() => _FromSelectState();
}

class _FromSelectState extends State<FromSelect> {
  List findList = [];//表单列表
  List selectId = [];//选择的id
  List formList = [];//选择的id
  String taskId = ''; //任务id

  /// 条件查询所有动态表单
  _findList() async {
    var response = await Request().post(Api.url['findList'],data: {});
    if(response?['errCode'] == '10000') {
      findList = response['result'];
      setState(() {});
    }else if(response?['errCode'] == '500') {
      Navigator.pop(context);
      ToastWidget.showToastMsg('查询失败，请重试！');
    }
  }

  /// 绑定动态表单
  _addTaskForm() async {
    var response = await Request().post(Api.url['addTaskForm'],
        data: {
          'id':taskId,
          'formList':formList
        }
    );
    if(response?['errCode'] == '10000') {
      Navigator.pop(context,true);
      setState(() {});
    }else if(response?['errCode'] == '500') {
      Navigator.pop(context);
      ToastWidget.showToastMsg('绑定失败，请重试！');
    }else if(response?['errCode'] == '20000') {
      ToastWidget.showToastMsg('${response['errDesc']}！');
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    _findList();
    taskId = widget.arguments?['taskId'] ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TaskCompon.topTitle(
              title: '选择关联表单',
              left: true,
              callBack: (){
                Navigator.pop(context);
              }
          ),
          Expanded(
            child: ListView(
              // padding: EdgeInsets.only(top: 0),
              children: List.generate(findList.length, (index) => taskDynamicForm(i: index)),
            ),
          ),
          TaskCompon.revocation(
            title: '提交',
            onTops: (){
              _addTaskForm();
            }
          )
        ],
      ),
    );
  }

  ///任务动态表单
  Widget taskDynamicForm({required int i}){
    return InkWell(
      child: Container(
        margin: EdgeInsets.only(left: px(24),right: px(24)),
        padding: EdgeInsets.only(left: px(12),right: px(12)),
        height: px(88),
        decoration: BoxDecoration(
            color: selectId.contains(findList[i]['id']) ? Color(0xff4D7FFF) : Colors.white,
            border: Border(bottom: BorderSide(width: px(2),color: Color(0xffF6F6F6)),)
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('${findList[i]['formTypeStr']}:',style: TextStyle(
                color: selectId.contains(findList[i]['id']) ? Colors.white: Color(0xff323233),
                fontSize: sp(28)),),
            Expanded(
              child: Text('  ${findList[i]['formName']}',style: TextStyle(
                  color: selectId.contains(findList[i]['id']) ? Colors.white: Color(0xff323233),
                  fontSize: sp(28)),overflow: TextOverflow.ellipsis,),
            ),
          ],
        )
      ),
      onTap: () async {
        if(widget.arguments?['formList'].indexWhere((ele) => ele['id'] == findList[i]['id']) != -1){
          ToastWidget.showToastMsg('该表单已绑定，请勿重复绑定！');
        }else{
          if(selectId.contains(findList[i]['id'])){
            selectId.remove(findList[i]['id']);
            formList.removeWhere((ele) => ele['id'] == findList[i]['id']);
          }else{
            selectId.add(findList[i]['id']);
            formList.add({'id':findList[i]['id']});
          }
        }
        setState(() {});
      },
    );
  }

}