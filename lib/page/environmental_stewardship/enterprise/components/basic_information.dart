import 'package:flutter/material.dart';
import 'package:scet_check/components/form_check.dart';
import 'package:scet_check/utils/dateUtc/date_utc.dart';
import 'package:scet_check/utils/screen/screen.dart';

import 'enterprise_compon.dart';

//基本信息
class BasicInformation  extends StatefulWidget {
   BasicInformation ({Key? key}) : super(key: key);

  @override
  _BasicInformationState createState() => _BasicInformationState();
}

class _BasicInformationState extends State<BasicInformation > {
  bool packups = true;
  bool prou = true;//生产情况
  List Colunms = ['主要产品名称','生产线','批复产能'];
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
  Widget build(BuildContext context) {
    return Material(
      child: ListView(
        padding: EdgeInsets.only(top: 0),
        children: [
          info(),
          production(),
        ],
      ),
    );
  }

  //基本信息
  Widget info(){
    return Container(
        padding: EdgeInsets.only(left: px(24),right: px(24)),
        color: Colors.white,
        child: Visibility(
          visible: packups,
          child: FormCheck.dataCard(
              children: [
                FormCheck.formTitle(
                    '基本信息',
                    showUp: true,
                    packups: packups,
                    onTaps: (){
                      packups = !packups;
                      setState(() {});
                    }
                ),
                FormCheck.rowItem(
                  title: "企业名称",
                  child: Text('陈秋好',style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),textAlign: TextAlign.right),
                ),
                FormCheck.rowItem(
                  title: "行业类型",
                  child: Text('2644染料制造',style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),textAlign: TextAlign.right),
                ),
                FormCheck.rowItem(
                  title: "企业地址",
                  alignStart: true,
                  child: Text('工打到以南、经四路以东',style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),textAlign: TextAlign.right,),
                ),
                FormCheck.rowItem(
                  title: "环保负责人",
                  expandedLeft: true,
                  child: Text('张文里',style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),textAlign: TextAlign.right,),
                ),
                FormCheck.rowItem(
                  title: "联系电话",
                  expandedLeft: true,
                  child: Text('18797379866',style: TextStyle(color: Color(0xff6089F0),fontSize: sp(28)),textAlign: TextAlign.right,),
                ),
                FormCheck.rowItem(
                  title: "排污许可编号",
                  expandedLeft: true,
                  child: Text('18797379866',style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),textAlign: TextAlign.right,),
                ),
                FormCheck.rowItem(
                  title: "许可证管理类型",
                  expandedLeft: true,
                  child: Text('重点',style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),textAlign: TextAlign.right,),
                ),
                FormCheck.rowItem(
                  title: "许可证下发时间",
                  expandedLeft: true,
                  child: Text('2021-4-19',style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),textAlign: TextAlign.right,),
                ),
                FormCheck.rowItem(
                  title: "许可证有效日期",
                  expandedLeft: true,
                  child: Text('2021-4-19',style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),textAlign: TextAlign.right,),
                ),
                FormCheck.rowItem(
                  title: "现有生产线是否全部纳入排污许可",
                  expandedLeft: true,
                  child: Text('2021-4-19',style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),textAlign: TextAlign.right,),
                ),
              ]
          ),
          replacement: SizedBox(
            height: px(88),
            child: FormCheck.formTitle(
                '基本信息',
                showUp: true,
                packups: packups,
                onTaps: (){
                  packups = !packups;
                  setState(() {});
                }
            ),
          ),
        ),
      );
  }

  //生产情况
  Widget production(){
    return Container(
      margin: EdgeInsets.only(top: px(4)),
        padding: EdgeInsets.only(left: px(24),right: px(24)),
        color: Colors.white,
        child: Visibility(
          visible: prou,
          child: FormCheck.dataCard(
              children: [
                FormCheck.formTitle(
                    '生产情况',
                    showUp: true,
                    packups: prou,
                    onTaps: (){
                      prou = !prou;
                      setState(() {});
                    }
                ),
                Row(
                  children: EnterPriseCompon.topRow(Colunms),
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
                packups: prou,
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
    return dateUtc(time.toString()).substring(0,10);
  }
}
