import 'package:flutter/material.dart';
import 'package:scet_check/components/generalduty/toast_widget.dart';
import 'package:scet_check/page/module_login/login_page.dart';
import 'package:scet_check/page/module_steward/personal/components/task_compon.dart';
import 'package:scet_check/routers/router_animate/router_animate.dart';
import 'package:scet_check/utils/screen/screen.dart';
import 'package:scet_check/utils/storage/data_storage_key.dart';
import 'package:scet_check/utils/storage/storage.dart';

///通知中心
///arguments: const {'company':true},企业端
class MessagePage extends StatefulWidget {
  final Map? arguments;
  const MessagePage({Key? key,this.arguments}) : super(key: key);

  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {

  bool company = false;

  @override
  void initState() {
    // TODO: implement initState
    company = widget.arguments?['company'];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TaskCompon.topTitle(
              title: '通知中心',
              home: !company,
              colors: company ? Colors.white : Colors.transparent,
              callBack: (){
                  Navigator.pop(context);
              }
          ),
          Visibility(
            visible: (widget.arguments?['company'] ?? false),
            child: InkWell(
              child: Icon(Icons.people_alt_outlined,size: px(100),),
              onTap: (){
                ToastWidget.showDialog(
                    msg: '是否退出当前账号？',
                    ok: (){
                      StorageUtil().remove(StorageKey.Token);
                      Navigator.of(context).pushAndRemoveUntil(
                          CustomRoute(LoginPage()), (router) => false);
                    }
                );
              },
            ),
          ),
          Column(
            children: List.generate(3, (i){
              return messageList();
            }),
          )
        ],
      ),
    );
  }

  ///通知列表
  Widget messageList(){
    return Container(
      margin: EdgeInsets.only(top: px(24),left: px(20),right: px(24)),
      padding: EdgeInsets.only(left: px(16),top: px(20),bottom: px(20)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(px(8.0))),
      ),
      child: InkWell(
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: px(40),
                  child: Image.asset('lib/assets/icons/my/message.png'),
                  //messageNot
                ),
                Container(
                  margin: EdgeInsets.only(left: px(8),right: px(12)),
                  child: Text('临港环保局',style: TextStyle(color: Color(0xff323233),fontSize: sp(30),fontFamily: 'M'),),
                ),
                Spacer(),
                Container(
                  width: px(140),
                  height: px(48),
                  margin: EdgeInsets.only(right: px(24)),
                  child: Text('2022-4-21',
                    style: TextStyle(color: Color(0xff969799),fontSize: sp(26)),),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: px(16),left: px(40)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: px(12)),
                    child: Text('关于推动xxx任务',
                      style: TextStyle(color: Color(0xff969799),fontSize: sp(26),),
                  ),
                  ),
                ],
              ),
            ),
          ],
        ),
        onTap: (){
          Navigator.pushNamed(context, '/messageDetailsPage');
        },
      ),
    );
  }
}
