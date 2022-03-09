import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scet_check/components/column_echarts.dart';
import 'package:scet_check/model/provider/provider_details.dart';
import 'package:scet_check/utils/screen/screen.dart';

///相同的图表
///tableHeader:表头
///tableBody:表单内容
///callBack:下一页
///callPrevious:上一页
class SamePointTable extends StatefulWidget {
   String tableHeader;
   List? tableBody;
   Function? callBack;
   Function? callPrevious;
   SamePointTable({Key? key,required this.tableHeader,this.tableBody,this.callBack,this.callPrevious}) : super(key: key);

  @override
  _SamePointTableState createState() => _SamePointTableState();
}

class _SamePointTableState extends State<SamePointTable> {
  List tableBody = [];//表单
  List industryHeader = ['序号','行业','百分比','问题','已整改','未整改'];//行业表头
  List areaHeader = ['序号','片区','隐患问题','已整改','未整改'];//片区表头
  List companyHeader = ['序号','片区','企业名称','隐患问题','已整改','未整改'];//企业表头
  int echart = 0;//echart 种类下标 0-饼图 1-竖状图 2-横状图
  List name =[]; //名称
  List echartData =[]; //图表数据
  List pieData =[]; //饼图数据
  ///全局变量  判断展示哪一个图表
  late ProviderDetaild _providerDetaild;

  @override
  void initState() {
    super.initState();
    tableBody = widget.tableBody ?? [];
    manage(tableBody);
  }

  @override
  void didUpdateWidget(SamePointTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    tableBody = widget.tableBody ?? [];
    manage(tableBody);
  }

  ///处理
  ///item:表单数据
  ///获取横状图树状图的数据，讲name，date，分别存放
  void manage(List item){
    name = [];
    pieData = [];
    List issue =[]; //问题
    List notCorrected =[]; //未整改
    int issueTotal = 0; //问题总数
    int notCorrectedTotal = 0; //未整改总数
    for(var i=0;i<item.length;i++){
      name.add(item[i]['name']);
      issue.add(item[i]['totalLedgers']);
      notCorrected.add(item[i]['notRectified']);
      issueTotal = item[i]['totalLedgers']+issueTotal;
      notCorrectedTotal = item[i]['notRectified']+notCorrectedTotal;
      pieData.add({
        'value':item[i]['totalLedgers'],'name':item[i]['name']
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
      }];
    setState(() {});
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
              child: Container(
                alignment: Alignment.topCenter,
                child: Text(
                    '${item[i]}',
                    style: TextStyle(
                        color: Color(0XFF969799),
                        fontSize: sp(24.0)
                    )
                ),
              ),
            ),
          )
      ) ;
    }
    return bodyRow;
  }

  ///表单
  ///item:表单data
  List<Widget> bodyRow(item){
    List<Widget> bodyRow = [];
    for(var i = 0; i < item.length; i++){
      bodyRow.add(
          Container(
            color: i % 2 == 0 ? Color(0xffF5F8FF) : Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: px(71),
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Container(
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
                ),
                Visibility(
                  visible: widget.tableHeader == '企业',
                  child: Expanded(
                    child: Container(
                      height: px(71),
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Container(
                        alignment: Alignment.topCenter,
                        child: Text(
                            '${item[i]['area']}',
                            style: TextStyle(
                                color: Color(0XFF969799),
                                fontSize: sp(24.0)
                            )
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: px(71),
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Container(
                      alignment: Alignment.topCenter,
                      child: Text(
                          '${item[i]['name']}',
                          style: TextStyle(
                              color: Color(0XFF969799),
                              fontSize: sp(24.0)
                          )
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: widget.tableHeader == '行业',
                  child: Expanded(
                    child: Container(
                      height: px(71),
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Container(
                        alignment: Alignment.topCenter,
                        child: Text(
                            '${item[i]['rectified']/item[i]['totalLedgers']}%',
                            style: TextStyle(
                                color: Color(0XFF969799),
                                fontSize: sp(24.0)
                            )
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: px(71),
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Container(
                      alignment: Alignment.topCenter,
                      child: Text(
                          '${item[i]['totalLedgers']}',
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
                    child: Container(
                      alignment: Alignment.topCenter,
                      child: Text(
                          '${item[i]['rectified']}',
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
                    child: Container(
                      alignment: Alignment.topCenter,
                      child: Text(
                          '${item[i]['notRectified']}',
                          style: TextStyle(
                              color: Color(0XFF969799),
                              fontSize: sp(24.0)
                          )
                      ),
                    ),
                  ),
                ),
              ],
            ),
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
      default:
        return topRow(industryHeader);
    }
  }

  @override
  Widget build(BuildContext context) {
    _providerDetaild = Provider.of<ProviderDetaild>(context, listen: true);
    return Card(
      color: Colors.white,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(top: px(17),left: px(20)),
                  child: Text("园区风险隐患排查总览-${widget.tableHeader}问题排名图",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xff323233),fontSize: sp(32)),),
                ),
              ),
              GestureDetector(
                child: Container(
                  width: px(40),
                  height: px(40),
                  margin: EdgeInsets.only(top: px(17),right: px(16),left: px(84)),
                  child: echart == 0 ? Image.asset('lib/assets/images/home/pieCut.png') :
                  echart == 1 ? Image.asset('lib/assets/images/home/colunmCut.png'):
                   Image.asset('lib/assets/images/home/chartSwitch.png'),
                ),
                onTap: () async{
                  // Navigator.pushNamed(context, '/enterpriseDetails');
                  Navigator.pushNamed(context, '/stewardCheck');
                  // _providerDetaild.setPie();
                  // if(echart != 2){
                  //   echart++;
                  // }else{
                  //   echart = 0;
                  // }
                  // setState(() {});
                },
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
                child: _providerDetaild.pieChart ?
                Container():
                Row(
                  children: selectHeader(widget.tableHeader),
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
                  _providerDetaild.pieChart ?
                  _providerDetaild.setcloumn(echart) : '';
                  if(echart != 0){
                    echart--;
                  }else{
                    echart = 2;
                  }
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
                child: _providerDetaild.pieChart ?
                  SizedBox(
                  height: px(700),
                  width: px(550),
                  child: ColumnEcharts(
                    erectName: name,
                    data: echartData,
                    pieData: pieData,
                  ),
                  ):
                  Column(
                  children: bodyRow(tableBody),
                ),
              ),
              InkWell(
                onTap: (){
                  _providerDetaild.pieChart ?
                  _providerDetaild.setcloumn(echart) : '';
                  if(echart != 2){
                    echart++;
                  }else{
                    echart = 0;
                  }
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
      ),
    );
  }
  
}
