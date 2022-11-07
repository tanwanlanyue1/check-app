import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:scet_check/api/api.dart';
import 'package:scet_check/api/request.dart';
import 'package:scet_check/components/generalduty/toast_widget.dart';
import 'package:scet_check/components/generalduty/upload_file.dart';
import 'package:scet_check/components/generalduty/upload_image.dart';
import 'package:scet_check/page/module_steward/check/statisticAnaly/components/form_check.dart';
import 'package:scet_check/page/module_steward/personal/components/task_compon.dart';
import 'package:scet_check/utils/screen/screen.dart';


///通知详情
///arguments:{(notification)通知的详情}
class MessageDetailsPage extends StatefulWidget {
  final Map? arguments;
  const MessageDetailsPage({this.arguments, Key? key}) : super(key: key);

  @override
  _MessageDetailsPageState createState() => _MessageDetailsPageState();
}

class _MessageDetailsPageState extends State<MessageDetailsPage> {
  Map messageDetail = {};//通告详情
  String feedback = ''; //消息反馈
  bool execute = false; //是否是执行人
  List messageFiles = []; //附件文件

  @override
  void initState() {
    // TODO: implement initState
    messageDetail = widget.arguments?['data'] ?? {};
    execute = widget.arguments?['company'];
    super.initState();
  }

  /// 回复通知公告
  /// noticeId：通知公告id
  /// feedback:回复内容
  /// fileList：附件
  void _feedbackNoticePage() async {
    if (feedback.isEmpty) {
      ToastWidget.showToastMsg('请输入反馈内容！');
    }else{
      var response = await Request().post(Api.url['feedbackNotice'],
          data: {
            "noticeId":messageDetail['id'],
            "feedback": feedback,
            "fileList": messageFiles
          }
      );
      if(response['success'] == true) {
        Navigator.pop(context,true);
        setState(() {});
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TaskCompon.topTitle(
              title: '${messageDetail['title']}',
              left: true,
              callBack: (){
                Navigator.pop(context);
              }
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.only(top: 0),
              children: [
                detail(),
                Visibility(
                  visible: execute && messageDetail['noticeRead']['feedbackStatus'] == false,
                  child: subFeedback(),
                ),
                Visibility(
                  visible: execute && messageDetail['noticeRead']['feedbackStatus'] == false,
                  child: submit(),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  ///公告详情
  Widget detail(){
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
            child: FormCheck.formTitle('查看通知'),
          ),
          FormCheck.rowItem(
            title: '通知标题:',
            child: Text('${messageDetail['title']}',style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),),
          ),
          FormCheck.rowItem(
            title: '通告类型:',
            child: Text('${messageDetail['noticeTypeStr'] ?? '/'}',style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),),
          ),
//          FormCheck.rowItem(
//            title: '通知对象:',
//            child: Text('${messageDetail['objName']}',style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),),
//          ),
          FormCheck.rowItem(
            title: '通知内容:',
            child: Text('${messageDetail['content'] ?? '/'}',style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),),
          ),
          FormCheck.rowItem(
            title: '通知文档:',
            alignStart: true,
            child: UploadFile(
              url: '/',
              abutment: true,
              amend: false,
              fileList: messageDetail['fileList'] ?? [],
            ),
          ),
          FormCheck.rowItem(
            alignStart: true,
            title: "通知图片:",
            child: UploadImage(
              imgList: messageDetail['imgList'] ?? [],
              abutment: true,
              closeIcon: false,
            ),
          ),//execute
          Visibility(
            visible: !execute,
            child: FormCheck.rowItem(
              title: '反馈列表:',
              child: InkWell(
                child: Text('查看反馈信息',style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),),
                onTap: (){
                  Navigator.pushNamed(context, '/messageFeedback',arguments: messageDetail);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  ///企业提交反馈
  Widget subFeedback(){
    return Container(
      margin: EdgeInsets.only(left: px(24),right: px(24),top: px(24)),
      padding: EdgeInsets.only(left: px(24),right: px(24),bottom: px(24)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(px(8.0))),
      ),
      child: Column(
        children: [
          FormCheck.rowItem(
            title: '消息反馈:',
            child: FormCheck.inputWidget(
                hintText: '请输入消息反馈',
                hintVal: feedback,
                lines: 1,
                onChanged: (val){
                  feedback = val;
                }
            ),
          ),
          FormCheck.rowItem(
            title: '反馈附件:',
            alignStart: true,
            child: UploadFile(
              url: '/',
              amend: true,
              abutment: true,
              fileList: messageFiles,
              callback: (val){
                messageFiles = val;
                setState(() {});
              },
            ),
          ),
        ],
      ),
    );
  }



  ///提交按钮
  Widget submit(){
    return InkWell(
      child: Container(
        height: px(60),
        margin: EdgeInsets.all(24.px),
        alignment: Alignment.center,
        child: Text('提交反馈', style: TextStyle(
            fontSize: sp(32),
            fontFamily: "R",
            color: Colors.white),),
        decoration: BoxDecoration(
          color: Color(0xff4D7FFF),
          border: Border.all(width: px(2),color: Color(0XffE8E8E8)),
          borderRadius: BorderRadius.all(Radius.circular(px(12))),),
      ),
      onTap: () async {
        _feedbackNoticePage();
      },
    );
  }
}
