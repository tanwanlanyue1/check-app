import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:scet_check/api/api.dart';
import 'package:scet_check/api/request.dart';
import 'package:scet_check/components/generalduty/time_select.dart';
import 'package:scet_check/components/generalduty/toast_widget.dart';
import 'package:scet_check/components/generalduty/upload_image.dart';
import 'package:scet_check/page/module_steward/check/hiddenParame/components/rectify_components.dart';
import 'package:scet_check/page/module_steward/check/statisticAnaly/components/form_check.dart';
import 'package:scet_check/utils/screen/screen.dart';
import 'package:scet_check/utils/storage/data_storage_key.dart';
import 'package:scet_check/utils/storage/storage.dart';
import 'package:scet_check/utils/time/utc_tolocal.dart';
import 'package:uuid/uuid.dart';

///填报整改问题
///arguments:{'id':问题id,'review':是否复查}
class FillAbarabeitung extends StatefulWidget {
  final Map? arguments;
  const FillAbarabeitung({Key? key,this.arguments,}) : super(key: key);

  @override
  _FillAbarabeitungState createState() => _FillAbarabeitungState();
}

class _FillAbarabeitungState extends State<FillAbarabeitung> {

  List imgDetails = [];//图片列表
  String _uuid = '';//uuid
  Uuid uuid = Uuid();//uuid
  String descript = '';//整改措施
  String reviewPerson = '';//复查人员
  String userId = '';//用户id
  String remark = '';//其他说明
  String userName = '';//用户名
  bool review = false;//复查填报
  bool isImportant = false; //是否完成整改
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final DateTime _dateTime = DateTime.now();

  /// 问题填报 填报post，
  /// id:整改id
  /// descript:整改措施
  /// images:图片
  /// remark	其他说明
  /// status:状态:1,待复查;2,复查已通过;3,复查未通过
  /// userId:用户ID
  /// problemId:问题id
  void _setProblem() async {
    if(descript.isEmpty){
      ToastWidget.showToastMsg('请输入整改措施');
    }else if(imgDetails.isEmpty){
      ToastWidget.showToastMsg('请上传问题图片');
    }else if(remark.isEmpty){
      ToastWidget.showToastMsg('请输入其他说明');
    }else{
      Map _data = {
        'id': _uuid,
        'descript': descript,
        'status': 1,
        'images': imgDetails,
        'userId': userId,
        'problemId': widget.arguments!['id'],
        'remark': remark,
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

  /// 复查问题填报 填报post，
  /// id:复查id
  /// descript: 复查详情
  /// reviewPerson:复查人员
  /// images:图片
  /// remark	其他说明
  /// userId:用户ID
  /// problemId:问题id
  void _postReview() async {
    if(descript.isEmpty){
      ToastWidget.showToastMsg('请输入复查详情');
    }else if(imgDetails.isEmpty){
      ToastWidget.showToastMsg('请上传复查图片');
    }else if(remark.isEmpty){
      ToastWidget.showToastMsg('请输入其他说明');
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
      print('data===$_data');
      var response = await Request().post(
        Api.url['review'],data: _data,
      );
      // if(response['statusCode'] == 200) {
      //   Navigator.pop(context,true);
      //   setState(() {});
      // }
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    _uuid = uuid.v4();
    userName= jsonDecode(StorageUtil().getString(StorageKey.PersonalData))['nickname'];
    userId= jsonDecode(StorageUtil().getString(StorageKey.PersonalData))['id'];
    review = widget.arguments?['review'] ?? false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Column(
        children: [
          RectifyComponents.topBar(
              title: review ? '隐患复查问题填报' : '隐患整改问题填报',
              callBack: (){
                Navigator.pop(context);
              }
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.only(top: 0),
              children: [
                Visibility(
                  visible: review,
                  child: reviewFill(),
                  replacement: fillAgent(),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  ///排查问题 填报
  ///declare: true-填报/详情
  Widget fillAgent(){
    return FormCheck.dataCard(
        children: [
          FormCheck.formTitle('问题详情'),
          FormCheck.rowItem(
            title: "整改措施",
            child: FormCheck.inputWidget(
                hintText: '整改措施',
                onChanged: (val){
                  descript = val;
                  setState(() {});
                }
            ),
          ),
          FormCheck.rowItem(
            alignStart: true,
            title: "问题照片",
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
            title: "其他说明",
            child: FormCheck.inputWidget(
                hintText: '其他说明',
                onChanged: (val){
                  remark = val;
                  setState(() {});
                }
            ),
          ),
          FormCheck.rowItem(
            title: "填报人员",
            child: Text(userName, style: TextStyle(color: Color(0xff323233),
                fontSize: sp(28),
                fontFamily: 'Roboto-Condensed'),),
          ),
          FormCheck.submit(
              submit: (){
                _setProblem();
              },
              cancel: (){
                Navigator.pop(context);
              }
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
                  hintText: '复查人员',
                  onChanged: (val){
                    reviewPerson = val;
                    setState(() {});
                  }
              ),
            ),
            FormCheck.rowItem(
              title: "复查时间",
              child: Text(formatTime(_dateTime), style: TextStyle(color: Color(0xff323233),
                  fontSize: sp(28),
                  fontFamily: 'Roboto-Condensed'),),
            ),
            FormCheck.rowItem(
              title: "复查详情",
              child: FormCheck.inputWidget(
                  hintText: '复查详情',
                  onChanged: (val){
                    descript = val;
                    setState(() {});
                  }
              ),
            ),
            FormCheck.rowItem(
              alignStart: true,
              title: "复查图片记录",
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
            FormCheck.rowItem(
              title: "其他说明",
              child: FormCheck.inputWidget(
                  hintText: '其他说明',
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
    return utcToLocal(time.toString()).substring(0,10);
  }
}
