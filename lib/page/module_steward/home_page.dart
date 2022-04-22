import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scet_check/model/provider/provider_details.dart';
import 'package:scet_check/page/module_steward/check/check_page.dart';
import 'package:scet_check/page/module_steward/law/law_page.dart';
import 'package:scet_check/page/module_steward/message/message_page.dart';
import 'package:scet_check/page/module_steward/personal/personal_center.dart';
import 'package:scet_check/utils/logOut/log_out.dart';
import 'package:scet_check/utils/screen/adapter.dart';
import 'package:scet_check/utils/screen/screen.dart';

import 'enterprise/enterprise_page.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _pageController = PageController();//PageView控制器

  int _tabIndex = 0;  // 默认索引第一个tab

  ///全局变量
  /// initOffest : 初始化tab偏移量
  ProviderDetaild? _roviderDetaild;

  final List _pageList = [
    const CheckPage(),//隐患排查
    const EnterprisePage(),//企业管理
    const LawPage(),//法律法规
    const MessagePage(),//通知中心
    const PersonalCenter(),//个人中心
  ];

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
                      commonImage: 'lib/assets/icons/bottom-bar/C.png',
                      activeImage: 'lib/assets/icons/bottom-bar/C1.png'
                  ),
                  _buildItemMenu(
                      index: 3,
                      commonImage: 'lib/assets/icons/bottom-bar/D.png',
                      activeImage: 'lib/assets/icons/bottom-bar/D1.png'
                  ),
                  _buildItemMenu(
                      index: 4,
                      commonImage: 'lib/assets/icons/bottom-bar/mine.png',
                      activeImage: 'lib/assets/icons/bottom-bar/mine-active.png'
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
    _roviderDetaild = Provider.of<ProviderDetaild>(context, listen: true);
    Widget menuItem = GestureDetector(
        onTap: () {
          _pageController.jumpToPage(index);
          _roviderDetaild!.initOffest();
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
