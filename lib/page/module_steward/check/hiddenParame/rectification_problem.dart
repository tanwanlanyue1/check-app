import 'package:flutter/material.dart';
import 'package:scet_check/api/api.dart';
import 'package:scet_check/api/request.dart';
import 'package:scet_check/components/generalduty/toast_widget.dart';
import 'package:scet_check/page/module_steward/check/hiddenParame/components/rectify_components.dart';
import 'package:scet_check/page/module_steward/check/potentialRisks/enterprise_reform.dart';
import 'package:scet_check/page/module_steward/check/potentialRisks/fill_in_form.dart';
import 'package:scet_check/page/module_steward/check/potentialRisks/review_situation.dart';
import 'package:scet_check/routers/routes.dart';
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
  Map argumentMap = {};//传递的参数

  ///选择时间所需的key，传递下去
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    if(mounted){
      declare = widget.arguments['check'] ?? false;
      problemId = widget.arguments['problemId'] ?? '';
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
      'problem.id':problemId,
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
          RectifyComponents.appBarBac(),
          topBar(),
          Expanded(
            child: ListView(
              padding: EdgeInsets.only(top: 0),
              children: [
                Container(
                  margin: EdgeInsets.only(top: px(5)),
                  color: Colors.white,
                  child: RectifyComponents.tabText(
                    title: "01",
                    str: '${problemList['detail']}',
                    status: problemList['status'] ?? 1
                  ),
                ),
                //问题详情与申报
                FillInForm(
                  arguments:{
                    'declare':false,//申报
                    'key':_scaffoldKey,
                    'problemList':problemList,
                  },
                ),
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
  ///头部
  Widget topBar(){
    return Container(
      color: Colors.white,
      height: px(88),
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
              margin: EdgeInsets.only(right: px(20)),
              child: (problemList['isProblemCommit'] ?? false) ? Image.asset(
                  'lib/assets/icons/form/add.png',
                width: px(50),
                height: px(51),
              ):
              Text('修改详情',style: TextStyle(color: Color(0xff323233),fontSize: sp(28))),
            ),
            onTap: () async{
              ///是否问题
              ///判断是否是复查还是修改问题详情
              ///问题是否复查结束
              if(problemList['isProblemCommit']){
                if(solutionList.isNotEmpty && review==false){
                  if(problemList['status'] == 2){
                    var res =  await Navigator.pushNamed(context, '/fillAbarabeitung',arguments: {'id':problemId,'review':true});
                    if(res == true){
                      _getReviewList();
                      _getProblems();
                      _setSolution();
                    }
                  }else{
                    ToastWidget.showToastMsg('当前状态不可编辑');
                  }
                }else{
                  ToastWidget.showToastMsg('暂无整改详情');
                }
              }else{
                final Function? pageContentBuilder = routes['/fillInForm'];
                var res = await Navigator.push(context, MaterialPageRoute(
                    settings: RouteSettings(name: '/fillInForm'),//修改问题
                    builder: (context) => pageContentBuilder!(context, arguments: argumentMap)
                ));
                if(res == true){
                  _getProblems();
                  _getReviewList();
                }
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
