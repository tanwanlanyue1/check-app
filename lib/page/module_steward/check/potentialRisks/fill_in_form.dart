import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:scet_check/api/api.dart';
import 'package:scet_check/api/request.dart';
import 'package:scet_check/components/generalduty/down_input.dart';
import 'package:scet_check/components/generalduty/toast_widget.dart';
import 'package:scet_check/page/module_steward/check/statisticAnaly/components/form_check.dart';
import 'package:scet_check/components/generalduty/time_select.dart';
import 'package:scet_check/components/generalduty/upload_image.dart';
import 'package:scet_check/page/module_steward/personal/components/task_compon.dart';
import 'package:scet_check/utils/screen/screen.dart';
import 'package:scet_check/utils/storage/data_storage_key.dart';
import 'package:scet_check/utils/storage/storage.dart';
import 'package:scet_check/utils/time/utc_tolocal.dart';
import 'package:uuid/uuid.dart';

///排查问题填报
///        arguments = {
///           'declare':true,//申报
///           'uuid': uuid,//清单ID
///           'addProblem':true,//新增问题
///           'problemId':problemId,//问题id
///           "stewardCheck":stewardCheck,//签到人
///           'district': repertoire['company']['districtId'],//片区id
///           'companyId': repertoire['company']['id'],//企业id
///           'industrys': repertoire['company']['industrys'],//行业ID
///           'problemList':problemList,//问题详情
///           'inventoryStatus':repertoire['status'],//清单状态
///           'audit':true,//审核人员进来修改
///         };
class FillInForm extends StatefulWidget {
  final Map? arguments;
  const FillInForm({Key? key,this.arguments}) : super(key: key);

  @override
  _FillInFormState createState() => _FillInFormState();
}

class _FillInFormState extends State<FillInForm> {
  List imgDetails = [];//问题图片列表
  // List lawImg = [];//法律法规截图
  List typeList = [];//问题类型列表
  Map problemList = {};//问题详情列表
  List requireList = [
    {'id':0,'name':'立行立改'},
    {'id':1,'name':'限期整改'},
    {'id':2,'name':'立案执法'},
  ];//整改要求
  bool declare = false; //申报
  bool addProblem = false;//新增问题
  bool isImportant = false; //是否重点
  String checkPersonnel = '';//排查人员
  String problemTitle = '';//问题标题
  String issueDetails = '';//问题详情
  String type = '';//问题类型 一级
  String secondType = '';//问题类型 二级
  String typeId = '';//问题类型二级ID
  String secondTypeId = '';//问题类型一级ID
  String inventoryId = '';//清单ID
  String companyId = '';//企业ID
  List industry = [];//行业数组
  List industryId = [];//行业id数组
  int areaId = 1;//区域ID
  String problemId = '';//问题id
  String require = '立行立改';//整改要求
  String _uuid = '';//uuid
  Uuid uuid = Uuid();//uuid
  String userName = '';//用户名
  String userId = '';//用户id
  String checkDay = '';//详情排查日期
  String solvedAt = '';//整改期限
  String otherType = '';//其他类型
  String flowStatus = '';//流程状态
  bool other = false;//其他类型
  bool delete = false;//是否可以删除问题
  int remind = 0;//提醒次数
  late GlobalKey<ScaffoldState> _scaffoldKey; //时间选择key
  // DateTime checkTime = DateTime.now();//填报排查日期
  DateTime? rectifyTime;//整改期限
  List problemType = [];//二级问题类型数组
  /// 获取问题类型
  /// level：第一级问题的类型
  void _getProblemType() async {
    var response = await Request().get(Api.url['problemTypeList'],data: {"level":1});
    if(response['statusCode'] == 200) {
      typeList = response['data']['list'];
      setState(() {});
    }
  }

