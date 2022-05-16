import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scet_check/model/provider/provider_details.dart';
import 'package:scet_check/model/provider/provider_home.dart';
import 'package:scet_check/page/module_steward/law/law_page.dart';
import 'package:scet_check/page/module_steward/message/message_page.dart';
import 'package:scet_check/page/module_steward/personal/personal_center.dart';
import 'package:scet_check/utils/logOut/log_out.dart';
import 'package:scet_check/utils/screen/adapter.dart';
import 'package:scet_check/utils/screen/screen.dart';

import 'check/hiddenParame/hidden_parameter.dart';
import 'check/statisticAnaly/home_classify.dart';
import 'enterprise/enterprise_page.dart';


class HomePage extends StatefulWidget {
  int? index;
  HomePage({Key? key,this.index = 0}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageController _pageController = PageController();//PageView控制器

  int _tabIndex = 0;  // 默认索引第一个tab

  ///全局变量
  /// initOffest : 初始化tab偏移量
  ProviderDetaild? _roviderDetaild;
  HomeModel? _homeModel; //全局的焦点

  final List _pageList = [
    const HomeClassify(),// 首页分类
    const EnterprisePage(),//企业管理
    // const MessagePage(),//通知中心
    const HiddenParameter(),//隐患排查
    const LawPage(),//工具箱
    const PersonalCenter(),//个人中心
  ];
  List tabTitles = ['首页', '一企一档', '隐患排查', '工具箱','个人中心'];   // 菜单文案

  List tabIcons = [
    'lib/assets/icons/my/backHome.png',
    'lib/assets/icons/bottom-bar/select_firm.png',
    'lib/assets/icons/bottom-bar/select_check.png',
    'lib/assets/icons/my/setting.png',
    'lib/assets/icons/bottom-bar/DD.png',
  ];

  @override
  void initState() {
    // TODO: implement initState
    _tabIndex = widget.index ?? 0;
    _pageController = PageController(initialPage: widget.index ?? 0);//PageView控制器
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
                // children: getBottomNavigationBarItem(),
                children: getBottomNavigationBarItem(),
              ),
            ),
          )
      ),
    );
  }

  ///底部菜单
  List<Widget> getBottomNavigationBarItem() {
    _roviderDetaild = Provider.of<ProviderDetaild>(context, listen: true);
    _homeModel = Provider.of<HomeModel>(context, listen: true);
    List<Widget> list = [];
    for (int i = 0; i < tabTitles.length; i++) {
      list.add(
          GestureDetector(
            // behavior: HitTestBehavior.translucent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: px(40),
                  width: px(41),
                  child: Image.asset(tabIcons[i],color: _tabIndex == i ? Color(0xff4D7FFF):Color(0xff8FA0CC),),
                ),
                Text("${tabTitles[i]}",style: TextStyle(color: _tabIndex == i ? Color(0xff4D7FFF):Color(0xff8FA0CC),fontSize: sp(20)),),
              ],
            ),
            onTap: (){
              _pageController.jumpToPage(i);
              _roviderDetaild!.initOffest();
              _homeModel!.onVerifyNodes();
              setState(() {
                _tabIndex = i;
              });
            },
          ),
      );
    }
    return list;
  }
///每一项菜单
///index: 下标
///commonImage: 未选中图片
///activeImage: 选中图片
  Widget _buildItemMenu({required int index, required String commonImage, required String activeImage,Widget? childs}) {
    _roviderDetaild = Provider.of<ProviderDetaild>(context, listen: true);
    _homeModel = Provider.of<HomeModel>(context, listen: true);
    Widget menuItem = GestureDetector(
        onTap: () {
          _pageController.jumpToPage(index);
          _roviderDetaild!.initOffest();
          _homeModel!.onVerifyNodes();
          setState(() {
            _tabIndex = index;
          });
        },
        // child: Image.asset(
        //     _tabIndex == index ? activeImage : commonImage,
        //     width: px(80.0),
        //     height: px(74.0),
        //     fit: BoxFit.cover
        // )
      child: childs,
    );
    return menuItem;
  }
}
