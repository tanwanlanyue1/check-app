import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scet_check/components/pertinence/companyEchart/column_echarts.dart';
import 'package:scet_check/model/provider/provider_details.dart';
import 'package:scet_check/utils/screen/screen.dart';
///相同的图表
///allStatist:全园区
///tableTitle:标题
///tableBody:表单内容
///callBack:下一页
///callPrevious:上一页
class SamePointTable extends StatefulWidget {
   String tableTitle;
   bool? allStatist;
   List? tableBody;
   List? problemType;
   int questionTotal;
   Function? callBack;
   Function? callPrevious;
   SamePointTable({Key? key, this.allStatist = false,required this.questionTotal,this.problemType,required this.tableTitle,this.tableBody,this.callBack,this.callPrevious}) : super(key: key);

  @override
  _SamePointTableState createState() => _SamePointTableState();
}

class _SamePointTableState extends State<SamePointTable> {
  List tableBody = [];//表单
  List problemType = [];//问题类型统计
  List allHeader = ['片区','隐患问题','未完成整改','整改率',];//全园区表头
  List industryHeader = ['序号','行业','百分比','问题','已整改','未整改'];//行业表头
  List areaHeader = ['序号','片区','隐患问题','已整改','未整改'];//片区表头
  List companyHeader = ['序号','片区','企业名称','隐患问题','已整改','未整改'];//企业表头
  List name =[]; //名称
  List echartData =[]; //图表数据
  List pieData =[]; //饼图数据
  String companyName = 'companyName';
  double percent = 0.0; //百分比
  bool cutPie = true;
  int questionTotal = 0;//问题总数
  double allPercent = 0;//百分比总数

  @override
  void initState() {
    super.initState();
    tableBody = widget.tableBody ?? [];
    problemType = widget.problemType ?? [];
    judge();
    percents();
    manage(problemType);
    questionTotal = widget.questionTotal;
  }

  @override
  void didUpdateWidget(SamePointTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    tableBody = widget.tableBody ?? [];
    problemType = widget.problemType ?? [];
    judge();
    percents();
    manage(problemType);
    questionTotal = widget.questionTotal;
  }

  ///处理
  ///item:表单数据
  ///获取横状图树状图的数据，讲name，date，分别e存放
  void manage(List item){
    name = [];
    pieData = [];
    List issue =[]; //问题
    List notCorrected =[]; //未整改
    int issueTotal = 0; //问题总数
    int notCorrectedTotal = 0; //未整改总数
    for(var i=0;i<item.length;i++){
      name.add(item[i]['problemTypeName']);
      issueTotal = int.parse(item[i]['allCount']);
      issue.add(int.parse(item[i]['allCount']));
      notCorrected.add(int.parse(item[i]['unsolvedCount']));
      notCorrectedTotal = int.parse(item[i]['unsolvedCount'])+notCorrectedTotal;
      pieData.add({
        'value':item[i]['allCount'],'name':item[i]['problemTypeName']
      });
    }
    echartData = [
      {
        'name':'问题:$issueTotal',
        'type': 'bar',
        'data': issue,
        'color':'#D68184'
      },
      {
        'name':'未整改:$notCorrectedTotal',
        'type': 'bar',
        'data': notCorrected,
        'color':'#FAAF64'
      }
    ];
    setState(() {});
  }

  ///判断图表的name
  judge(){
    switch (widget.tableTitle){
      case '行业': {
        companyName = 'industryName';
        setState((){});
        return;
      }
      case '片区': {
        setState((){});
        companyName = 'districtName';
        return;
      }
      case '企业': {
        companyName = 'companyName';
        setState((){});
        return;
      }
    }
    manage(tableBody);
  }

  ///表头
  ///item:表头
  List<Widget> topRow(item){
    List<Widget> bodyRow = [];
    for(var i = 0; i < item.length; i++){
      bodyRow.add(
          Expanded(
            child: Container(
              height: px(71),
              padding: EdgeInsets.symmetric(vertical: 8.0),
              alignment: Alignment.topCenter,
              child: Text(
                  '${item[i]}',
                  style: TextStyle(
                      color: Color(0XFF969799),
                      fontSize: sp(24.0),
                      fontFamily: 'M'
                  )
              ),
            ),
          )
      ) ;
    }
    return bodyRow;
  }

