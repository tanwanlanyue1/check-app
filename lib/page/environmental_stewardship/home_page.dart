import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:scet_check/model/provider/provider_details.dart';
import 'package:scet_check/page/environmental_stewardship/check/check_page.dart';
import 'package:scet_check/page/environmental_stewardship/enterprise/enterprise_page.dart';
import 'package:scet_check/page/environmental_stewardship/law/law_page.dart';
import 'package:scet_check/page/environmental_stewardship/message/message_page.dart';
import 'package:scet_check/utils/logOut/log_out.dart';
import 'package:scet_check/utils/screen/adapter.dart';
import 'package:scet_check/utils/screen/screen.dart';


class HomePage extends StatefulWidget {
  // const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _pageController = PageController();

  int _tabIndex = 0;  // 默认索引第一个tab

  ProviderDetaild? _roviderDetaild;

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
    ScreenUtil.init(BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width,
        maxHeight: MediaQuery.of(context).size.height),
        designSize: Size(Adapter.designWidth, Adapter.designHeight),
        orientation: Orientation.portrait,
    context: context);
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
                ],
              ),
            ),
          )
      ),
    );
  }

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
