import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scet_check/model/provider/provider_details.dart';
import 'package:scet_check/utils/screen/screen.dart';

import 'StatisticAnaly/statistic_analysis.dart';
import 'hiddenParame/hidden_parameter.dart';

///隐患排查
class CheckPage extends StatefulWidget {
  const CheckPage({Key? key}) : super(key: key);

  @override
  _CheckPageState createState() => _CheckPageState();
}

class _CheckPageState extends State<CheckPage> {
  List tabBar = ["统计分析","隐患台帐",];//头部
  PageController pagesController = PageController();//控制器
  int pageIndex = 0;//下标
  List _pageList = [];//页面数组
  ///全局变量 初始化偏移量
  ProviderDetaild? _roviderDetaild;

  void _initData() {
    _pageList = [
      StatisticAnalysis(),//统计分析
      HiddenParameter(),// 隐患台账
      // PotentialRisksIndentification(),//隐患排查
    ];
  }

  @override
  void initState() {
    // TODO: implement initState
    _initData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _roviderDetaild = Provider.of<ProviderDetaild>(context, listen: true);
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: px(750),
            height: appTopPadding(context),
            color: Color(0xff19191A),
          ),
          tabCut(),
          Expanded(
            child: PageView.builder(
                physics: NeverScrollableScrollPhysics(),
                controller: pagesController,
                itemCount: _pageList.length,
                itemBuilder: (context, index) => _pageList[index]
            ),
          ),
        ],
      ),
    );
  }

  ///头部切换
  Widget tabCut(){
    return Container(
        width: px(750),
        height: px(88),
        padding: EdgeInsets.only(left: px(129),right: px(130),bottom: px(19)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children:List.generate(tabBar.length, (i){
          return GestureDetector(
            child: Stack(
              children: [
                Container(
                  color:Colors.transparent,
                  margin: EdgeInsets.only(bottom: px(3)),
                  padding: EdgeInsets.only(left: px(24),right: px(24),top: px(5),bottom: px(5)),
                  child: Text(
                    "${tabBar[i]}",
                    style: TextStyle(
                      fontSize: pageIndex == i ? sp(36) : sp(30),
                      color: pageIndex == i ? Colors.white : Color(0xff969799),
                      fontFamily: pageIndex == i ? 'R' : 'R',
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: Container(
                    width: px(144),
                    margin: EdgeInsets.only(left: px(24),right: px(24)),
                    height: pageIndex == i ? px(17) : 0,
                    child: pageIndex == 0 ?Image.asset('lib/assets/images/home/shapeCombination.png'):
                     // pageIndex == 1 ?Image.asset('lib/assets/images/home/shapeCombinationTwo.png'):
                     Image.asset('lib/assets/images/home/shapeCombinationThree.png'),
                  ),
                )
              ],
            ),
            onTap: (){
              _roviderDetaild!.initOffest();
              pageIndex = i;
              setState(() {});
              pagesController.jumpToPage(i);
            },
          );}
        )),
        decoration: BoxDecoration(
        color: Color(0xff19191A),
        border: Border(bottom: BorderSide(color: Color(0xff19191A),width: 0.0)),),
    );
  }
}