  /// 获取问题详情
  /// id:问题id
  void _getProblems() async {
    problemList = widget.arguments?['problemList'] ?? {};
    if(problemList.isNotEmpty){
      checkPersonnel = problemList['screeningPerson'] ?? '';
      checkDay = formatTime(problemList['createdAt']);
      if(problemList['problemType']['parent'] == null){
        type = problemList['problemType']['name'];
      }else{
        type = problemList['problemType']['parent']['name'];
        secondType = problemList['problemType']['name'];
      }
      userName = problemList['user']['nickname'];
      userId = problemList['user']['id'].toString();
      issueDetails = problemList['detail'] ?? '';
      imgDetails = problemList['images'] ?? [];
      problemTitle = problemList['name'];
      problemId = problemList['id'];
      inventoryId = problemList['inventoryId'];
      typeId = problemList['problemTypeId'];
      companyId = problemList['companyId'];
      industry = problemList['industrys'] ?? [];
      areaId = problemList['districtId'];
      isImportant = problemList['isImportant'];
      require = problemList['requirement'] ?? '/';
      solvedAt = problemList['solvedAt'] != null ? formatTime(problemList['solvedAt']) : '/';
      rectifyTime = problemList['solvedAt'] != null ? DateTime.parse(problemList['solvedAt']) : null;
      delete = (problemList['status'] == 0) ? true : false;
      industrysType();
    }
    setState(() {});
  }

  //行业id数组
  void industrysType(){
    industryId = [];
    for(var i = 0; i < industry.length; i++){
      industryId.add(industry[i]['id']);
    }
    setState(() {});
  }
  @override
  void initState() {
    // TODO: implement initState
    _uuid = uuid.v4();
    declare = widget.arguments?['declare'] ?? true;
    _scaffoldKey = widget.arguments?['key'] ?? GlobalKey<ScaffoldState>();
    addProblem = widget.arguments?['addProblem'] ?? false;
    userName = jsonDecode(StorageUtil().getString(StorageKey.PersonalData))['nickname'];
    userId= jsonDecode(StorageUtil().getString(StorageKey.PersonalData))['id'].toString();
    if(declare){
      inventoryId = widget.arguments?['uuid'];
      companyId = widget.arguments?['companyId'];
      industry = widget.arguments?['industrys'] ?? [];
      areaId = widget.arguments?['districtId'] ?? 1;
      checkPersonnel = widget.arguments?['stewardCheck'] ?? '';
      checkDay = DateTime.now().toString().substring(0,16);
      _getProblemType();
      _getProblems();
    }else{
      _getProblems();
    }
    super.initState();
  }

  /// 问题填报 填报post，/修改
  /// screeningPerson:填报人
  /// detail:问题详情
  /// images:图片
  /// lawImages:法律依据图片
  /// status:状态:1,未整改;2,已整改;3,整改已通过;4,整改未通过
  /// problemTypeId:问题类型ID
  /// inventoryId:清单ID
  /// userId:用户ID
  /// companyId	string公司ID
  /// industryId	行业ID
  /// districtId	片区ID
  /// isImportant	是否重点
  /// lawId	法律ID
  /// solvedAt	整改期限
  /// requirement	整改要求
  void _setProblem() async {
    if(checkPersonnel.isEmpty){
      ToastWidget.showToastMsg('请输入排查人员');
    }else if(typeId.isEmpty){
      ToastWidget.showToastMsg('请选择问题类型');
    }else if(problemTitle.isEmpty){
      ToastWidget.showToastMsg('请输入问题概述');
    }else if(issueDetails.isEmpty){
      ToastWidget.showToastMsg('请输入问题详情');
    }else if(imgDetails.isEmpty){
      ToastWidget.showToastMsg('请上传问题图片');
    } else{
      Map _data = {
        'id': problemId.isEmpty ? _uuid : problemId,
        'screeningPerson': checkPersonnel,
        'detail': issueDetails,
        'name': problemTitle,
        'images': imgDetails,
        // 'lawImages': lawImg,
        'status': 0,
        'inventoryId':inventoryId,
        'problemTypeId': typeId,//二级id
        'problemTypeParentId': secondTypeId,//一级id
        'userId':userId,
        'isImportant':isImportant,
        'companyId': companyId,
        'industryList': jsonEncode(industryId),
        'districtId': widget.arguments?['districtId'],
        'requirement': require,
        // 'solvedAt': rectifyTime.toString(),
      };
      if(rectifyTime != null){
        _data['solvedAt'] = rectifyTime.toString();
      }
      var response = await Request().post(
        Api.url['problem'],data: _data,
      );
      if(response['statusCode'] == 200) {
        _notifyProblem(1);
        if(addProblem){
          Navigator.of(context).pushReplacementNamed('/rectificationProblem',
              arguments: {'check':true,'problemId': problemId.isEmpty ? _uuid : problemId,'inventoryStatus': 6,}
          );
        }else{
          Navigator.pop(context,true);
        }
        setState(() {});
      }
    }
  }

