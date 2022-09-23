import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:scet_check/api/api.dart';
import 'package:scet_check/api/request.dart';
import 'package:scet_check/components/generalduty/no_data.dart';
import 'package:scet_check/components/generalduty/toast_widget.dart';
import 'package:scet_check/page/module_login/login_page.dart';
import 'package:scet_check/page/module_steward/personal/components/task_compon.dart';
import 'package:scet_check/routers/router_animate/router_animate.dart';
import 'package:scet_check/utils/easyRefresh/easy_refreshs.dart';
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

  final EasyRefreshController _controller = EasyRefreshController(); // 上拉组件控制器
  bool company = false;
  String companyId = '';//公司id
  String companyName = '';//公司名称
  int _pageNo = 1;//页码
  List notificationList = [];//通知列表
  bool _enableLoad = true; // 是否开启加载

  /// 获取企业分类
  void _findNoticeManagePage({typeStatusEnum? type}) async {
    var response = await Request().post(Api.url['findNoticeManagePage']+'?current=$_pageNo&size=10',
        data: {
          'objId':companyId,
        }
    );
    if(response['success'] == true) {
      _pageNo++;
      Map _data = response['result'];
      if(response['result']['records'] != null && response['result']['records'].length > 0){
        if (mounted) {
          if(type == typeStatusEnum.onRefresh) {
            // 下拉刷新
            _onRefresh(data: _data['records'], total: _data['total']);
          }else if(type == typeStatusEnum.onLoad) {
            // 上拉加载
            _onLoad(data: _data['records'], total: _data['total']);
          }
        }
      }
      setState(() {});
    }
  }
  // 下拉刷新
  _onRefresh({required List data,required int total}) {
    _pageNo = 2;
    notificationList = data;
    _controller.resetLoadState();
    _controller.finishRefresh();
    if(notificationList.length >= total){
      _controller.finishLoad(noMore: true);
      _enableLoad = false;
    }
    setState(() {});
  }

  /// 上拉加载
  /// 当前数据等于总数据，关闭上拉加载
  _onLoad({required List data, required int total}) {
    if(mounted){
      notificationList.addAll(data);
      _controller.finishLoadCallBack!();
      if(notificationList.length >= total){
        _enableLoad = false;
        _controller.finishLoad(noMore: true);
      }
      setState(() {});
    }
    _controller.finishLoadCallBack!();
  }
  @override
  void initState() {
    // TODO: implement initState
    company = widget.arguments?['company'] ?? false;
    companyId = jsonDecode(StorageUtil().getString(StorageKey.PersonalData))?['companyId'] ?? "";
    companyName = jsonDecode(StorageUtil().getString(StorageKey.PersonalData))['company']?['name'] ?? '';
    _findNoticeManagePage(type: typeStatusEnum.onRefresh,);
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
            visible: company,
            child: _header(),
          ),
          Expanded(
            child: EasyRefresh(
              enableControlFinishRefresh: true,
              enableControlFinishLoad: true,
              topBouncing: true,
              controller: _controller,
              taskIndependence: false,
              footer: footers(),
              header: headers(),
              onLoad: _enableLoad ? () async{
                _findNoticeManagePage(type: typeStatusEnum.onLoad,);
              }: null,
              onRefresh: () async {
                _pageNo = 1;
                _findNoticeManagePage(type: typeStatusEnum.onRefresh,);
              },
              child: notificationList.isNotEmpty ?
              ListView(
                padding: EdgeInsets.only(top: 0),
                children: List.generate(notificationList.length, (i){
                  return messageList(notification: notificationList[i]);
                }),
              ):
              Column(
                children: [
                  NoData(timeType: true, state: '未获取到数据!')
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  ///头部
  Widget _header(){
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(left: px(24),right: px(24),top: px(24)),
      padding: EdgeInsets.only(left: px(24),right: px(24),top: px(8),bottom: px(8)),
      color: Colors.white,
      child: InkWell(
        child: Row(
          children: [
            Container(
              width: px(100),
              height: px(100),
              decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius:BorderRadius.all(Radius.circular(px(150))),
                  border: Border.all(width: px(2),color: Colors.white)
              ),
              child: Image.asset('lib/assets/images/home/header.png',
                width: px(30),
                height: px(30),
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: px(25)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      companyName,
                      style: TextStyle(
                          fontSize: sp(36),
                          color: Color(0XFF2E2F33),
                          fontFamily: "M",
                          overflow: TextOverflow.ellipsis
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: px(100),
              height: px(100),
              alignment: Alignment.center,
              child: Text('退出'),
            ),
          ],
        ),
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
    );
  }
  ///通知列表
  Widget messageList({required Map notification}){
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
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: px(8),right: px(12)),
                    child: Text('${notification['title']}',style: TextStyle(color: Color(0xff323233),fontSize: sp(30),fontFamily: 'M'),maxLines: 1,overflow: TextOverflow.ellipsis,),
                  ),
                ),
                Container(
                  height: px(48),
                  margin: EdgeInsets.only(right: px(24)),
                  child: Text(
                    notification['createDate'] == null ? '/' :
                    DateTime.fromMillisecondsSinceEpoch(notification['createDate']).toString().substring(0,16),
                    style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: px(52),top: px(16)),
                    child: Text('${notification['objName']}',
                      style: TextStyle(color: Color(0xff969799),fontSize: sp(26),),
                      maxLines: 1,overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        onTap: (){
          Navigator.pushNamed(context, '/messageDetailsPage',arguments: notification);
        },
      ),
    );
  }
}
