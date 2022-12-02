import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:scet_check/api/api.dart';
import 'package:scet_check/api/request.dart';
import 'package:scet_check/page/module_steward/check/statisticAnaly/components/form_check.dart';
import 'package:scet_check/page/module_steward/personal/components/task_compon.dart';
import 'package:scet_check/utils/screen/screen.dart';

///任务指引来源页
class TaskGuide extends StatefulWidget {
  final Map? arguments;
  const TaskGuide({Key? key,this.arguments}) : super(key: key);

  @override
  _TaskGuideState createState() => _TaskGuideState();
}

class _TaskGuideState extends State<TaskGuide> {
  Map taskGuide = {};//检查的基本数据
  Map analyze = {};//核查数据
  List gist = [
    {'name':'检查要点','url':'checkStep','tidy':false},
    {'name':'取证要点','url':'forensicsPoint','tidy':false},
    {'name':'法律依据','url':'law','tidy':false},
  ];//要点

  @override
  void initState() {
    // TODO: implement initState
    taskGuide = widget.arguments?['cycleList'];
    _getSummaryById();
    super.initState();
  }
  /// 查询研判汇总详情-查询单次研判所有异常
  /// id:
  void _getSummaryById() async {
    var response = await Request().get(
      Api.url['getSummaryById'],
      data: {
        'id':widget.arguments?['id'],
      },
    );
    if(response['errCode'] == '10000') {
      analyze = response['result'];
      setState(() {});
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TaskCompon.topTitle(
              title: '详细检查信息',
              left: true,
              callBack: (){
                Navigator.pop(context);
              }
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.only(top: 0),
              children: [
                basicInfo(),
                Column(
                  children: List.generate(gist.length, (i) => mainPoint(i: i)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ///基本信息
  Widget basicInfo(){
    return Container(
      margin: EdgeInsets.only(left: px(24),right: px(24),top: px(24)),
      padding: EdgeInsets.only(left: px(24),right: px(24),bottom: px(24)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(px(8.0))),
      ),
      child: Column(
        children: [
          Container(
            color: Colors.white,
            margin: EdgeInsets.only(top: px(12)),
            height: px(56),
            child: FormCheck.formTitle('基本信息'),
          ),
          FormCheck.rowItem(
            title: '企业名称:',
            child: Text('${taskGuide['companyName'] ?? '/'}',style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),),
          ),
          FormCheck.rowItem(
            title: '排放口名称:',
            child: Text('${taskGuide['name'] ?? '/'}',style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),),
          ),
          FormCheck.rowItem(
            title: '判研结果:',
            alignStart: true,
            child: analyze['recordList']?.length != null ?
            Column(
              children: List.generate(analyze['recordList'].length, (index) => record(recordList: analyze['recordList'][index])),
            ) : Container(),
          ),
          FormCheck.rowItem(
            title: '判研时间:',
            child: Text(
              taskGuide['analyzeDate'] == null ? '/' :
              DateTime.fromMillisecondsSinceEpoch(taskGuide['analyzeDate']).toString().substring(0,19), style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),),
          ),
          FormCheck.rowItem(
            title: '判研分值:',
            alignStart: true,
            child: Text('${taskGuide['score'] ?? '/'}',style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),),
          ),
        ],
      ),
    );
  }

  ///记录列表
  Widget record({required Map recordList}){
    return InkWell(
      child: Container(
        padding: EdgeInsets.only(bottom: px(12)),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(bottom: BorderSide(width: px(4),color: Color(0xffF6F6F6)),),//0xffF6F6F6 0xff19191A
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(top: px(12),bottom: px(12)),
              child: Row(
                children: [
                  Expanded(
                    child: Text('(${recordList['recordCount']}次)  ${recordList['analyzeResult']}',style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),),
                  ),
                  Icon(Icons.keyboard_arrow_right)
                ],
              ),
            ),
          ],
        ),
      ),
      onTap: () async {
        Navigator.pushNamed(context, '/guideDetail',arguments: {"recordList":recordList,'factorBelong':analyze['factorBelong']});
      },
    );
  }

  ///要点
  Widget mainPoint({required int i}){
    return Container(
      margin: EdgeInsets.all(24.px),
      padding: EdgeInsets.all(px(12)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(px(8.0))),
      ),
      child: InkWell(
        child: Column(
          children: [
            FormCheck.formTitle(
                gist[i]['name'],
                showUp: true,
                tidy: gist[i]['tidy'],
                onTaps: (){
                  gist[i]['tidy'] = !gist[i]['tidy'];
                  setState(() {});
                }
            ),
            Visibility(
              visible: gist[i]['tidy'],
              child: GestureDetector(
                child: Container(
                  width: Adapt.screenW(),
                  color: Colors.white,
                  child: HtmlWidget(
                    analyze[gist[i]['url']] ?? '/',
                  ),
                ),
              ),
            ),
          ],
        ),
        onTap: (){
          gist[i]['tidy'] = !gist[i]['tidy'];
          setState(() {});
        },
      ),
    );
  }
}
