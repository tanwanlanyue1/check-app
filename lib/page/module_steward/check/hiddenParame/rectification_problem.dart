import 'package:flutter/material.dart';
import 'package:scet_check/api/api.dart';
import 'package:scet_check/api/request.dart';
import 'package:scet_check/page/module_steward/check/statisticAnaly/components/form_check.dart';
import 'package:scet_check/page/module_steward/check/hiddenParame/components/rectify_components.dart';
import 'package:scet_check/page/module_steward/check/potentialRisks/enterprise_reform.dart';
import 'package:scet_check/page/module_steward/check/potentialRisks/fill_in_form.dart';
import 'package:scet_check/page/module_steward/check/potentialRisks/review_situation.dart';
import 'package:scet_check/utils/screen/screen.dart';
import 'package:scet_check/utils/time/utc_tolocal.dart';

///企业台账详情
/// arguments = {check:是否申报,'problemId':问题id}
class RectificationProblem extends StatefulWidget {
  final arguments;
  const RectificationProblem({Key? key,this.arguments}) : super(key: key);

  @override
  _RectificationProblemState createState() => _RectificationProblemState();
}

class _RectificationProblemState extends State<RectificationProblem> {

  String problemTitle = '';//问题标题
  String problemId = '';//问题Id
  int status  = 0; //状态；-1：未处理;0:处理完；1：处理中
  bool declare = false;//申报

  ///选择时间所需的key，传递下去
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    declare = widget.arguments['check'] ?? false;
    problemId = widget.arguments['problemId'] ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Column(
        children: [
          RectifyComponents.topBar(
              title: '隐患排查问题整改详情',
              callBack: (){
                Navigator.pop(context);
              }
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.only(top: 0),
              children: [
                InkWell(
                  child: Container(
                    margin: EdgeInsets.only(top: px(5)),
                    color: Colors.white,
                    child: FormCheck.tabText(
                      title: "01",
                      str: '废气治理设施巡检记录不完善,点击跳转复查',
                    ),
                  ),
                  onTap: ()async{
                    Navigator.pushNamed(context, '/fillAbarabeitung',arguments: {'id':problemId,'review':true});
                  },
                ),
                //问题详情与申报
                FillInForm(
                  arguments:{
                    'declare':false,//申报
                    'key':_scaffoldKey,
                    'problemId':problemId,
                  },
                  callBack: (){
                  },
                ),
                //企业整改详情
                EnterpriseReform(
                  problemId: problemId,
                ),
                //现场复查情况
                ReviewSituation(
                  arguments:{
                    'problemId':problemId,
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }


  //日期转换
  String formatTime(time) {
    return utcToLocal(time.toString()).substring(0,10);
  }
}
