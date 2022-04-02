import 'package:flutter/material.dart';
import 'package:scet_check/utils/screen/screen.dart';

import 'Components/same_point_table.dart';

///统计
///number:整改数
///type:排名类型
///tableBody:表单数据
///callBack:回调函数
class Statistics extends StatefulWidget {
  int pageIndex;
  List? number;
  List? tableBody;
  String? type;
  Function? callBack;
  Statistics({Key? key,required this.pageIndex,this.number,this.type,this.tableBody,this.callBack}) : super(key: key);

  @override
  _StatisticsState createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {

  String type = '企业';//排名类型
  List _tableBody = [];//表单
  int tabIndex = 0;//表单类型
  int finished = 0;//问题整改
  int questionTotal = 0;//问题总数
  int companyTotal = 0;//企业总数
  List number = [];//整改数
  List columns = [];//表头

  @override
  void initState() {
    super.initState();
    dealWith();
  }

  @override
  void didUpdateWidget(covariant Statistics oldWidget) {
    dealWith();
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }

  //处理数据
  void dealWith (){
    number = widget.number ?? [];
    type = widget.type ?? type;
    _tableBody = widget.tableBody ?? [];
    if(number.isNotEmpty){
      companyTotal = number[0]['total'];
      questionTotal = number[1]['total'];
      finished = number[2]['total'];
    }
  }

  //整改数颜色
 Color numberColor (int type){
    if(type == 0){
      return Color(0XFF4D7FFF);
    }else if(type == 1){
      return Color(0XFFD68184);
    }else{
      return Color(0XFF95C758);
    }
  }
  ///只有园区统计才有片区
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: px(12),right: px(12)),
        child: ListView(
        padding: EdgeInsets.only(top: 0),
        children: [
          abarbeitung(),
          SamePointTable(
            tableHeader: columns,
            tableTitle: type,
            tableBody: _tableBody,
            questionTotal:questionTotal,
            callBack: (){
              //全部分区需要请求片区的接口，其他片区不需要,左箭头回调时间
              if(widget.pageIndex == 0){
                if(tabIndex < 2){
                  tabIndex++;
                }else {
                  tabIndex = 0;
                }
              }else{
                if(tabIndex < 1 ){
                  tabIndex++;
                }else {
                  tabIndex = 0;
                }
              }
              widget.callBack?.call(tabIndex);
            },
            callPrevious: (){
              //全部分区需要请求片区的接口，其他片区不需要,右箭头回调时间
              if(widget.pageIndex == 0){
                if(tabIndex > 0){
                  tabIndex--;
                }else{
                  tabIndex = 2;
                }
              }else{
                if(tabIndex > 0){
                  tabIndex--;
                }else{
                  tabIndex = 1;
                }
              }
              widget.callBack?.call(tabIndex);
            },
          ),
        ],
      ),
    );
  }

  ///整改
  Widget abarbeitung(){
    return Container(
      width: px(710),
      height: px(215),
      color: Colors.white,
      padding: EdgeInsets.only(top: px(25)),
      child: Column(
        children: [
          numberRectification(),
          _tableBody.isNotEmpty && questionTotal != 0 ?
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: px(49),right: px(10)),
              child: Row(
                children: [
                  Text('整改率',style: TextStyle(color: Color(0xff323233), fontSize:sp(24.0),),),
                  SizedBox(
                    height: px(100),
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment(0, 0),
                          child: Container(
                            width: px(475),
                            height: px(16),
                            margin: EdgeInsets.only(left: px(18),right: px(16)),
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(184, 197, 230, 0.3),
                              borderRadius: BorderRadius.all(Radius.circular(px(2.0))),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment(0, 0),
                          child: Container(
                            width:px(475*(finished/questionTotal)),
                            height: px(16),
                            margin: EdgeInsets.only(left: px(18),right: px(16)),
                            decoration: BoxDecoration(
                              color: Color(0xff4D7FFF),
                              borderRadius: BorderRadius.all(Radius.circular(px(2.0))),
                            ),
                          ),
                        ),
                        Container(
                          width: px(27),
                          height: px(32),
                          margin: EdgeInsets.only(top: px(11),
                              left: px(475*(finished/questionTotal)+3)
                          ),
                          child: Image.asset("lib/assets/icons/other/coordinate.png"),
                        ),
                      ],
                    ),
                  ),
                  Text( '${(finished/questionTotal*100).toInt()}%',style: TextStyle(color: Color(0xff336DFF), fontSize:sp(28.0),),),
                ],
              ),
            ),
          ) : Container(),
        ],
      ),
    );
  }

  ///整改数
  Widget numberRectification(){
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(number.length, (i) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text.rich(
                TextSpan(text: '${number[i]['total']}',
                  style: TextStyle(
                      fontSize: sp(40.0),
                      color: numberColor(i),
                  ),
                  children: <TextSpan>[
                    TextSpan(text: '/${number[i]['unit']}',
                        style: TextStyle(
                          color: Color(0XFF323233),
                          fontSize:sp(20.0),)
                    ),
                  ],
                ),
              ),
              Text('${number[i]['name']}',style: TextStyle(color: Color(0xff646566), fontSize:sp(20.0),),)
            ],
          );
        }
        )
    );
  }
}