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
