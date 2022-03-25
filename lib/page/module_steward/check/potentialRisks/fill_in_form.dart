import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:scet_check/api/api.dart';
import 'package:scet_check/api/request.dart';
import 'package:scet_check/components/generalduty/down_input.dart';
import 'package:scet_check/components/generalduty/toast_widget.dart';
import 'package:scet_check/main.dart';
import 'package:scet_check/page/module_steward/check/hiddenParame/components/rectify_components.dart';
import 'package:scet_check/page/module_steward/check/statisticAnaly/components/form_check.dart';
import 'package:scet_check/components/generalduty/time_select.dart';
import 'package:scet_check/components/generalduty/upload_image.dart';
import 'package:scet_check/utils/screen/screen.dart';
import 'package:scet_check/utils/storage/data_storage_key.dart';
import 'package:scet_check/utils/storage/storage.dart';
import 'package:scet_check/utils/time/utc_tolocal.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

///排查问题填报
///        arguments = {
///           'declare':true,//申报
///           'uuid': uuid,//清单ID
///           'problemId':problemId,//问题id
///           'district': repertoire['company']['districtId'],//片区id
///           'companyId': repertoire['company']['id'],//企业id
///           'industryId': repertoire['company']['industryId'],//行业ID
///           'problemList':problemList,//问题详情
///         };
///callBack:回调
class FillInForm extends StatefulWidget {
  final Map? arguments;
  final Function? callBack;
  const FillInForm({Key? key,this.arguments,this.callBack}) : super(key: key);

  @override
  _FillInFormState createState() => _FillInFormState();
}

class _FillInFormState extends State<FillInForm> with RouteAware {
  List imgDetails = [];//问题图片列表
  List lawImg = [];//法律法规截图
  List typeList = [];//问题类型列表
  List lawList = [];//法律法规列表
  Map problemList = {};//问题详情列表
  bool declare = false; //申报
  bool isImportant = false; //是否重点
  bool checkGist = true; //排查依据
  String checkPersonnel = '';//排查人员
  String issueDetails = '';//问题详情
  String type = '';//问题类型
  String typeId = '';//问题ID
  String law = '';//法规依据
  String lawId = '';//法规依据ID
  String districtId = '';//排查标准ID
  String inventoryId = '';//清单ID
  String companyId = '';//企业ID
  String industryId = '';//产业ID
  String areaId = '';//区域ID
  String problemId = '';//问题id
  String _uuid = '';//uuid
  Uuid uuid = Uuid();//uuid
  String userName = '';//用户名
  String userId = '';//用户id
  String checkDay = '';//详情排查日期
  String solvedAt = '';//整改期限
  String otherType = '';//其他类型
  bool other = false;//其他类型
  late GlobalKey<ScaffoldState> _scaffoldKey; //时间选择key
  DateTime checkTime = DateTime.now();//填报排查日期
  DateTime rectifyTime = DateTime.now().add(Duration(days: 7));//整改期限


  /// 获取法律文件
  void _getProfile() async {
    var response = await Request().get(Api.url['lawFile']);
    if(response['statusCode'] == 200) {
      lawList = response['data'];
      setState(() {});
    }
  }

  /// 获取问题类型
  void _getProblemType() async {
    var response = await Request().get(Api.url['problemType']);
    if(response['statusCode'] == 200) {
      typeList = response['data'];
      setState(() {});
    }
  }

