import 'package:flutter/material.dart';
import 'package:scet_check/page/module_steward/check/statisticAnaly/components/form_check.dart';
import 'package:scet_check/utils/screen/screen.dart';
import 'package:scet_check/utils/time/utc_tolocal.dart';

import 'enterprise_compon.dart';

///基本信息
///companyList 企业数据
class BasicInformation  extends StatefulWidget {
   Map? companyList;
   BasicInformation ({Key? key,this.companyList}) : super(key: key);
    @override
  _BasicInformationState createState() => _BasicInformationState();
}

class _BasicInformationState extends State<BasicInformation > {
  bool tidy = true; //基本信息 收起/展示
  bool prou = true; //生产情况 收起/展示
  List colunms = ['主要产品名称','生产线','批复产能'];//表头
  Map companyList = {};
  ///表单数据
  List bodyList = [
    {
      'data':[
        {'name':'分散蓝291：1'},
        {'name':'分散蓝291：1'},
        {'name':'750吨/每年'},
      ]
    },
    {
      'data':[
        {'name':'分散蓝291：1'},
        {'name':'分散蓝291：1'},
        {'name':'750吨/每年'},
      ]
    },
  ];

  @override
  void initState() {
    // TODO: implement initState
    companyList = widget.companyList ?? companyList;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant BasicInformation oldWidget) {
    // TODO: implement didUpdateWidget
    companyList = widget.companyList ?? companyList;
    super.didUpdateWidget(oldWidget);
  }
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: ListView(
        padding: EdgeInsets.only(top: 0),
        children: [
          info(),
          // production(),
        ],
      ),
    );
  }

  ///基本信息
  Widget info(){
    return Container(
        padding: EdgeInsets.only(left: px(24),right: px(24)),
        color: Colors.white,
        child: Visibility(
          visible: tidy,
          child: FormCheck.dataCard(
              padding: false,
              children: [
                FormCheck.formTitle(
                    '基本信息',
                    showUp: true,
                    tidy: tidy,
                    onTaps: (){
                      tidy = !tidy;
                      setState(() {});
                    }
                ),
                EnterPriseCompon.surveyItem( '企业名称', '${companyList['name']}'),
                EnterPriseCompon.surveyItem( '行业类型', '${companyList['industry']?['name']}'),
                EnterPriseCompon.surveyItem( '企业地址', '${companyList['address']}'),
                EnterPriseCompon.surveyItem( '环保负责人', '${companyList['environmentPrincipal']}'),
                EnterPriseCompon.surveyItem( '联系电话', '${companyList['environmentPhone']}',color: true),
                EnterPriseCompon.surveyItem( '排污许可编号', '${companyList['pollutionDischarge']}'),
                EnterPriseCompon.surveyItem( '许可证管理类型', companyList['pollutionDischargeType'] == 1 ? '重点':"非重点"),
                EnterPriseCompon.surveyItem( '许可证下发时间', formatTime(companyList['pollutionDischargeStart'])),
                EnterPriseCompon.surveyItem( '许可证有效日期', formatTime(companyList['pollutionDischargeEnd'])),
                EnterPriseCompon.surveyItem( '现有生产线是否全部纳入排污许可', companyList['isPollutionDischarge'] == true ? '是':"否"),
              ]
          ),
          replacement: SizedBox(
            height: px(88),
            child: FormCheck.formTitle(
                '基本信息',
                showUp: true,
                tidy: tidy,
                onTaps: (){
                  tidy = !tidy;
                  setState(() {});
                }
            ),
          ),
        ),
      );
  }

  ///生产情况
  Widget production(){
    return Container(
      margin: EdgeInsets.only(top: px(2)),
        padding: EdgeInsets.only(left: px(24),right: px(24)),
        color: Colors.white,
        child: Visibility(
          visible: prou,
          child: FormCheck.dataCard(
            padding: false,
              children: [
                FormCheck.formTitle(
                    '生产情况',
                    showUp: true,
                    tidy: prou,
                    onTaps: (){
                      prou = !prou;
                      setState(() {});
                    }
                ),
                Row(
                  children: EnterPriseCompon.topRow(colunms),
                ),
                Column(
                  children: EnterPriseCompon.bodyRow(bodyList),
                ),
              ]
          ),
          replacement: SizedBox(
            height: px(88),
            child: FormCheck.formTitle(
                '生产情况',
                showUp: true,
                tidy: prou,
                onTaps: (){
                  prou = !prou;
                  setState(() {});
                }
            ),
          ),
        ),
      );
  }


  //日期转换
  String formatTime(time) {
    if(time==null){
      return '';
    }else{
      return utcToLocal(time.toString()).substring(0,10);
    }
  }
}
