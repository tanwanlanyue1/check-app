import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:scet_check/api/api.dart';
import 'package:scet_check/api/request.dart';
import 'package:scet_check/components/generalduty/toast_widget.dart';
import 'package:scet_check/components/generalduty/upload_image.dart';
import 'package:scet_check/page/module_steward/check/statisticAnaly/components/form_check.dart';
import 'package:scet_check/page/module_steward/personal/components/task_compon.dart';
import 'package:scet_check/utils/screen/screen.dart';
import 'package:scet_check/utils/storage/data_storage_key.dart';
import 'package:scet_check/utils/storage/storage.dart';
import 'package:scet_check/utils/time/utc_tolocal.dart';
import 'package:uuid/uuid.dart';

import 'abarbeitung_pdf.dart';

///填报整改问题
///arguments:{'id':问题id,'review':是否复查}
class FillAbarbeitung extends StatefulWidget {
  final Map? arguments;
  const FillAbarbeitung({Key? key,this.arguments,}) : super(key: key);

  @override
  _FillAbarbeitungState createState() => _FillAbarbeitungState();
}

class _FillAbarbeitungState extends State<FillAbarbeitung> {

  List imgDetails = [];//图片列表
  List reportsList = [];//上传报告列表
  String _uuid = '';//uuid
  Uuid uuid = Uuid();//uuid
  String descript = '';//整改措施
  String reviewPerson = '';//复查人员
  String userId = '';//用户idt
  String remark = '';//其他说明
  String userName = '';//用户名
  String pdfString = '';//上传附件
  String pdfName = '';//上传附件名称
  bool review = false;//复查填报
  bool isImportant = false; //是否完成整改
  List solutionList = [];//整改详情
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final DateTime _dateTime = DateTime.now();

  /// 整改填报 填报post，
  /// id:整改id
  /// descript:整改措施
  /// images:图片
  /// remark	其他说明
  /// status:状态:提交 1  保存4
  /// userId:用户ID
  /// problemId:问题id
  void _setProblem({int status = 4}) async {
    if(descript.isEmpty){
      ToastWidget.showToastMsg('请输入整改措施');
    }else if(imgDetails.isEmpty){
      ToastWidget.showToastMsg('请上传问题图片');
    }else{
      Map _data = {
        'id': _uuid,
        'descript': descript,
        'status': status,//提交1? 保存4
        'images': imgDetails,
        'userId': userId,
        'problemId': widget.arguments!['id'],
        'reports':reportsList,
      };
      var response = await Request().post(
        Api.url['solution'],data: _data,
      );
      if(response['statusCode'] == 200) {
        Navigator.pop(context,true);
        setState(() {});
      }
    }
  }

  /// 整改详情，
  /// 获取最新的整改详情
  /// 判断是复查未通过，还是修改保存的数据
  /// status 1,待复查;2,复查已通过;3,复查未通过 4保存
  void _setSolution() async {
    Map<String,dynamic> _data = {
      'problemId':widget.arguments!['id'],
    };
    var response = await Request().get(
        Api.url['solutionList'],data: _data
    );
    if(response['statusCode'] == 200 && response['data'] != null) {
      solutionList = response['data']['list'];
      //修改整改详情时，拿到第一项
      if(solutionList.isNotEmpty && solutionList[0]['status'] == 4){
        descript = solutionList[0]['descript'];
        if( review == false){
          imgDetails = solutionList[0]['images'];
        }else{
          imgDetails = [];
        }
        _uuid = solutionList[0]['id'];
        reportsList = solutionList[0]['reports'] ?? [];
        if(reportsList.isNotEmpty){
          pdfString = reportsList[0]['url'];
          pdfName = reportsList[0]['name'];
        }
      }
      setState(() {});
    }
  }

