import 'package:flutter/material.dart';
import 'package:scet_check/api/api.dart';
import 'package:scet_check/api/request.dart';
import 'package:scet_check/components/generalduty/upload_image.dart';
import 'package:scet_check/page/module_steward/check/statisticAnaly/components/form_check.dart';
import 'package:scet_check/utils/screen/screen.dart';

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
  /// :1,待复查;2,复查已通过;3,复查未通过
  String _status(int? status){
    switch(status){
      case 1 : return '待复查';
      case 2 : return '复查已通过';
      case 3 : return '复查未通过';
      default: return '待复查';
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
    solutionList = widget.solutionList ?? [];
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.white,
          padding: EdgeInsets.only(left: px(24)),
          margin: EdgeInsets.only(top: px(4)),
          height: px(56),
          child: FormCheck.formTitle('整改详情'),
        ),
        Column(
          children: List.generate(solutionList.length, (i) => rectification(i)),
        ),
      ],
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
          child: Text(_status(solutionList[i]['status']),style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),),
          ),
          FormCheck.rowItem(
            title: "整改措施",
            child: Text(solutionList[i]['descript'],style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),),
          ),
          FormCheck.rowItem(
              title: "整改图片",
              child: UploadImage(
                imgList: solutionList[i]['images'],
                closeIcon: false,
              )
          ),
          FormCheck.rowItem(
            title: "其他说明",
            child: Text(solutionList[i]['remark'],style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),),
          ),
        ]
    );
  }
}