  /// 获取问题详情
  /// id:问题id
  void _getProblems() async {
    problemList = widget.arguments?['problemList'];
    if(problemList.isNotEmpty){
      checkPersonnel = problemList['screeningPerson'] ?? '';
      checkDay = formatTime(problemList['createdAt']);
      type = problemList['problemType']['name'];
      issueDetails = problemList['detail'] ?? '';
      imgDetails = problemList['images'];
      lawImg = problemList['lawImages'] ?? [];
      if(problemList['law'] == null){
        law = problemList['basis']?['name'] ?? '';
      }else{
        law = problemList['law']['title'] ?? '';
      }
      problemId = problemList['id'];
      inventoryId = problemList['inventoryId'];
      typeId = problemList['problemTypeId'];
      companyId = problemList['companyId'];
      industryId = problemList['industryId'];
      areaId = problemList['districtId'];
      lawId = problemList['lawId'];
      districtId = problemList['basisId'];
      isImportant = problemList['isImportant'];
      solvedAt = problemList['solvedAt'] != null ? formatTime(problemList['solvedAt']) : '';
    }
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    _uuid = uuid.v4();
    declare = widget.arguments?['declare'] ?? true;
    _scaffoldKey = widget.arguments?['key'] ?? GlobalKey<ScaffoldState>();
    userName= jsonDecode(StorageUtil().getString(StorageKey.PersonalData))['nickname'];
    userId= jsonDecode(StorageUtil().getString(StorageKey.PersonalData))['id'];

    if(declare){
      _getProblemType();
      _getProfile();
      _getProblems();
      inventoryId = widget.arguments?['uuid'];
      companyId = widget.arguments?['companyId'];
      industryId = widget.arguments?['industryId'];
      areaId = widget.arguments?['districtId'];
    }else{
      _getProblems();
    }
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void didPopNext() {
    // TODO: implement didPopNext
    if(StorageUtil().getJSON('law')!=null){
      lawId = StorageUtil().getJSON('law')['id'];
      law = StorageUtil().getJSON('law')['title'];
      StorageUtil().setJSON('gist', null);
      StorageUtil().setJSON('law', null);
      districtId = '';
      setState(() {});
    }
    if(StorageUtil().getJSON('gist') !=null ){
      law = StorageUtil().getJSON('gist')['name'];
      districtId = StorageUtil().getJSON('gist')['id'];
      StorageUtil().setJSON('gist', null);
      StorageUtil().setJSON('law', null);
      lawId = '';
      setState(() {});
    }
    super.didPopNext();
  }

  /// 问题填报 填报post，
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
  void _setProblem() async {
    if(checkPersonnel.isEmpty){
      ToastWidget.showToastMsg('请输入排查人员');
    }else if(type.isEmpty){
      ToastWidget.showToastMsg('请选择问题类型');
    }else if(issueDetails.isEmpty){
      ToastWidget.showToastMsg('请输入问题详情');
    }else if(imgDetails.isEmpty){
      ToastWidget.showToastMsg('请上传问题图片');
    }else if(lawId.isEmpty && districtId.isEmpty){
      ToastWidget.showToastMsg('请选择排查依据');
    }else{
      Map _data = {
        'id': problemId.isEmpty ? _uuid : problemId,
        'screeningPerson': checkPersonnel,
        'detail': issueDetails,
        'images': imgDetails,
        'lawImages': lawImg,
        'status': 1,
        'inventoryId':inventoryId,
        'problemTypeId': typeId,
        'userId':userId,
        'isImportant':isImportant,
        'companyId': companyId,
        'industryId': widget.arguments?['industryId'],
        'districtId': widget.arguments?['districtId'],
        'lawId': lawId,
        'basisId': districtId,
        'solvedAt': rectifyTime.toString(),
      };
      var response = await Request().post(
        Api.url['problem'],data: _data,
      );
      if(response['statusCode'] == 200) {
        Navigator.pop(context,true);
        setState(() {});
      }
    }
  }

  /// 提交问题类型
  void _postProblemType() async {
    Request().post(Api.url['problemType'],data: {'id':_uuid,'name':otherType});
  }

  @override
  void didUpdateWidget(covariant FillInForm oldWidget) {
    // TODO: implement didUpdateWidget
    if(widget.arguments?['problemList'] != null){
      _getProblems();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    /// 取消路由订阅
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return declare ?
    Scaffold(
      key: _scaffoldKey,
      appBar: RectifyComponents.appBarTop(),
      body: Column(
        children: [
          RectifyComponents.topBar(
              title: '隐患排查问题填报',
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
    ):
      rubyAgent();
  }

  ///排查问题 详情/填报
  ///declare: true-填报/详情
  Widget rubyAgent(){
    return FormCheck.dataCard(
          children: [
            FormCheck.formTitle('问题详情'),
            FormCheck.rowItem(
                title: "排查时间",
                child: !declare ?
                Text(checkDay, style: TextStyle(
                    color: Color(0xff323233),
                    fontSize: sp(28),
                    fontFamily: 'Roboto-Condensed'),) :
                TimeSelect(
                  scaffoldKey: _scaffoldKey,
                  hintText: "请选择排查时间",
                  time: checkTime,
                  callBack: (time) {
                    checkTime = time;
                    setState(() {});
                  },
                )
            ),
            FormCheck.rowItem(
              title: "排查人员",
              child: !declare ?
              Text(checkPersonnel, style: TextStyle(color: Color(0xff323233),
                  fontSize: sp(28),
                  fontFamily: 'Roboto-Condensed'),) :
              Container(
                color: Color(0xffF5F6FA),
                child: FormCheck.inputWidget(
                    hintText: checkPersonnel.isEmpty ? '请输入排查人员' : checkPersonnel,
                    onChanged: (val){
                      checkPersonnel = val;
                      setState(() {});
                    }
                ),
              ),
            ),
            FormCheck.rowItem(
              title: "问题类型",
              child: declare ?
              DownInput(
                value: type,
                data: typeList,
                callback: (val){
                  type = val['name'];
                  typeId = val['id'];
                  if(type == '其它'){
                    other = true;
                  }else{
                    other = false;
                  }
                  setState(() {});
                },
              ) :
              Text(type, style: TextStyle(
                  color: Color(0xff323233),
                  fontSize: sp(28),
                  fontFamily: 'Roboto-Condensed'),),
            ),
            other ?
            FormCheck.rowItem(
              title: "其他类型",
              child: Container(
                color: Color(0xffF5F6FA),
                child: FormCheck.inputWidget(
                    hintText: '其他类型',
                    onChanged: (val){
                      otherType = val;
                      setState(() {});
                    }
                ),
              ),
            ) :
            Container(),

            FormCheck.rowItem(
              title: "问题详情",
              alignStart: true,
              child: Container(
                color: !declare? Colors.white : Color(0xffF5F6FA),
                padding: EdgeInsets.only(top: px(5),left: px(5)),
                child: !declare ? Text(issueDetails, style: TextStyle(
                    color: Color(0xff323233), fontSize: sp(28)),)
                    : FormCheck.inputWidget(
                    hintText: issueDetails.isEmpty ? '请输入问题详情':issueDetails,
                    lines: 4,
                    onChanged: (val){
                      issueDetails = val;
                      setState(() {});
                    }
                ),
              ),
            ),

            FormCheck.rowItem(
              alignStart: true,
              title: "问题图片",
              child: UploadImage(
                imgList: imgDetails,
                uuid: _uuid,
                closeIcon: declare,
                url: Api.baseUrlApp + 'file/upload?savePath=问题/',
                callback: (List? data) {
                  if (data != null) {
                    imgDetails = data;
                  }
                  setState(() {});
                },
              )),

            FormCheck.rowItem(
              title: "排查依据",
              child: declare ?
              _radios():
              Text(law, style: TextStyle(color: Color(0xff323233),
                  fontSize: sp(28),
                  fontFamily: 'Roboto-Condensed'),),
            ),

            declare ?
            FormCheck.rowItem(
              title: '',
              child: InkWell(
                child: Container(
                  color: Color(0xffF5F6FA),
                  height: px(87),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    law.isEmpty ? (checkGist ? '请选择法律法规' : '请选择排查标准'): law,
                    style: TextStyle(color: Color(0xff323233),
                      fontSize: sp(28),
                      fontFamily: 'Roboto-Condensed'),),
                ),
                onTap: () async{
                  Navigator.pushNamed(context, '/screeningBased',arguments: {'law':checkGist});
                },
              ),
            ) :
            Container(),

            checkGist ?
            FormCheck.rowItem(
                alignStart: true,
                title: "法律法规截图",
                child: (declare == false && lawImg.isEmpty) ?
                Text('无',style: TextStyle(color: Color(0xff323233), fontSize: sp(28),),):
                UploadImage(
                  imgList: lawImg,
                  uuid: _uuid,
                  closeIcon: declare,
                  url: Api.baseUrlApp + 'file/upload?savePath=问题/',
                  callback: (List? data) {
                    if (data != null) {
                      lawImg = data;
                    }
                    setState(() {});
                  },
                ),
            )
                : Container(),

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
                    type: 7,
                    callBack: (time) {
                      rectifyTime = DateTime.parse(formatTimes(time));
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
                  if(other && otherType.isNotEmpty){
                    _postProblemType();
                  }
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

  ///选择排查依据
  Widget _radios() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          width: px(70),
          child: Radio(
            value: true,
            groupValue: checkGist,
            onChanged: (bool? val) {
              setState(() {
                checkGist = val!;
                law = '';
                lawId = '';
                districtId = '';
              });
            },
          ),
        ),
        InkWell(
          child: Text(
            "法律法规",
            style: TextStyle(fontSize: sp(28)),
          ),
          onTap: (){
            checkGist = !checkGist;
            law = '';
            lawId = '';
            districtId = '';
            setState(() {});
          },
        ),
        SizedBox(
          width: px(70),
          child: Radio(
            value: false,
            groupValue: checkGist,
            onChanged: (bool? val) {
              setState(() {
                checkGist = val!;
                law = '';
                lawId = '';
                districtId = '';
              });
            },
          ),
        ),
        InkWell(
          child: Text(
            "排查标准",
            style: TextStyle(fontSize: sp(28)),
          ),
          onTap: (){
            checkGist = !checkGist;
            law = '';
            lawId = '';
            districtId = '';
            setState(() {});
          },
        )
      ],
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
    return utcToLocal(time.toString()).substring(0,10);
  }
  String formatTimes(DateTime time) {
    return DateFormat("yyyy-MM-dd").format(time);
  }
}
