import 'package:flutter/material.dart';
import 'package:scet_check/components/generalduty/upload_image.dart';
import 'package:scet_check/page/module_steward/check/hiddenParame/components/rectify_components.dart';
import 'package:scet_check/page/module_steward/check/statisticAnaly/components/form_check.dart';
import 'package:scet_check/utils/screen/screen.dart';

import 'components/task_compon.dart';


///任务详情页面
///arguments：{"backlog":true}待办
class TaskDetails extends StatefulWidget {
  final Map? arguments;
  const TaskDetails({Key? key,this.arguments}) : super(key: key);

  @override
  _TaskDetailsState createState() => _TaskDetailsState();
}


class _TaskDetailsState extends State<TaskDetails> {
  String companyName = '';//企业名


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TaskCompon.topTitle(
            title: '任务详情',
            left: true,
            callBack: (){
              Navigator.pop(context);
            }
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.only(top: 0),
              children: [
                backLog(),
                (widget.arguments?['backlog'] ?? false) ?
                revocation():
                Container(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ///任务详情
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
            title: '企业名称',
            child: Text('北京复原医药公司',style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),),
          ),
          FormCheck.rowItem(
            title: '所在片区',
            child: Text('第三片区',style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),),
          ),
          FormCheck.rowItem(
            alignStart: true,
            title: '待办任务',
            child: Text('该公司在线设备显示于2022-03-29甲烷排放超标'*3,style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),),
          ),
          FormCheck.rowItem(
            title: '下发时间',
            child: Text('2022-03-29 12:00:00',style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),),
          ),
          FormCheck.rowItem(
            title: '检查人员',
            child: Text('选择人员',style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),),
          ),
          FormCheck.rowItem(
            title: '检查情况',
            child: Text('检查的情况基本符合',style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),),
          ),
          FormCheck.rowItem(
            alignStart: true,
            title: "问题照片",
            child: UploadImage(
              imgList: [],
              closeIcon: false,
            ),
          ),
          FormCheck.rowItem(
            title: '检查时间',
            child: Text('2022-03-29 12:00:00',style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),),
          ),
          FormCheck.rowItem(
            title: '附件上传',
            child: Text('添加附件',style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),),
          ),
        ],
      ),
    );
  }

  ///撤回按钮
  Widget revocation(){
    return Container(
      height: px(88),
      margin: EdgeInsets.only(top: px(24)),
      color: Colors.white,
      alignment: Alignment.center,
      child: GestureDetector(
        child: Container(
          width: px(240),
          height: px(56),
          alignment: Alignment.center,
          margin: EdgeInsets.only(left: px(40)),
          child: Text(
            '撤回',
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
        onTap: (){
          Navigator.pop(context);
        },
      ),
    );
  }
}
