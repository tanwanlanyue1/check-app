import 'package:flutter/material.dart';
import 'package:scet_check/api/api.dart';
import 'package:scet_check/api/request.dart';
import 'package:scet_check/components/generalduty/toast_widget.dart';
import 'package:scet_check/page/module_login/login_page.dart';
import 'package:scet_check/routers/router_animate/router_animate.dart';
import 'package:scet_check/utils/screen/screen.dart';
import 'package:scet_check/utils/storage/data_storage_key.dart';
import 'package:scet_check/utils/storage/storage.dart';

///通知中心
class MessagePage extends StatefulWidget {
  const MessagePage({Key? key}) : super(key: key);

  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: px(150)),
      child: InkWell(
        child: Text('退出账号'),
        onTap: (){
          ToastWidget.showDialog(
              msg: '是否退出当前账号？',
              ok: (){
                StorageUtil().remove(StorageKey.Token);
                Navigator.of(context).pushAndRemoveUntil(
                    CustomRoute(LoginPage()), (router) => false);
              }
          );
          // Navigator.pop(context);
        },
      ),
    );
  }

}