  /// 复查问题填报 填报post，
  /// id:复查id
  /// descript: 复查详情
  /// reviewPerson:复查人员
  /// images:图片
  /// remark	其他说明
  /// userId:用户ID
  /// problemId:问题id
  void _postReview() async {
    if(reviewPerson.isEmpty){
      ToastWidget.showToastMsg('请输入复查人员');
    }else if(descript.isEmpty){
      ToastWidget.showToastMsg('请输入复查详情');
    }else if(imgDetails.isEmpty){
      ToastWidget.showToastMsg('请上传复查图片');
    }else{
      Map _data = {
        'id': _uuid,
        'detail': descript,
        'images': imgDetails,
        'remark': remark,
        'reviewPerson': reviewPerson,
        'isSolved': isImportant,
        'userId': userId,
        'problemId': widget.arguments!['id'],
      };
      var response = await Request().post(
        Api.url['review'],data: _data,
      );
      if(response['statusCode'] == 200) {
        Navigator.pop(context,true);
        setState(() {});
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    _uuid = uuid.v4();
    userName= jsonDecode(StorageUtil().getString(StorageKey.PersonalData))['nickname'];
    userId= jsonDecode(StorageUtil().getString(StorageKey.PersonalData))['id'];
    review = widget.arguments?['review'] ?? false;
    if(!review){
      _setSolution();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Column(
        children: [
          TaskCompon.topTitle(
              title: review ? '隐患复查问题填报' : '隐患整改问题填报',
              left: true,
              callBack: (){
                Navigator.pop(context);
              }
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.only(top: 0),
              children: [
                review ? reviewFill():
                fillAgent()
              ],
            ),
          )
        ],
      ),
    );
  }

  ///整改问题 填报
  ///declare: true-填报/详情
  Widget fillAgent(){
    return FormCheck.dataCard(
        children: [
          FormCheck.formTitle('整改详情'),
          FormCheck.rowItem(
            title: "整改措施",
            child: FormCheck.inputWidget(
                hintText: descript.isEmpty ? '请输入整改措施' : descript,
                onChanged: (val){
                  descript = val;
                  setState(() {});
                }
            ),
          ),
          FormCheck.rowItem(
            alignStart: true,
            title: "整改照片",
            child: UploadImage(
              imgList: imgDetails,
              uuid: _uuid,
              closeIcon: true,
              url: Api.baseUrlApp + 'file/upload?savePath=整改/',
              callback: (List? data) {
                if (data != null) {
                  imgDetails = data;
                }
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
          pdfString.isNotEmpty ?
          GestureDetector(
            child: FormCheck.rowItem(
              title: "附件",
              child: Text(pdfName, style: TextStyle(color: Color(0xff323233),
                  fontSize: sp(28),
                  fontFamily: 'Roboto-Condensed'),),
            ),
            onTap: (){
              Navigator.pushNamed(context, '/PDFView',arguments: Api.baseUrlApp+pdfString);
            },
          ):
          Container(),
          Container(
            height: px(88),
            margin: EdgeInsets.only(top: px(4)),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  child: Container(
                    width: px(200),
                    height: px(56),
                    alignment: Alignment.center,
                    child: Text(
                      '提交整改问题',
                      style: TextStyle(
                          fontSize: sp(24),
                          fontFamily: "R",
                          color: Colors.white),
                    ),
                    decoration: BoxDecoration(
                      color: Color(0xff4D7FFF),
                      border: Border.all(width: px(2),color: Color(0XffE8E8E8)),
                      borderRadius: BorderRadius.all(Radius.circular(px(28))),
                    ),
                  ),
                  onTap: (){
                    _setProblem(
                        status: 1
                    );
                  },
                ),
                GestureDetector(
                  child: Container(
                    width: px(200),
                    height: px(56),
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(left: px(20)),
                    child: Text(
                      '保存整改',
                      style: TextStyle(
                          fontSize: sp(24),
                          fontFamily: "R",
                          color: Color(0xFF323233)),
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(width: px(2),color: Color(0XffE8E8E8)),
                      borderRadius: BorderRadius.all(Radius.circular(px(28))),
                    ),
                  ),
                  onTap: (){
                    _setProblem(
                      status: 4
                    );
                  },
                ),
                AbarbeitungPdf(
                  url: Api.baseUrlApp + 'file/upload?savePath=整改/',
                  inventoryId: _uuid,
                  uploading: true,
                  title: '上传整改报告',
                  callback: (val){
                    reportsList = [{'name':val['name'],'url':val['filePath']}];
                    pdfName = val['name'];
                    pdfString = val['filePath'];
                    setState(() {});
                  },
                ),
              ],
            ),
          )
        ]
    );
  }

  ///复查问题 填报
  ///declare: true-填报/详情
  Widget reviewFill(){
    return Container(
      margin: EdgeInsets.only(left: px(24),right: px(24),top: px(12)),
      child: FormCheck.dataCard(
          children: [
            FormCheck.formTitle('现场复查情况'),
            FormCheck.rowItem(
              title: "复查人员",
              child: FormCheck.inputWidget(
                  hintText: '请输入复查人员',
                  onChanged: (val){
                    reviewPerson = val;
                    setState(() {});
                  }
              ),
            ),
            FormCheck.rowItem(
              title: "复查时间",
              child: Container(
                margin: EdgeInsets.only(left: px(12)),
                child: Text(formatTime(_dateTime), style: TextStyle(color: Color(0xff323233),
                    fontSize: sp(28),
                    fontFamily: 'Roboto-Condensed'),),
              ),
            ),
            FormCheck.rowItem(
              title: "复查详情",
              child: FormCheck.inputWidget(
                  hintText: '请输入复查详情',
                  onChanged: (val){
                    descript = val;
                    setState(() {});
                  }
              ),
            ),
            FormCheck.rowItem(
              alignStart: true,
              title: "复查图片记录",
              child: Container(
                margin: EdgeInsets.only(left: px(12)),
                child: UploadImage(
                  imgList: imgDetails,
                  uuid: _uuid,
                  closeIcon: true,
                  url: Api.baseUrlApp + 'file/upload?savePath=复查/',
                  callback: (List? data) {
                    if (data != null) {
                      imgDetails = data;
                    }
                    setState(() {});
                  },
                ),
              ),
            ),
            FormCheck.rowItem(
              title: "其他说明",
              child: FormCheck.inputWidget(
                  hintText: '请输入其他说明',
                  onChanged: (val){
                    remark = val;
                    setState(() {});
                  }
              ),
            ),
            FormCheck.rowItem(
              title: "是否完成整改",
              child: _radio(),
            ),
            FormCheck.submit(
                submit: (){
                  _postReview();
                },
                cancel: (){
                  Navigator.pop(context);
                }
            )
          ]
      ),
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