  /// 删除问题
  void _deleteProblem({required int type}) async {
    var response = await Request().delete(Api.url['problem']+'/$problemId',);
    if(response['statusCode'] == 200) {
      _notifyProblem(type);
      ToastWidget.showToastMsg('删除成功');
      Navigator.pop(context);
      Navigator.pop(context);
      setState(() {});
    }
  }
  /// 问题状态通知平台
  /// type	同步类型：1-状态更改；2-删除
  void _notifyProblem(int type) {
    Request().post(Api.url['notify'],
      data: {
        "problemId":problemId,
        "type":type
      }
    );
  }
  @override
  void didUpdateWidget(covariant FillInForm oldWidget) {
    // TODO: implement didUpdateWidget
    if(widget.arguments?['problemList'] != null && widget.arguments != oldWidget.arguments){
      _getProblems();
    }
    super.didUpdateWidget(oldWidget);
  }


  @override
  Widget build(BuildContext context) {
    return declare ?
    Scaffold(
      key: _scaffoldKey,
      body: Column(
        children: [
          TaskCompon.topTitle(
              title: '隐患排查问题填报',
              left: true,
              child: (widget.arguments?['audit'] ?? false) ?
              Container() :
              (delete ? InkWell(
                child: Text('删除问题'),
                onTap: (){
                  ToastWidget.showDialog(
                      msg: '是否确定删除当前问题',
                      ok: (){
                        _deleteProblem(type: 2);
                      }
                  );
                },
              ) : Container()),
              callBack: (){
                Navigator.pop(context);
              }
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.only(top: 0),
              children: [
                rubyAgent()
              ],
            ),
          )
        ],
      ),
    ): rubyAgent();
  }

  ///排查问题 详情/填报
  ///declare: true-填报/详情
  Widget rubyAgent(){
    return FormCheck.dataCard(
          children: [
            Row(
              children: [
                Expanded(
                  child: FormCheck.formTitle('问题详情'),
                ),
                declare == false ?
                InkWell(
                  child: Container(
                    height: px(48),
                    padding: EdgeInsets.only(left: px(12),right: px(12)),
                    alignment: Alignment.center,
                    child: Row(
                      children: [
                        Text('流程状态',
                          style: TextStyle(color: Color(0xff6699FF),fontSize: sp(26)),),
                        Image.asset('lib/assets/icons/form/issue.png')
                      ],
                    ),
                  ),
                  onTap: (){
                    Navigator.pushNamed(context, '/problemSchedule',arguments: {"status":problemList['status'],'inventoryId':inventoryId});
                  },
                ) :
                Container(),
              ],
            ),

            FormCheck.rowItem(
                title: "排查时间",
                child: Text(checkDay, style: TextStyle(
                    color: Color(0xff323233),
                    fontSize: sp(28),
                    fontFamily: 'Roboto-Condensed'),),
            ),
            FormCheck.rowItem(
              title: "排查人员",
              child: Text(checkPersonnel, style: TextStyle(color: Color(0xff323233),
                  fontSize: sp(28),
                  fontFamily: 'Roboto-Condensed'),)
            ),
            FormCheck.rowItem(
              title: declare ? "问题类型" : "一级类型",
              child: declare ?
              DownInput(
                value: type,
                data: typeList,
                hitStr: '请选择一级类型',
                callback: (val){
                  type = val['name'];
                  secondTypeId = val['id'];
                  problemType = val['children'] ?? [];
                  if(type == '无'){
                    secondType = '无';
                    typeId = val['children'][0]['id'];
                  }else{
                    secondType = '';
                    typeId = '';
                  }
                  setState(() {});
                },
              ) :
              Text(type, style: TextStyle(
                  color: Color(0xff323233),
                  fontSize: sp(28),
                  fontFamily: 'Roboto-Condensed'),),
            ),
            FormCheck.rowItem(
              title: declare ? '' : "二级类型",
              child: declare ?
                DownInput(
                value: secondType,
                data: problemType,
                hitStr: '请选择二级类型',
                callback: (val){
                  secondType = val['name'];
                  typeId = val['id'];
                  setState(() {});
                 },) :
              Text(secondType, style: TextStyle(
                  color: Color(0xff323233),
                  fontSize: sp(28),
                  fontFamily: 'Roboto-Condensed'),),
            ),
            FormCheck.rowItem(
                alignStart: true,
                title: "问题概述",
                child: !declare ? Text(problemTitle, style: TextStyle(
                    color: Color(0xff323233), fontSize: sp(28)),)
                    : FormCheck.inputWidget(
                    hintText: '请输入问题概述',
                    hintVal: problemTitle,
                    lines: 1,
                    onChanged: (val){
                      problemTitle = val;
                    }
                )),
            Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      SizedBox(
                          width: px(150),
                          child: Text(
                              '问题详情',
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                  color: Color(0XFF969799),
                                  fontSize: sp(28.0),
                                  fontWeight: FontWeight.w500
                              )
                          )
                      ),
                      declare ?
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        child: Container(
                            width: px(150),
                            height: px(50),
                            alignment: Alignment.center,
                            padding: EdgeInsets.only(right: px(24)),
                            child: Image.asset('lib/assets/icons/my/query.png'),
                        ),
                        onTap: (){
                          Navigator.pushNamed(context, '/screeningBased',arguments: {'law':false,'search':true});
                        },
                      ) : Container(),
                    ],
                  ),
                   Expanded(
                     child: Container(
                     padding: EdgeInsets.only(top: px(5),left: px(5)),
                     child: !declare ? Text(issueDetails, style: TextStyle(
                         color: Color(0xff323233), fontSize: sp(28)),)
                         : FormCheck.inputWidget(
                         hintText:  '请输入问题详情',
                         hintVal: issueDetails,
                         lines: 4,
                         onChanged: (val){
                           issueDetails = val;
                         }
                     ),
                   ),)
                ]
            ),

            FormCheck.rowItem(
              alignStart: true,
              title: "问题图片",
              child: UploadImage(
                imgList: imgDetails,
                uuid: _uuid,
                closeIcon: declare,
                url: Api.url['uploadImg'] + '问题/',
                callback: (List? data) {
                  if (data != null) {
                    imgDetails = data;
                  }
                  setState(() {});
                },
              )),

            FormCheck.rowItem(
              title: "整改期限",
              child: !declare ?
              Text(solvedAt, style: TextStyle(
                  color: Color(0xff323233),
                  fontSize: sp(28),
                  fontFamily: 'Roboto-Condensed'),) :
              TimeSelect(
                    scaffoldKey: _scaffoldKey,
                    hintText: "请选择整改期限",
                    time: rectifyTime,
                    // type: 7,
                    callBack: (time) {
                      rectifyTime = time;
                      setState(() {});
                    },
                    cancelBack: (){
                      rectifyTime = null;
                      setState(() {});
                    },
                  ),
            ),

            FormCheck.rowItem(
              title: "填报人员",
              child: Text(userName, style: TextStyle(color: Color(0xff323233),
                  fontSize: sp(28),
                  fontFamily: 'Roboto-Condensed'),),
            ),

            FormCheck.rowItem(
              title: "整改要求",
              child: !declare ?
              Text(require, style: TextStyle(
                  color: Color(0xff323233),
                  fontSize: sp(28),
                  fontFamily: 'Roboto-Condensed'),) :
              DownInput(
                value: require,
                data: requireList,
                hitStr: '请选择整改要求',
                callback: (val){
                  require = val['name'];
                  setState(() {});
                },
              ),
            ),

            FormCheck.rowItem(
              title: "是否重点",
              child: declare ? _radio():
              Text(isImportant ? '是':'否', style: TextStyle(color: Color(0xff323233),
                  fontSize: sp(28),
                  fontFamily: 'Roboto-Condensed'),),
            ),

            Visibility(
              visible: declare,
              child: FormCheck.submit(
                submit: (){
                  _setProblem();
                },
                cancel: (){
                  Navigator.pop(context);
                }
              ),
            )
          ]
      );
  }

  ///单选
  Widget _radio() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          width: px(70),
          child: Radio(
            value: true,
            groupValue: isImportant,
            onChanged: (bool? val) {
              setState(() {
                isImportant = val!;
              });
            },
          ),
        ),
        Text(
          "是",
          style: TextStyle(fontSize: sp(28)),
        ),
        SizedBox(
          width: px(70),
          child: Radio(
            value: false,
            groupValue: isImportant,
            onChanged: (bool? val) {
              setState(() {
                isImportant = val!;
              });
            },
          ),
        ),
        Text(
          "否",
          style: TextStyle(fontSize: sp(28)),
        )
      ],
    );
  }

  ///日期转换
  String formatTime(time) {
    return utcToLocal(time.toString()).substring(0,16);
  }
}
