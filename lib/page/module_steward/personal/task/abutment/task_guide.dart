import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:scet_check/api/api.dart';
import 'package:scet_check/api/request.dart';
import 'package:scet_check/components/generalduty/upload_file.dart';
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
  Map taskGuide = {};//指引

  @override
  void initState() {
    // TODO: implement initState
    // _getGuide(id: widget.arguments?['analyzeId']);
    _getGuide(id: 1);
    super.initState();
  }
  /// 获取任务指引详情
  void _getGuide({required int id}) async {
    var response = await Request().get(Api.url['modelAnalyzeById']+'?id=$id',);
    if(response['errCode'] == '10000') {
      taskGuide = response['result'];
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TaskCompon.topTitle(
              title: '任务指引',
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
            title: '判研结果:',
            alignStart: true,
            child: Text('${taskGuide['analyzeResult'] ?? '/'}',style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),),
          ),
          FormCheck.rowItem(
            title: '报警代码:',
            child: Text(
              '${taskGuide['code'] ?? '/'}', style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),),
          ),
          FormCheck.rowItem(
            title: '取证主要要点:',
            child: Text('${taskGuide['forensicsPoint'] ?? '/'}',style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),),
          ),
          FormCheck.rowItem(
            title: '可能存在的违法行为:',
            child: Text('${taskGuide['possibleIllegalConduct'] ?? '/'}',style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),),
          ),
          FormCheck.rowItem(
            title: '任务附件:',
            alignStart: true,
            child: UploadFile(
              url: '/',
              abutment: true,
              fileList: taskGuide['fileList'],
            ),
          ),
          FormCheck.rowItem(
            title: '法律文件:',
            alignStart: true,
            child: htmlCore(
                htmlUrl: taskGuide['law']
            ),
          ),
          FormCheck.rowItem(
            title: '填写核查步骤:',
            alignStart: true,
            child: htmlCore(
              htmlUrl: taskGuide['checkStep']
            ),
          ),
        ],
      ),
    );
  }
  ///富文本
 Widget htmlCore({required String htmlUrl}){
    return HtmlWidget(htmlUrl);
 }
}
