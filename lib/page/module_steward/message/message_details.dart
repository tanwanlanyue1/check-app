import 'package:flutter/material.dart';
import 'package:scet_check/components/generalduty/upload_file.dart';
import 'package:scet_check/components/generalduty/upload_image.dart';
import 'package:scet_check/page/module_steward/check/statisticAnaly/components/form_check.dart';
import 'package:scet_check/page/module_steward/personal/components/task_compon.dart';
import 'package:scet_check/utils/screen/screen.dart';


///通知详情
///arguments:{通知的详情}
class MessageDetailsPage extends StatefulWidget {
  final Map? arguments;
  const MessageDetailsPage({this.arguments, Key? key}) : super(key: key);

  @override
  _MessageDetailsPageState createState() => _MessageDetailsPageState();
}

class _MessageDetailsPageState extends State<MessageDetailsPage> {
  Map messageDetail = {};//通告详情

  @override
  void initState() {
    // TODO: implement initState
    messageDetail = widget.arguments ?? {};
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TaskCompon.topTitle(
              title: '关于推送任务的通知',
              left: true,
              callBack: (){
                Navigator.pop(context);
              }
          ),
          Expanded(
            child: detail(),
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
          FormCheck.rowItem(
            title: '通知对象:',
            child: Text('${messageDetail['objName']}',style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),),
          ),
          FormCheck.rowItem(
            title: '通知内容:',
            child: Text('${messageDetail['content'] ?? '/'}',style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),),
          ),
          FormCheck.rowItem(
            title: '上传文档:',
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
            title: "上传图片:",
            child: UploadImage(
              imgList: messageDetail['imgList'] ?? [],
              abutment: true,
              closeIcon: false,
            ),
          ),
        ],
      ),
    );
  }
}
