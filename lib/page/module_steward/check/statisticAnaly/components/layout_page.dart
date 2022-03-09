import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scet_check/model/provider/provider_details.dart';
import 'package:scet_check/utils/screen/screen.dart';

import 'check_compon.dart';

///tab布局页面
///tabBar: 头部切换
///pageBody: 页面内容
///callBack: 回调
class LayoutPage extends StatefulWidget {
  List tabBar;
  List pageBody;//
  Function? callBack;
  LayoutPage({Key? key,required this.tabBar,this.callBack,required this.pageBody}) : super(key: key);

  @override
  _LayoutPageState createState() => _LayoutPageState();
}

class _LayoutPageState extends State<LayoutPage> {
  final PageController pagesController = PageController(); //page控制器
  ///全局变量 控制偏移量
  ProviderDetaild? _roviderDetaild;
  List _tabBar = [];//头部
  List _pageBody = [];//页面内容
  int _pageIndex = 0;//下标

  @override
  void initState() {
    super.initState();
    _tabBar = widget.tabBar;
    _pageBody = widget.pageBody;
    pagesController.addListener(() {
      if(pagesController.page != null){
        _roviderDetaild!.setOffest(pagesController.page!);
      }
    });
  }

  @override
  void didUpdateWidget(covariant LayoutPage oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    _tabBar = widget.tabBar;
    _pageBody = widget.pageBody;
  }

  @override
  Widget build(BuildContext context) {
    _roviderDetaild = Provider.of<ProviderDetaild>(context, listen: true);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: px(730),
          height: px(74),
          margin: EdgeInsets.only(left:px(20),right: px(18)),
          child: Stack(
            children: [
              CheckCompon.bagColor(
                pageIndex: _pageIndex,
                offestLeft:_roviderDetaild!.offestLeft,
              ),
              CheckCompon.tabCut(
                  index: _pageIndex,
                  tabBar: _tabBar,
                  onTap: (i){
                    _pageIndex = i;
                    pagesController.jumpToPage(i);
                    setState(() {});
                  }
              ),
            ],
          ),
        ),
        Expanded(
            child: PageView.builder(
              controller: pagesController,
              itemCount: _pageBody.length,
              itemBuilder: (context, i) =>
              _pageBody[i],
              onPageChanged: (val){
                _pageIndex = val;
                widget.callBack?.call(val);
              },
            )),
      ],
    );
  }

}
