import 'package:flutter/material.dart';
import 'package:scet_check/api/api.dart';
import 'package:scet_check/components/generalduty/upload_image.dart';
import 'package:scet_check/page/module_steward/check/statisticAnaly/components/form_check.dart';
import 'package:scet_check/utils/screen/screen.dart';
import 'package:scet_check/utils/time/utc_tolocal.dart';

///企业整改详情
class EnterpriseReform extends StatefulWidget {
  final String? problemId;
  final List? solutionList;
  const EnterpriseReform({Key? key,this.problemId,this.solutionList}) : super(key: key);

  @override
  _EnterpriseReformState createState() => _EnterpriseReformState();
}

class _EnterpriseReformState extends State<EnterpriseReform> {

  List solutionList = [];//整改详情

  /// 赋值
  /// 1,待复查;2,复查已通过;3,复查未通过
  String _status(int? status){
    switch(status){
      case 1 : return '待复查';
      case 2 : return '复查已通过';
      case 3 : return '复查未通过';
      case 4 : return '未提交';
      default: return '待复查';
    }
  }

//颜色状态
  static Color colorSwitch(status){
    switch(status){
      case 1 : return Color(0xffFAAA5A);
      case 2 : return Color(0xff7196F5);
      default: return Color(0xffFAAA5A);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    solutionList = widget.solutionList ?? [];
    super.initState();
  }

  @override
  void didUpdateWidget(covariant EnterpriseReform oldWidget) {
    // TODO: implement didUpdateWidget
    if(widget.solutionList != oldWidget.solutionList){
      solutionList = widget.solutionList ?? [];
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(solutionList.length, (i) => rectification(i)),
    );
  }
  ///整改详情
  Widget rectification(int i){
    return FormCheck.dataCard(
        top: false,
        children: [
          FormCheck.rowItem(
            title: "责任人",
            child: Text('${solutionList[i]['user']?['nickname'] ?? ''}',style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),),
          ),
          FormCheck.rowItem(
            title: "当前状态",
            child: Text(_status(solutionList[i]['status']),style: TextStyle(color: colorSwitch(solutionList[i]['status']),fontSize: sp(28)),),
          ),
          FormCheck.rowItem(
            title: "整改措施",
            child: Text(solutionList[i]['descript'],style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),),
          ),
          FormCheck.rowItem(
            title: "整改时间",
            child: Text(formatTime(solutionList[i]['createdAt']),style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),),
          ),
          solutionList[i]['reports'] != null && solutionList[i]['reports'].length >0 ?
          GestureDetector(
            child: FormCheck.rowItem(
              title: "整改附件",
              child: Text(solutionList[i]['reports'][0]['name'],style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),overflow: TextOverflow.ellipsis,),
            ),
            onTap: (){
              Navigator.pushNamed(context, '/PDFView',arguments: Api.baseUrlApp+solutionList[i]['reports'][0]['url']);
            },
          ):Container(),
          FormCheck.rowItem(
              title: "整改图片",
              child: UploadImage(
                imgList: solutionList[i]['images'] ?? [],
                closeIcon: false,
              )
          ),
        ]
    );
  }
  ///时间格式
  ///time:时间
  static String formatTime(time) {
    return utcToLocal(time.toString()).substring(0,16);
  }
}
