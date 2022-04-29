import 'package:flutter/material.dart';
import 'package:scet_check/components/generalduty/upload_image.dart';
import 'package:scet_check/page/module_steward/check/hiddenParame/components/rectify_components.dart';
import 'package:scet_check/page/module_steward/check/statisticAnaly/components/form_check.dart';
import 'package:scet_check/utils/screen/screen.dart';


///任务详情页面
///
class TaskDetails extends StatefulWidget {
  const TaskDetails({Key? key}) : super(key: key);

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
          Container(
            width: px(750),
            height: appTopPadding(context),
            color: Color(0xff19191A),
          ),
          RectifyComponents.topBar(
              title: '任务详情',
              callBack: (){
                Navigator.pop(context);
              }
          ),
          backLog(),
        ],
      ),
    );
  }

  //任务详情
  Widget backLog(){
    return Container(
      margin: EdgeInsets.only(left: px(24),right: px(24),top: px(24)),
      padding: EdgeInsets.only(left: px(12)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(px(8.0))),
      ),
      child: Column(
        children: [
          FormCheck.rowItem(
            title: '企业名称',
            child: Text('北京复原医药公司',style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),),
          ),
          FormCheck.rowItem(
            title: '所在片区',
            child: Text('第三片区',style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),),
          ),
          FormCheck.rowItem(
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
            child: FormCheck.inputWidget(
                hintText: '添加描述....',
                onChanged: (val){
                  setState(() {});
                }
            ),
          ),
          FormCheck.rowItem(
            alignStart: true,
            title: "现场照片",
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

  //左右列表
  Widget surveyItem(String title,String data){
    return Container(
      margin: EdgeInsets.only(top: px(24)),
      child:  FormCheck.rowItem(
        title: title,
        child: Text(data,style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),),
      ),
    );
  }
}
