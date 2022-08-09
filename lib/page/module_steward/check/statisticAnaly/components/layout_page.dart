import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scet_check/model/provider/provider_details.dart';
import 'package:scet_check/utils/screen/adapter.dart';
import 'package:scet_check/utils/screen/screen.dart';

import 'check_compon.dart';

///tab布局页面
///tabBar: 头部切换
///pageBody: 页面内容
///pageName: 页面偏移量key
///callBack: 回调
///itemWidth: 每一项宽度 默认206
///center: 是否居中平分 默认false为从左往右
class LayoutPage extends StatefulWidget {
  List tabBar;
  List pageBody;//
  Function? callBack;
  String pageName;
  double itemWidth;
  bool center;

  LayoutPage({Key? key,
    required this.tabBar,
    this.callBack,
    required this.pageBody,
    required this.pageName,
    this.itemWidth = 206,
    this.center = false
  }) : super(key: key);

  @override
  _LayoutPageState createState() => _LayoutPageState();
}

class _LayoutPageState extends State<LayoutPage> {
  PageController? pagesController; //page控制器
  ScrollController controller = ScrollController();//头部ListView
  ScrollController controllerTow = ScrollController();
  ///全局变量 控制偏移量
  ProviderDetaild? _roviderDetaild;
  List _tabBar = [];//头部
  List _pageBody = [];//页面内容
  int _pageIndex = 0;//下标
  double off = 0.0;//偏移量

  double _itemWidth = 206; // 默认每一项的宽度
  ///监听滑动
  ///页面与头部一起滑动
  @override
  void initState() {
    super.initState();
    _tabBar = widget.tabBar;
    _pageBody = widget.pageBody;
    _pageIndex = context.read<ProviderDetaild>().getCachePageindex(widget.pageName);
    _itemWidth = widget.itemWidth;

    if(widget.center){
      _itemWidth =  Adapter.designWidth / widget.tabBar.length;
    }

    pagesController= PageController(initialPage: _pageIndex);
    pagesController!.addListener(() {
      if(pagesController!.page != null){
        _roviderDetaild!.setOffest(widget.pageName, off: px(_itemWidth * pagesController!.page!));
      }
    });

    controller.addListener(() {
      off = controller.offset;
      controllerTow.jumpTo(off);
    });
  }

  @override
  void didUpdateWidget(covariant LayoutPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if(oldWidget.pageBody != widget.pageBody){
      _tabBar = widget.tabBar;
      _pageBody = widget.pageBody;
    }
    _pageIndex = context.read<ProviderDetaild>().getCachePageindex(widget.pageName);
    _itemWidth = widget.itemWidth;
    if(widget.center){
      _itemWidth =  Adapter.designWidth / widget.tabBar.length;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _roviderDetaild!.removeCache(widget.pageName);
  }
  @override
  Widget build(BuildContext context) {
    _roviderDetaild = Provider.of<ProviderDetaild>(context, listen: true);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: px(750),
          height: px(74),
          child: Stack(
            children: [
              ListView(
                scrollDirection: Axis.horizontal,
                controller: controllerTow,
                children: [
                  SizedBox(
                    height: px(88),
                    width: px(_itemWidth * _tabBar.length),
                    child: Row(
                      children: [
                        CheckCompon.bagColor(
                          itemWidth: _itemWidth,
                          offestLeft: _roviderDetaild?.getCacheOffest(widget.pageName),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              ListView(
                scrollDirection: Axis.horizontal,
                controller: controller,
                children: [
                  CheckCompon.tabCut(
                      index: _pageIndex,
                      tabBar: _tabBar,
                      itemWidth: _itemWidth,
                      onTap: (i){
                        // widget.callBack?.call(i);
                        _pageIndex = i;
                        pagesController!.jumpToPage(i);
                        setState(() {});
                      }
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
            child: PageView.builder(
              controller: pagesController,
              itemCount: _pageBody.length,
              itemBuilder: (context, i) => _pageBody[i],
              onPageChanged: (val) {
                widget.callBack?.call(val);
                _pageIndex = val;
                _roviderDetaild!.setOffest(widget.pageName, pageIndex: val);
                if((val + 1) * px(_itemWidth) > Adapt.screenW() + controllerTow.offset){
                  double offset = (val + 1) * px(_itemWidth) - Adapt.screenW();
                  controllerTow.animateTo(offset,duration: Duration(milliseconds: 400), curve: Curves.easeOut);
                  controller.animateTo(offset,duration: Duration(milliseconds: 400), curve: Curves.easeOut);
                }

                if(((val + 1) * px(_itemWidth)) -px(_itemWidth) <= controllerTow.offset ){
                  double offset = (val) * px(_itemWidth);
                  controllerTow.animateTo(offset,duration: Duration(milliseconds: 400), curve: Curves.easeOut);
                  controller.animateTo(offset,duration: Duration(milliseconds: 400), curve: Curves.easeOut);
                }

              },
            )
        ),
      ],
    );
  }

}
