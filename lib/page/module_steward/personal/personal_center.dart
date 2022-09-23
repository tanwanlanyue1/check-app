import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:scet_check/components/generalduty/toast_widget.dart';
import 'package:scet_check/page/module_login/login_page.dart';
import 'package:scet_check/routers/router_animate/router_animate.dart';
import 'package:scet_check/utils/screen/screen.dart';
import 'package:scet_check/utils/storage/data_storage_key.dart';
import 'package:scet_check/utils/storage/storage.dart';

import 'components/task_compon.dart';

//个人中心
class PersonalCenter extends StatefulWidget {
  const PersonalCenter({Key? key}) : super(key: key);

  @override
  _PersonalCenterState createState() => _PersonalCenterState();
}

class _PersonalCenterState extends State<PersonalCenter> {
  String userName = ''; //用户名
  List classify = ['历史台账','发布任务','待办任务','已办任务','审核问题',"修改密码","登录统计"];//分类
  List commonClassify = ['历史台账','待办任务','已办任务',"修改密码","登录统计"];//普通用户分类分类
  bool manager = false;//当前账号是否为项目经理
  String roleName = '';//权限名称
  @override
  void initState() {
    // TODO: implement initState
    userName = jsonDecode(StorageUtil().getString(StorageKey.PersonalData))['nickname'];
    List roles = [];
    List rolesCache = jsonDecode(StorageUtil().getString(StorageKey.PersonalData))['roles'];
    for(var i = 0; i < rolesCache.length; i++){
      roles.add(rolesCache[i]['id']);
      if(rolesCache[i]['id'] == 9){
        roleName = rolesCache[i]['name'];
      }else if(rolesCache[i]['id'] == 8){
        roleName = rolesCache[i]['name'];
        break;
      }
    }
    manager = roles.contains(8);
    super.initState();
  }

  //项目经理选择事件
  void selectClass(int index){
    switch(index) {
      case 0: Navigator.pushNamed(context, '/historyTask'); break;
      // case 1: Navigator.pushNamed(context, '/backTaskDetails'); break;
      case 1: Navigator.pushNamed(context, '/releaseTask'); break;
      case 2: Navigator.pushNamed(context, '/backlogTask'); break;
      case 3: Navigator.pushNamed(context, '/haveDoneTask'); break;
      case 4: Navigator.pushNamed(context, '/auditList'); break;
      case 5: Navigator.pushNamed(context, '/changePassword'); break;
      case 6: Navigator.pushNamed(context, '/registerStatistics'); break;
      default: ToastWidget.showToastMsg('暂无更多页面');
    }
  }

  //普通用户选择事件
  void generalClass(int index){
    switch(index) {
      case 0: Navigator.pushNamed(context, '/historyTask'); break;
      case 1: Navigator.pushNamed(context, '/backlogTask'); break;
      case 2: Navigator.pushNamed(context, '/haveDoneTask'); break;
      case 3: Navigator.pushNamed(context, '/changePassword'); break;
      case 4: Navigator.pushNamed(context, '/registerStatistics'); break;
      default: ToastWidget.showToastMsg('暂无更多页面');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TaskCompon.topTitle(title: '个人中心'),
        _header(),
        Expanded(
          child: ListView(
            padding: EdgeInsets.only(top: 0),
            children: List.generate(manager ? classify.length : commonClassify.length, (i){
              return taskList(
                  i: i,
                  classify: manager ? classify : commonClassify
              );
            }),
          ),
        ),
      ],
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
                      userName,
                      style: TextStyle(
                          fontSize: sp(36),
                          color: Color(0XFF2E2F33),
                          fontFamily: "M"
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: px(8.0)),
                      child: Text(roleName,style: TextStyle(fontSize: sp(22),color: Color(0XFF2E2F33))),
                    )
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

  ///任务列表
  ///判断跳转位置
  Widget taskList({required int i,required List classify}){
    return Container(
      margin: EdgeInsets.only(top: px(24),left: px(20),right: px(24)),
      padding: EdgeInsets.only(left: px(16),top: px(20),bottom: px(20)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(px(8.0))),
      ),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(left: px(16),right: px(12)),
              child: Text('${classify[i]}',style: TextStyle(color: Color(0xff323233),fontSize: sp(30),overflow: TextOverflow.ellipsis),),
            ),
            Spacer(),
            SizedBox(
              width: px(140),
              height: px(48),
              child: Container(
                  width: px(64),
                  height: px(64),
                  margin: EdgeInsets.only(right: px(24),left: px(20)),
                  child: Image.asset('lib/assets/icons/other/right.png')
              ),
            ),
          ],
        ),
        onTap: () {
          if(manager){
            selectClass(i);
          }else{
            generalClass(i);
          }
        }
      ),
    );
  }

}
