import 'package:flutter/material.dart';
import 'package:scet_check/components/generalduty/upload_image.dart';
import 'package:scet_check/page/module_steward/check/statisticAnaly/components/form_check.dart';
import 'package:scet_check/utils/screen/screen.dart';
import 'package:scet_check/utils/time/utc_tolocal.dart';
///问题详情
class ProblemDetails extends StatefulWidget {
  final Map? problemList;
  const ProblemDetails({Key? key,this.problemList}) : super(key: key);

  @override
  _ProblemDetailsState createState() => _ProblemDetailsState();
}

class _ProblemDetailsState extends State<ProblemDetails> {

  List imgDetails = [];//图片列表
  Map problemList = {};//问题详情列表
  bool isImportant = false; //重点问题
  String checkPersonnel = '';//排查人员
  String checkTime = '';//排查时间
  String solvedAt = '';//整改期限
  String rectifyPlan = '';//问题详情
  String lawTitle = '';//法律文件
  String fillPerson = '';//填报人员
  String problemType = '';//问题类型

  /// 获取问题数据
  void _evaluation() async {
    checkTime = formatTime(problemList['createdAt']);
    solvedAt = problemList['solvedAt'] != null ? formatTime(problemList['solvedAt']) : '';
    imgDetails = problemList['images'];
    isImportant = problemList['isImportant'];
    checkPersonnel = problemList['inventory']['checkPersonnel'];
    lawTitle = problemList['law']['title'];
    fillPerson = problemList['user']['nickname'];
    problemType = problemList['problemType']['name'];
    rectifyPlan = problemList['detail'] ?? '';
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    problemList = widget.problemList ?? {};
    if(problemList.isNotEmpty){
      _evaluation();
    }
    super.initState();
  }
  @override
  void didUpdateWidget(covariant ProblemDetails oldWidget) {
    // TODO: implement didUpdateWidget
    problemList = widget.problemList ?? {};
    if(problemList.isNotEmpty){
      _evaluation();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        rubyAgent(),
      ],
    );
  }
  ///排查问题 详情
  Widget rubyAgent(){
    return FormCheck.dataCard(
        children: [
          FormCheck.formTitle('问题详情'),
          FormCheck.rowItem(
              title: "排查时间",
              child:
              Text(checkTime, style: TextStyle(
                  color: Color(0xff323233),
                  fontSize: sp(28),
                  fontFamily: 'Roboto-Condensed'),)
          ),
          FormCheck.rowItem(
            title: "排查人员",
            child:
            Text(checkPersonnel, style: TextStyle(color: Color(0xff323233),
                fontSize: sp(28),
                fontFamily: 'Roboto-Condensed'),) ,
          ),
          FormCheck.rowItem(
            title: "问题类型",
            child: Text(problemType, style: TextStyle(
                color: Color(0xff323233),
                fontSize: sp(28),
                fontFamily: 'Roboto-Condensed'),),
          ),
          FormCheck.rowItem(
            title: "问题详情",
            child: Text(rectifyPlan, style: TextStyle(
                color: Color(0xff323233), fontSize: sp(28)),),
          ),
          FormCheck.rowItem(
              title: "问题图片",
              child: UploadImage(
                imgList: imgDetails,
                closeIcon: false,
              )
          ),
          FormCheck.rowItem(
            title: "法规依据",
            child: Text(lawTitle, style: TextStyle(color: Color(0xff4D7FFF),
                fontSize: sp(28),
                fontFamily: 'Roboto-Condensed'),),
          ),
          FormCheck.rowItem(
            title: "整改期限",
            child: Text(solvedAt, style: TextStyle(
                color: Color(0xff323233),
                fontSize: sp(28),
                fontFamily: 'Roboto-Condensed'),) ,
          ),
          FormCheck.rowItem(
            title: "是否重点",
            child: Text(isImportant ? '是':'否', style: TextStyle(color: Color(0xff323233),
                fontSize: sp(28),),),
          ),
          FormCheck.rowItem(
            title: '填报人员',
            child: Text(fillPerson, style: TextStyle(color: Color(0xff323233),
                fontSize: sp(28),
                fontFamily: 'Roboto-Condensed'),),
          ),
        ]
    );
  }

  ///日期转换
  String formatTime(time) {
    return utcToLocal(time.toString()).substring(0,10);
  }
}
