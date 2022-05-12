import 'package:flutter/material.dart';
import 'package:scet_check/page/module_steward/personal/components/task_compon.dart';
import 'package:scet_check/utils/screen/screen.dart';


///通知详情
class MessageDetailsPage extends StatefulWidget {
  const MessageDetailsPage({Key? key}) : super(key: key);

  @override
  _MessageDetailsPageState createState() => _MessageDetailsPageState();
}

class _MessageDetailsPageState extends State<MessageDetailsPage> {
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
        ],
      ),
    );
  }

}
