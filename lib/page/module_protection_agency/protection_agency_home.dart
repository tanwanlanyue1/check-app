import 'package:flutter/material.dart';
import 'package:scet_check/utils/logOut/log_out.dart';
import 'package:scet_check/utils/screen/adapter.dart';
import 'package:scet_check/utils/screen/screen.dart';

///环保局端
class ProtectionAgencyHome extends StatefulWidget {

  const ProtectionAgencyHome({Key? key}) : super(key: key);

  @override
  _ProtectionAgencyHomeState createState() => _ProtectionAgencyHomeState();
}

class _ProtectionAgencyHomeState extends State<ProtectionAgencyHome> {
  final _pageController = PageController();//PageView控制器

  int _tabIndex = 0;  // 默认索引第一个tab


  final List _pageList = [
    Container(),//
    Container(),//
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
