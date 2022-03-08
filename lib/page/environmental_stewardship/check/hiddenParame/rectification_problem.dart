import 'package:flutter/material.dart';
import 'package:scet_check/components/form_check.dart';
import 'package:scet_check/page/environmental_stewardship/check/hiddenParame/components/rectify_components.dart';
import 'package:scet_check/page/environmental_stewardship/check/potentialRisks/enterprise_reform.dart';
import 'package:scet_check/page/environmental_stewardship/check/potentialRisks/fill_in_form.dart';
import 'package:scet_check/page/environmental_stewardship/check/potentialRisks/review_situation.dart';
import 'package:scet_check/utils/dateUtc/date_utc.dart';
import 'package:scet_check/utils/screen/screen.dart';

class RectificationProblem extends StatefulWidget {
  final arguments;
  const RectificationProblem({Key? key,this.arguments}) : super(key: key);

  @override
  _RectificationProblemState createState() => _RectificationProblemState();
}

//企业台账详情
class _RectificationProblemState extends State<RectificationProblem> {

  List imgDetails = ['https://img2.baidu.com/it/u=1814268193,3619863984&fm=253&fmt=auto&app=138&f=JPEG?w=632&h=500',
    'https://img0.baidu.com/it/u=857510153,4267238650&fm=253&fmt=auto&app=120&f=JPEG?w=1200&h=675',
    'https://img1.baidu.com/it/u=2374960005,3369337623&fm=253&fmt=auto&app=120&f=JPEG?w=499&h=312',
    'https://img0.baidu.com/it/u=857510153,4267238650&fm=253&fmt=auto&app=120&f=JPEG?w=1200&h=675',
  ];

  int choice  = 0; //单选
  bool declare = false;//申报

  bool readOnly = true; //是否为只读

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    declare = widget.arguments['check'] ?? false;
    readOnly = widget.arguments['readOnly'] ?? false;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: ListView(
        padding: EdgeInsets.only(top: 0),
        children: [
          RectifyComponents.topBar(
              title: '隐患排查问题整改详情',
              callBack: (){
                Navigator.pop(context);
              }
          ),
          Container(
            color: Colors.white,
            margin: EdgeInsets.only(top: px(5)),
            child: FormCheck.tabText(
              title: "01",
              str: '废气治理设施巡检记录不完善',
            ),
          ),
          //问题详情与申报
          FillInForm(
            arguments:{
              'declare':declare,//申报
              'key':_scaffoldKey
            },
            callBack: (){
            },
          ),
          //企业整改详情
          EnterpriseReform(),
          //现场复查情况
           ReviewSituation(
            arguments:{
              'readOnly':readOnly,
              'key':_scaffoldKey
            },
          ),
          Visibility(
            visible: declare,
            child: FormCheck.submit(),
          ),
        ],
      ),
    );
  }


  //日期转换
  String formatTime(time) {
    return dateUtc(time.toString()).substring(0,10);
  }
}
