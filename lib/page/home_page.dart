import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scet_check/page/enterprise/enterprise_page.dart';
import 'package:scet_check/page/law/law_page.dart';
import 'package:scet_check/page/message/message_page.dart';
import 'package:scet_check/utils/logOut/log_out.dart';
import 'package:scet_check/utils/screen/adapter.dart';
import 'package:scet_check/utils/screen/screen.dart';

import 'check/check_page.dart';

class HomePage extends StatefulWidget {
  // const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _pageController = PageController();

  int _tabIndex = 0;  // 默认索引第一个tab

  List _tabTitles = ['首页', '预警', '监测', '信息'];   // 菜单文案

  final List _pageList = [
    const CheckPage(),
    const EnterprisePage(),
    const LawPage(),
    const MessagePage(),
  ];

  List tabIcons = [
    [
      const Icon(Icons.map, size: 20.0,color: Color(0XFFB9B9B9)),
      const Icon(Icons.map, size: 20.0,color: Color(0XFF4D7CFF)),
    ],
    [
      const Icon(Icons.notifications_active, size: 20.0,color: Color(0XFFB9B9B9)),
      const Icon(Icons.notifications_active, size: 20.0,color: Color(0XFF4D7CFF)),
    ],
    [
      const Icon(Icons.show_chart, size: 20.0,color: Color(0XFFB9B9B9)),
      const Icon(Icons.show_chart, size: 20.0,color: Color(0XFF4D7CFF)),
    ],
    [
      const Icon(Icons.date_range, size: 20.0,color: Color(0XFFB9B9B9)),
      const Icon(Icons.date_range, size: 20.0,color: Color(0XFF4D7CFF)),
    ]
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
            child:  Container(
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
                ],
              ),
            ),
          )
      ),
    );
  }

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
