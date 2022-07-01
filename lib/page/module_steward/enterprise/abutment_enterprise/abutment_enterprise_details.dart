import 'package:flutter/material.dart';
import 'package:scet_check/api/api.dart';
import 'package:scet_check/api/request.dart';
import 'package:scet_check/page/module_steward/check/statisticAnaly/components/form_check.dart';
import 'package:scet_check/page/module_steward/enterprise/components/enterprise_compon.dart';
import 'package:scet_check/page/module_steward/personal/components/task_compon.dart';
import 'package:scet_check/utils/screen/screen.dart';
import 'package:scet_check/utils/time/utc_tolocal.dart';


///对接的企业信息详情
class AbutmentEnterpriseDetails extends StatefulWidget {
  final Map? arguments;
  const AbutmentEnterpriseDetails({Key? key,this.arguments}) : super(key: key);

  @override
  _AbutmentEnterpriseDetailsState createState() => _AbutmentEnterpriseDetailsState();
}

class _AbutmentEnterpriseDetailsState extends State<AbutmentEnterpriseDetails> {

  String companyId = '';//企业id
  String title = '';//企业分类标题
  String url = '';//企业分类标题
  List companyData = [];//企业信息
  List details = [];//详情信息

  /// 获取企业分类
  void _getProblems() async {
    var response = await Request().get(Api.url[url],
    data: {'companyId':companyId}
    );
    if(response['success'] == true) {
      if(response['result'] is Map){
        companyData.add(response['result']);
      }else{
        companyData = response['result'];
      }
      setState(() {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    url = widget.arguments?['url'] ?? '';
    title = widget.arguments?['name'] ?? '';
    companyId = widget.arguments?['id'] ?? '';
    details = widget.arguments?['data'] ?? [];
    if(details.isNotEmpty){
      _getProblems();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TaskCompon.topTitle(
              title: title,
              left: true,
              callBack: (){
                Navigator.pop(context);
              }
          ),
          companyData.isNotEmpty ?
          Expanded(
            child: ListView(
              padding: EdgeInsets.only(top: 0),
              children: List.generate(companyData.length, (i) => info(companyList: companyData[i])),
            ),
          ) :
          Container(),
        ],
      ),
    );
  }
  ///基本信息
  ///[{'title':废水排放口数}]
  Widget info({required Map companyList,}){
    return Container(
      padding: EdgeInsets.only(left: px(24),right: px(24)),
      margin: EdgeInsets.only(top: px(20)),
      color: Colors.white,
      child: FormCheck.dataCard(
          padding: false,
          children: [
            Column(
              children: List.generate(details.length, (i){
                return surveyItem(
                    '${details[i]['title']}:','${companyList[details[i]['valuer']]}'
                );
              }),
            ),
          ]
      ),
    );
  }
  /// 概况列表
  /// title：左边标题
  /// data：右边标题
  /// color： true 蓝色  false 白色
  /// color：判断字体
  Widget surveyItem(String? title,String? data){
    return SizedBox(
      // height: px(96),
      child: FormCheck.rowItem(
        title: title,
        expandedLeft: true,
        child: Text((data == 'null' || data == null) ? "" :
        (data == '0' || data == 'false') ? '否' :
        (data == '1' || data == 'true') ? '是' :
        data,style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),textAlign: TextAlign.right,),
      ),
    );
  }
}