  ///计算最后一位百分比
  percents(){
    double allPercent = 0.0;
    for(var i = 0; i < tableBody.length; i++){
      if(i < tableBody.length-1){
        allPercent += double.parse(((int.parse(tableBody[i]['allCount'])/questionTotal)*100).toStringAsFixed(2));
      }
    }
    percent = 100 - allPercent;
    setState(() {});
  }

  ///表单
  ///item:表单data
  List<Widget> bodyRow(item){
    List<Widget> bodyRow = [];
    for(var i = 0; i < item.length; i++){
      bodyRow.add(
        Container(
          margin: EdgeInsets.only(bottom: px(12)),
          decoration: BoxDecoration(
            color: Color(0xffF5F6F7),
            borderRadius: BorderRadius.all(Radius.circular(px(36))),
          ),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: px(71),
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  alignment: Alignment.topCenter,
                  child: Text(
                      '${i+1}',
                      style: TextStyle(
                          color: Color(0XFF969799),
                          fontSize: sp(24.0)
                      )
                  ),
                ),
              ),
              Visibility(
                visible: widget.tableTitle == '企业',
                child: Expanded(
                  child: Container(
                    height: px(71),
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    alignment: Alignment.topCenter,
                    child: Text(
                        '${item[i]['districtName']}',
                        style: TextStyle(
                            color: Color(0XFF969799),
                            fontSize: sp(24.0)
                        )
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: px(71),
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  alignment: Alignment.topCenter,
                  child: Text(
                      '${item[i][companyName]}',
                      style: TextStyle(
                          color: Color(0XFF969799),
                          fontSize: sp(24.0)
                      )
                  ),
                ),
              ),
              Visibility(
                visible: widget.tableTitle == '行业',
                child: Expanded(
                  child: Container(
                    height: px(71),
                    alignment: Alignment.topCenter,
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child:
                    i < item.length-1 ?
                    Text(
                        '${((int.parse(item[i]['allCount'])/questionTotal)*100).toStringAsFixed(2)}%',
                        style: TextStyle(
                            color: Color(0XFF969799),
                            fontSize: sp(24.0)
                        )
                    ):
                    Text(
                        '${percent.toStringAsFixed(2)}%',
                        style: TextStyle(
                            color: Color(0XFF969799),
                            fontSize: sp(24.0)
                        )
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: px(71),
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  alignment: Alignment.topCenter,
                  child: Text(
                      '${item[i]['allCount']}',
                      style: TextStyle(
                          color: Color(0XFF969799),
                          fontSize: sp(24.0)
                      )
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: px(71),
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  alignment: Alignment.topCenter,
                  child: Text(
                      '${item[i]['solvedCount']}',
                      style: TextStyle(
                          color: Color(0XFF969799),
                          fontSize: sp(24.0)
                      )
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: px(71),
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  alignment: Alignment.topCenter,
                  child: Text(
                      '${item[i]['unsolvedCount']}',
                      style: TextStyle(
                          color: Color(0XFF969799),
                          fontSize: sp(24.0)
                      )
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
    return bodyRow;
  }

  ///全园区表单
  ///item:表单data
  List<Widget> allBody(item){
    List<Widget> bodyRow = [];
    for(var i = 0; i < item.length; i++){
      bodyRow.add(
          Stack(
            children: [
              Container(
                // color: i % 2 == 0 ? Color(0xffF5F8FF) : Colors.white,
                margin: EdgeInsets.only(left: px(24),right: px(24),bottom: px(12)),
                decoration: BoxDecoration(
                  color: Color(0xffF5F6F7),
                  borderRadius: BorderRadius.all(Radius.circular(px(36))),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: px(71),
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        alignment: Alignment.topCenter,
                        child: Text(
                            '${item[i]['districtName']}',
                            style: TextStyle(
                                fontSize: sp(0)
                            )
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: px(71),
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        alignment: Alignment.topCenter,
                        child: Text(
                            '${item[i]['allCount']}',
                            style: TextStyle(
                                color: Color(0XFF969799),
                                fontSize: sp(0)
                            )
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: px(71),
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        alignment: Alignment.topCenter,
                        child: Text(
                            '${item[i]['unsolvedCount']}',
                            style: TextStyle(
                                color: Color(0XFF969799),
                                fontSize: sp(0)
                            )
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                          height: px(71),
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          alignment: Alignment.topCenter,
                          child: Text(
                              '${((int.parse(item[i]['solvedCount'])/int.parse(item[i]['allCount']))*100).toStringAsFixed(2)}%',
                              style: TextStyle(
                                  color: Color(0XFF969799),
                                  fontSize: sp(0)
                              )
                          )
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: px(71),
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      alignment: Alignment.topCenter,
                      child: Text(
                          '${item[i]['districtName']}',
                          style: TextStyle(
                              color: Color(0XFF969799),
                              fontSize: sp(24.0)
                          )
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: px(71),
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      alignment: Alignment.topCenter,
                      child: Text(
                          '${item[i]['allCount']}',
                          style: TextStyle(
                              color: Color(0XFF969799),
                              fontSize: sp(24.0)
                          )
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: px(71),
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      alignment: Alignment.topCenter,
                      child: Text(
                          '${item[i]['unsolvedCount']}',
                          style: TextStyle(
                              color: Color(0XFF969799),
                              fontSize: sp(24.0)
                          )
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                        height: px(71),
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        alignment: Alignment.topCenter,
                        child: Text(
                            '${((int.parse(item[i]['solvedCount'])/int.parse(item[i]['allCount']))*100).toStringAsFixed(2)}%',
                            style: TextStyle(
                                color: Color(0XFF969799),
                                fontSize: sp(24.0)
                            )
                        )
                    ),
                  ),
                ],
              ),
            ],
          )
      );
    }
    return bodyRow;
  }

  ///选择表头
  ///type 类型
  selectHeader(String type){
    switch (type){
      case '行业': {
        return topRow(industryHeader);
      }
      case '片区': {
        return topRow(areaHeader);
      }
      case '企业': {
        return topRow(companyHeader);
      }
      case '全园区': {
        return topRow(allHeader);
      }
      default:
        return topRow(industryHeader);
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.allStatist != true ?
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.only(top: px(17),left: px(20)),
          margin: EdgeInsets.only(top: px(16)),
          color: Colors.white,
          width: double.maxFinite,
          child: Text("问题类型排名图",
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: sp(30),color: Color(0xff323233),fontFamily: 'M'),),
        ),
        SizedBox(
          height: px(720 + ((name.length/2)*20)),
          child: ColumnEcharts(
            erectName: name,
            data: echartData,
            pieData: pieData,
            erect: true,
          ),),
        Container(
            margin: EdgeInsets.only(top: px(24),bottom: px(24)),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(px(4))),
            ),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(top: px(17),left: px(20)),
                        child: Text("${widget.tableTitle}问题排名图",
                          textAlign: TextAlign.left,
                          style: TextStyle(color: Color(0xff323233),fontSize: sp(32)),),
                      ),
                    ),
                  ],
                ),

                Row(
                  children: [
                    SizedBox(
                      width: px(50),
                      child: Icon(Icons.chevron_left_outlined,size: 26,color: Colors.transparent,),
                    ),
                    Expanded(
                      flex: 1,
                      child: Row(
                        children: selectHeader(widget.tableTitle),
                      ),
                    ),
                    SizedBox(
                      child: Icon(Icons.chevron_right_outlined,size: 26,color: Colors.transparent,),
                    ),
                  ],
                ),

                Row(
                  children: [
                    InkWell(
                      onTap: (){
                        widget.callPrevious?.call();
                      },
                      child: SizedBox(
                        width: px(50),
                        height: px(150),
                        child: Icon(Icons.chevron_left_outlined,size: 26,),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: bodyRow(tableBody),
                      ),
                    ),
                    InkWell(
                      onTap: (){
                        widget.callBack?.call();
                      },
                      child: SizedBox(
                        height: px(150),
                        child: Icon(Icons.chevron_right_outlined,size: 26,),
                      ),
                    ),
                  ],
                ),
              ],
            )
        ),
      ],
    ):
    Container(
      margin: EdgeInsets.only(top: px(12)),
      child: Column(
        children: [
          Row(
            children: selectHeader(widget.tableTitle),
          ),
          Column(
            children: allBody(tableBody),
          ),
        ],
      ),
    );
  }
}
