import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:scet_check/page/module_steward/enterprise/enterprise_details.dart';
import 'package:scet_check/page/module_steward/message/message_page.dart';
import 'package:scet_check/utils/logOut/log_out.dart';
import 'package:scet_check/utils/screen/adapter.dart';
import 'package:scet_check/utils/screen/screen.dart';
import 'package:scet_check/utils/storage/data_storage_key.dart';
import 'package:scet_check/utils/storage/storage.dart';

import 'abarbeitung/enterprise_task_details.dart';

///企业端首页
class EnterpriseHome extends StatefulWidget {
  const EnterpriseHome({Key? key}) : super(key: key);

  @override
  _EnterpriseHomeState createState() => _EnterpriseHomeState();
}

class _EnterpriseHomeState extends State<EnterpriseHome> {
  final _pageController = PageController();//PageView控制器

  int _tabIndex = 0;  // 默认索引第一个tab
  String companyId = '';//公司id
  String companyName = '';//公司名称
  List _pageList = []; //页面内容


  @override
  void initState() {
    // TODO: implement initState companyName
    companyId = jsonDecode(StorageUtil().getString(StorageKey.PersonalData))['companyId'];
    companyName = jsonDecode(StorageUtil().getString(StorageKey.PersonalData))['company']['name'];
    _pageList = [
      EnterpriseTaskDetails(),//企业任务详情
      EnterpriseDetails(
        arguments: {
          "id":companyId,
          'name':companyName,
          'company':true
        },
      ),//一企一档
      MessagePage(
        arguments: const {'company':true},
      ),//通知中心
    ];
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: LogOut.onWillPop,
      child: Scaffold(
          body: PageView.builder(
              physics: const NeverScrollableScrollPhysics(),
              controller: _pageController,
              itemCount: _pageList.length,
              itemBuilder: (context, index) => _pageList[index]
          ),
          bottomNavigationBar: BottomAppBar(
            shape: const CircularNotchedRectangle(),
            child:  SizedBox(
              height: px(Adapter.bottomBarHeight),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  _buildItemMenu(
                      index: 0,
                      commonImage: 'lib/assets/icons/bottom-bar/A.png',
                      activeImage: 'lib/assets/icons/bottom-bar/A1.png'
                  ),
                  _buildItemMenu(
                      index: 1,
                      commonImage: 'lib/assets/icons/bottom-bar/B.png',
                      activeImage: 'lib/assets/icons/bottom-bar/B1.png'
                  ),
                  _buildItemMenu(
                      index: 2,
                      commonImage: 'lib/assets/icons/bottom-bar/D.png',
                      activeImage: 'lib/assets/icons/bottom-bar/D1.png'
                  ),
                ],
              ),
            ),
          )
      ),
    );
  }

  ///每一项菜单
  ///index: 下标
  ///commonImage: 未选中图片
  ///activeImage: 选中图片
  Widget _buildItemMenu({required int index, required String commonImage, required String activeImage}) {
    Widget menuItem = GestureDetector(
        onTap: () {
          _pageController.jumpToPage(index);
          setState(() {
            _tabIndex = index;
          });
        },
        child: Image.asset(
            _tabIndex == index ? activeImage : commonImage,
            width: px(80.0),
            height: px(74.0),
            fit: BoxFit.cover
        )
    );
    return menuItem;
  }
}

