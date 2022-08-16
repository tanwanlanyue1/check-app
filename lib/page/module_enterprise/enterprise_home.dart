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
  List tabTitles = ['隐患排查','一企一档', '通知中心'];   // 菜单文案
  List tabIcons = [
    {
      'default':'lib/assets/icons/bottom-bar/not_select_check.png',
      'select':'lib/assets/icons/bottom-bar/select_check.png',
    },
    {
      'default':'lib/assets/icons/bottom-bar/not_select_firm.png',
      'select':'lib/assets/icons/bottom-bar/select_firm.png',
    },
    {
      'default':'lib/assets/icons/bottom-bar/not_select_message.png',
      'select':'lib/assets/icons/bottom-bar/select_message.png',
    },
  ];

  @override
  void initState() {
    // TODO: implement initState companyName
    companyId = jsonDecode(StorageUtil().getString(StorageKey.PersonalData))['companyId'] ?? '';
    companyName = jsonDecode(StorageUtil().getString(StorageKey.PersonalData))['company']['name'] ?? '';
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
                // mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: getBottomNavigationBarItem(),
              ),
            ),
          )
      ),
    );
  }

  ///底部菜单
  List<Widget> getBottomNavigationBarItem() {
    List<Widget> list = [];
    for (int i = 0; i < tabTitles.length; i++) {
      list.add(
        Expanded(
          child: GestureDetector(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: px(40),
                  width: px(41),
                  child: Image.asset( _tabIndex != i ?
                  tabIcons[i]['default'] : tabIcons[i]['select']),
                ),
                Text("${tabTitles[i]}",style: TextStyle(color: _tabIndex == i ? Color(0xff4D7FFF):Color(0xff8FA0CC),fontSize: sp(20)),),
              ],
            ),
            onTap: (){
              _pageController.jumpToPage(i);
              setState(() {
                _tabIndex = i;
              });
            },
          ),
        ),
      );
    }
    return list;
  }
}

