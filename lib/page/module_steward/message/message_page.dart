import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:scet_check/api/api.dart';
import 'package:scet_check/api/request.dart';
import 'package:scet_check/components/generalduty/toast_widget.dart';
import 'package:scet_check/page/module_login/login_page.dart';
import 'package:scet_check/page/module_login/components/update_app.dart';
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
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xffE8E8E8),
      child: Column(
        children: [
          Container(
            width: px(750),
            height: appTopPadding(context),
            color: Color(0xff19191A),
          ),
          InkWell(
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
              // Navigator.pop(context);
            },
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
                Container(
                  margin: EdgeInsets.only(left: px(16),right: px(12)),
                  child: Text('通知信息列表详情',style: TextStyle(color: Color(0xff323233),fontSize: sp(30),overflow: TextOverflow.ellipsis),),
                ),
                Spacer(),
                Container(
                  width: px(140),
                  height: px(48),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(px(20)),
                        bottomLeft: Radius.circular(px(20)),
                      )
                  ),//状态；1,未整改;2,已整改;3,整改已通过;4,整改未通过
                  child: Text('2022-4-21',
                    style: TextStyle(color: Color(0xff323233),fontSize: sp(24)),),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: px(20)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: px(12)),
                    child: Text('通知标题',
                      style: TextStyle(color: Color(0xff323233),fontSize: sp(24)),),
                  ),
                ],
              ),
            ),
          ],
        ),
        onTap: (){
          Navigator.pushNamed(context, '/homeClassify');
        },
      ),
    );
  }
}
