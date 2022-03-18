import 'package:flutter/material.dart';
import 'package:scet_check/api/api.dart';
import 'package:scet_check/api/request.dart';
import 'package:scet_check/components/generalduty/upload_image.dart';
import 'package:scet_check/page/module_steward/check/statisticAnaly/components/form_check.dart';
import 'package:scet_check/components/generalduty/image_widget.dart';
import 'package:scet_check/utils/screen/screen.dart';

///企业整改详情
class EnterpriseReform extends StatefulWidget {
  final String? problemId;
  const EnterpriseReform({Key? key,this.problemId,}) : super(key: key);

  @override
  _EnterpriseReformState createState() => _EnterpriseReformState();
}

class _EnterpriseReformState extends State<EnterpriseReform> {

  List imgDetails = [];//图片列表
  List solutionList = [];//整改详情
  bool readOnly = true; //是否为只读
  String rectifyMeasure = '';//整改措施
  String otherExplain = '暂无'; //其他说明
  String dutyPerson = '';//责任人
  String schedule = '';//进度

  /// 整改详情，
  void _setSolution() async {
    Map<String,dynamic> _data = {
      'page':1,
      'size':50,
      'problem.id':widget.problemId,
    };
    var response = await Request().get(
        Api.url['solutionList'],data: _data
    );
    if(response['statusCode'] == 200 && response['data']!=null) {
      solutionList = response['data']['list'];
      setState(() {});
    }
  }

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
    _setSolution();
    super.initState();
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
