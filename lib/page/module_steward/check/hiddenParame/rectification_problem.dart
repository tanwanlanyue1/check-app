import 'package:flutter/material.dart';
import 'package:scet_check/api/api.dart';
import 'package:scet_check/api/request.dart';
import 'package:scet_check/components/generalduty/toast_widget.dart';
import 'package:scet_check/page/module_steward/check/hiddenParame/components/rectify_components.dart';
import 'package:scet_check/page/module_steward/check/potentialRisks/enterprise_reform.dart';
import 'package:scet_check/page/module_steward/check/potentialRisks/fill_in_form.dart';
import 'package:scet_check/page/module_steward/check/potentialRisks/review_situation.dart';
import 'package:scet_check/page/module_steward/check/statisticAnaly/components/form_check.dart';
import 'package:scet_check/page/module_steward/personal/components/task_compon.dart';
import 'package:scet_check/utils/screen/screen.dart';

///企业台账详情
/// arguments = {check:是否申报,'problemId':问题id,"inventoryStatus":清单状态}
class RectificationProblem extends StatefulWidget {
  final arguments;
  const RectificationProblem({Key? key,this.arguments}) : super(key: key);

  @override
  _RectificationProblemState createState() => _RectificationProblemState();
}

class _RectificationProblemState extends State<RectificationProblem> {

  String problemTitle = '';//问题标题
  String problemId = '';//问题Id
  bool declare = false;//申报
  // bool review = false;//复查
  Map problemList = {};//问题详情列表
  List solutionList = [];//整改详情
  List reviewList = [];//复查详情
  Map argumentMap = {};//传递的参数
  int inventoryStatus = 2;//清单状态
  ///选择时间所需的key，传递下去
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    if(mounted){
      declare = widget.arguments['check'] ?? false;
      problemId = widget.arguments['problemId'] ?? '';
      inventoryStatus = widget.arguments['inventoryStatus'] ?? inventoryStatus;
      _getProblems();
      _setSolution();
      _getReviewList();
    }
    super.initState();
  }
  /// 获取问题详情
  /// id:问题id
  void _getProblems() async {
    var response = await Request().get(Api.url['problem']+'/$problemId',);
    if(response['statusCode'] == 200) {
      problemList = response['data'];
      argumentMap = {
        'declare':true,//申报
        'uuid': problemList['inventoryId'],//清单ID
        'districtId': problemList['districtId'],//片区id
        'companyId': problemList['companyId'],//企业id
        'industryId': problemList['industryId'],//行业ID
        'problemList': problemList,//问题详情
      };
      setState(() {});
    }
  }
  /// 整改详情，
  /// 1,2.3只能看提交的
  void _setSolution() async {
    Map<String,dynamic> _data = {
      'problemId':problemId,
      'status':"[1,2,3]"
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
  /// 是否复查结束
  void _getReviewList() async {
    Map<String,dynamic> _data = {
      'problemId': problemId,
    };
    var response = await Request().get(
        Api.url['reviewList'],data: _data
    );
    if(response['statusCode'] == 200 && response['data']!=null) {
      reviewList = response['data']['list'];
      setState(() {});
    }
  }

  ///判断整改是否结束
  ///是否问题
  ///判断是否是复查还是修改问题详情
  ///问题是否复查结束
  void checkEnd () async{
    if(inventoryStatus != 5 && inventoryStatus != 6){
      if(problemList['status'] == 1 || problemList['status'] == 2 || problemList['status'] == 4){
        var res =  await Navigator.pushNamed(context, '/fillAbarbeitung',arguments: {'id':problemId,'review':true});
        if(res == true){
          _getReviewList();
          _getProblems();
          _setSolution();
        }
      }else if(inventoryStatus == 3){
        ToastWidget.showToastMsg('问题正在审核中，请等待！');
      }
    }else{
      if(argumentMap.isNotEmpty){
        var res = await Navigator.pushNamed(context, '/fillInForm', arguments: argumentMap);
        if(res == true){
          _getProblems();
          _getReviewList();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Column(
        children: [
          TaskCompon.topTitle(
              title: '隐患排查问题整改详情',
              left: true,
              child: Visibility(
                visible: inventoryStatus != 2 && inventoryStatus != 4 && problemList['status'] != 3,
                child: GestureDetector(
                  child: Container(
                    margin: EdgeInsets.only(right: px(20)),
                    width: px(50),
                    height: px(51),
                    child: Image.asset(
                      'lib/assets/icons/form/alter.png',
                    ),
                  ),
                  onTap: (){
                    checkEnd();
                  },
                ),
              ),
              callBack: (){
                Navigator.pop(context);
              }),
          Expanded(
            child: ListView(
              padding: EdgeInsets.only(top: 0),
              children: [
                Container(
                  margin: EdgeInsets.only(top: px(5)),
                  color: Colors.white,
                  child: RectifyComponents.tabText(
                      title: "01",
                      str: '${problemList['name']}',
                      status: problemList['status'] ?? 1
                  ),
                ),
                //问题详情与申报
                FillInForm(
                  arguments:{
                    'declare':false,//申报
                    'key':_scaffoldKey,
                    'problemList':problemList,
                    "inventoryStatus":widget.arguments['inventoryStatus'],
                  },
                ),
                solutionList.isNotEmpty?
                detaile() : Container(),
                //企业整改详情
                solutionList.isNotEmpty?
                EnterpriseReform(
                  problemId: problemId,
                  solutionList: solutionList,
                ):
                Container(),
                //现场复查情况
                reviewList.isNotEmpty?
                ReviewSituation(
                  arguments:{
                    'problemId':problemId,
                    'reviewList':reviewList,
                  },
                ):
                Container(),
              ],
            ),
          )
        ],
      ),
    );
  }

  ///整改详情
  Widget detaile(){
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(left: px(24)),
      margin: EdgeInsets.only(top: px(4)),
      height: px(56),
      child: FormCheck.formTitle('整改详情'),
    );
  }
}
