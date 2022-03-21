import 'package:flutter/material.dart';
import 'package:scet_check/api/api.dart';
import 'package:scet_check/api/request.dart';
import 'package:scet_check/components/generalduty/toast_widget.dart';
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
  bool review = false;//复查
  Map problemList = {};//问题详情列表
  List solutionList = [];//整改详情
  List reviewList = [];//复查详情

  ///选择时间所需的key，传递下去
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    declare = widget.arguments['check'] ?? false;
    problemId = widget.arguments['problemId'] ?? '';
    _getProblems();
    _setSolution();
    _getReviewList();
    super.initState();
  }
  /// 获取问题详情
  /// id:问题id
  void _getProblems() async {
    var response = await Request().get(Api.url['problem']+'/$problemId',);
    if(response['statusCode'] == 200) {
      problemList = response['data'];
      setState(() {});
    }
  }
  /// 整改详情，
  void _setSolution() async {
    Map<String,dynamic> _data = {
      'page':1,
      'size':50,
      'problem.id':problemId,
    };
    var response = await Request().get(
        Api.url['solutionList'],data: _data
    );
    if(response['statusCode'] == 200 && response['data']!=null) {
      solutionList = response['data']['list'];
      setState(() {});
    }
  }
  /// 复查详情，
  void _getReviewList() async {
    Map<String,dynamic> _data = {
      'page':1,
      'size':50,
      'problem.id': problemId,
    };
    var response = await Request().get(
        Api.url['reviewList'],data: _data
    );
    if(response['statusCode'] == 200 && response['data']!=null) {
      reviewList = response['data']['list'];
      for(var i=0;i<reviewList.length;i++){
        if(reviewList[i]['isSolved'] == true){
          review = true;
        }
      }
      setState(() {});
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Column(
        children: [
          topBar(),
          Expanded(
            child: ListView(
              padding: EdgeInsets.only(top: 0),
              children: [
                Container(
                  margin: EdgeInsets.only(top: px(5)),
                  color: Colors.white,
                  child: FormCheck.tabText(
                    title: "01",
                    str: '${problemList['detail']}',
                  ),
                ),
                //问题详情与申报
                FillInForm(
                  arguments:{
                    'declare':false,//申报
                    'key':_scaffoldKey,
                    'problemId':problemId,
                    'problemList':problemList,
                  },
                  callBack: (){
                  },
                ),
                //企业整改详情
                EnterpriseReform(
                  problemId: problemId,
                  solutionList: solutionList,
                ),
                //现场复查情况
                ReviewSituation(
                  arguments:{
                    'problemId':problemId,
                    'reviewList':reviewList,
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
  ///头部
  Widget topBar(){
    return Container(
      color: Colors.white,
      height: px(88),
      margin: EdgeInsets.only(top: Adapt.padTopH()),
      child: Row(
        children: [
          InkWell(
            child: Container(
              height: px(40),
              width: px(41),
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(left: px(20)),
              child: Image.asset('lib/assets/icons/other/chevronLeft.png',fit: BoxFit.fill,),
            ),
            onTap: ()async{
              Navigator.pop(context);
            },
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Text("隐患排查问题整改详情",style: TextStyle(color: Color(0xff323233),fontSize: sp(36),fontFamily: 'M'),),
            ),
          ),
          GestureDetector(
            child: Container(
              width: px(40),
              height: px(41),
              margin: EdgeInsets.only(right: px(20)),
              child: Image.asset('lib/assets/icons/form/add.png'),),
            onTap: () async{
              if(solutionList.isNotEmpty && review==false){
                var res =  await  Navigator.pushNamed(context, '/fillAbarabeitung',arguments: {'id':problemId,'review':true});
                if(res == true){
                  _getReviewList();
                }
              }else{
                ToastWidget.showToastMsg('暂无整改详情');
              }
            },
          ),
        ],
      ),
    );
  }
  //日期转换
  String formatTime(time) {
    return utcToLocal(time.toString()).substring(0,10);
  }
}
