import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scet_check/model/provider/provider_details.dart';
import 'package:scet_check/model/provider/provider_home.dart';
import 'package:scet_check/page/module_steward/law/law_page.dart';
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
  // ProviderDetaild? _roviderDetaild;
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
    {
      'default':'lib/assets/icons/bottom-bar/home.png',
      'select':'lib/assets/icons/bottom-bar/select-home.png',
    },
    {
      'default':'lib/assets/icons/bottom-bar/not_select_firm.png',
      'select':'lib/assets/icons/bottom-bar/select_firm.png',
    },
    {
      'default':'lib/assets/icons/bottom-bar/not_select_check.png',
      'select':'lib/assets/icons/bottom-bar/select_check.png',
    },
    {
      'default':'lib/assets/icons/bottom-bar/instrument.png',
      'select':'lib/assets/icons/bottom-bar/select_instrument.png',
    },
    {
      'default':'lib/assets/icons/bottom-bar/personage.png',
      'select':'lib/assets/icons/bottom-bar/select_personage.png',
    },
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
    _homeModel = Provider.of<HomeModel>(context, listen: true);
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
                _homeModel!.onVerifyNodes();
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
