
import 'package:flutter/material.dart';
import 'package:r_upgrade/r_upgrade.dart';
import 'package:scet_check/components/generalduty/toast_widget.dart';
import 'package:scet_check/utils/screen/screen.dart';

class UpdateApp extends StatefulWidget {
  final String? version;
  final String? msg;
  final bool isForced;
  final String? path;
  UpdateApp({
    this.version,
    this.msg,
    this.isForced = false,
    this.path,
  });

  @override
  _UpdateAppState createState() => _UpdateAppState();
}

class _UpdateAppState extends State<UpdateApp> {

  bool downloadState = true;
  bool updating = false; //更新中
  String? _version, appUrl;
  double _progress = 0.0;
  int? id;

  // 获取平台信息
  Future<String?> _getAppInfo() async {
    setState(() {
      downloadState = true;
      _version = widget.version;
      appUrl = widget.path;
      _progress = 0.0;
    });
  }

  //下载apk
  void upgrade(String url) async {
    id = await RUpgrade.upgrade(
        url,
        fileName: 'com.scet.scet_check',
        isAutoRequestInstall: true,
        notificationVisibility:NotificationVisibility.VISIBILITY_VISIBLE,
        notificationStyle:NotificationStyle.planTime
    );
    updating = true;
    setState(() {});
  }

  //取消下载apk
  void cancel() async {
    if(id != null){
      RUpgrade.cancel(id!);
    }
  }
  @override
  void initState() {
    super.initState();
    _getAppInfo();
    RUpgrade.stream.listen((DownloadInfo info){
      _progress =  info.percent ?? 0.0;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
        visible: downloadState,
        child: Container(
            width: Adapt.screenW(),
            height: Adapt.screenH(),
            color: Colors.black54,
            child: Center(
              child: Container(
                width: px(540),
                height: px(625),
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('lib/assets/images/login/upbgImage.png'),
                        fit: BoxFit.fill
                    )
                ),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(bottom: px(20)),
                            child: Text(
                              '版本：${_version}',
                              style: TextStyle(
                                  fontSize: sp(32),
                                  fontFamily: "M",
                                  color: Color(0xFF2E2F33)
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: px(20)),
                            child: Text(
                              '解决了一些已知的问题！',
                              style: TextStyle(
                                  fontSize: sp(32),
                                  fontFamily: "M",
                                  color: Color(0xFF2E2F33)
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: px(0)),
                            child: Text(
                              // '已下载：${(_progress * 100).toStringAsFixed(2)}%',
                              '已下载：$_progress%',
                              style: TextStyle(
                                  fontSize: sp(22),
                                  fontFamily: "M",
                                  color: Color(0xFFA8ABB3)
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              succeedDialogBtn(
                                str: '取消',
                                bgColor:  Color(0xFF8F98B3),
                                onTap: () {
                                  setState(() {
                                    downloadState = false;
                                    cancel();
                                    Navigator.pop(context);
                                  });
                                },
                              ),
                              succeedDialogBtn(
                                str: updating ? '正在更新':'更新APP',
                                bgColor:  Color(0xFF4D7CFF),
                                onTap: () {
                                  if(!updating){
                                    upgrade(appUrl!);
                                  }else{
                                    ToastWidget.showToastMsg('正在更新');
                                  }
                                },
                              )
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
        )
    );
  }
//成功弹窗按钮
  Widget succeedDialogBtn({String? str, Function? onTap,Color? bgColor}){
    return InkWell(
      child: Container(
        width: px(270),
        height: px(86),
        alignment: Alignment.center,
        color:bgColor,
        child: Text(
          '$str',
          style: TextStyle(
              fontSize: sp(30),
              color: Color(0xFFFFFFFF)
          ),
        ),
      ),
      onTap: (){
        onTap?.call();
      },
    );
  }
}
