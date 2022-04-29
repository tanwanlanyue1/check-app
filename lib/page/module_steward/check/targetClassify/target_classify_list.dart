import 'package:flutter/material.dart';
import 'package:scet_check/page/module_steward/check/hiddenParame/components/rectify_components.dart';
import 'package:scet_check/page/module_steward/check/statisticAnaly/components/form_check.dart';
import 'package:scet_check/page/module_steward/law/components/law_components.dart';
import 'package:scet_check/utils/screen/screen.dart';

///指标列表
///arguments:{id:企业id]
class TargetClassifyList extends StatefulWidget {
  Map? arguments;
  TargetClassifyList({Key? key,this.arguments}) : super(key: key);

  @override
  _TargetClassifyListState createState() => _TargetClassifyListState();
}

class _TargetClassifyListState extends State<TargetClassifyList> with SingleTickerProviderStateMixin{
  List tabBar = ["原则性指标","差异性指标",'加分项指标','扣分项指标'];//tab列表
  late TabController _tabController; //TabBar控制器
  String companyName = '';
  bool packs = false;

  @override
  void initState() {
    // TODO: implement initState
    _tabController = TabController(vsync: this,length: tabBar.length);
    super.initState();
  }

  ///计算高度
  ///i:数量
  double calculateHeight(int i){
    if( i == 0){
      return px(120);
    }else if( i == 1){
      return px(160);
    }else if(i == 2){
      return px(220);
    }else{
      return px(i * 75+60);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: px(750),
            height: appTopPadding(context),
            color: Color(0xff19191A),
          ),
          RectifyComponents.topBar(
              title: '企业名称',
              callBack: (){
                Navigator.pop(context);
              }
          ),
          Container(
            height: px(64.0),
            color: Colors.white,
            child: DefaultTabController(
              length: tabBar.length,
              child: TabBar(
                  controller: _tabController,
                  indicatorSize: TabBarIndicatorSize.label,
                  indicatorPadding: EdgeInsets.only(bottom: 5.0),
                  isScrollable: true,
                  labelColor: Colors.blue,
                  labelStyle: TextStyle(fontSize: sp(30.0),fontFamily: 'M'),
                  unselectedLabelColor: Color(0xff969799),
                  unselectedLabelStyle: TextStyle(fontSize: sp(30.0),fontFamily: 'R'),
                  indicatorColor:Colors.blue,
                  indicatorWeight: px(2),
                  tabs: tabBar.map((item) {
                    return Tab(text: '  $item  ');
                  }).toList()
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
                controller: _tabController,
                children: <Widget>[
                  Column(
                    children: List.generate(2, (i) => gistDataCard(
                      index: i,
                      packup: packs,
                      onTaps: (){
                        packs = !packs;
                        setState(() {});
                      }
                    ),
                  )),
                  Container(),
                  Container(),
                  Container(),
                ]
            ),
          )
        ],
      ),
    );
  }

  /// 要点卡片
  /// index:下标
  /// data:数据
  /// title:标题
  /// packup:是否渲染
  /// onTaps:回调
  Widget gistDataCard({int? index,List? data,String? title,bool packup = false,Function? onTaps,}){
    return AnimatedCrossFade(
      duration: Duration(milliseconds: 500),
      crossFadeState:
      packup ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      firstChild: Container(
        height: calculateHeight(2),
        width: px(702),
        margin: EdgeInsets.only(top: px(20),left: px(20),right: px(20)),
        padding: EdgeInsets.all(px(24)),
        color: Colors.white,
        child: GestureDetector(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FormCheck.formTitle(
                index! < 9 ?
                "0${index + 1} $title":
                "${index + 1} $title",
                showUp: true,
                tidy: packup,
                onTaps: onTaps,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(2, (i){
                    return Container(
                      margin: EdgeInsets.only(left: px(32),top: px(24)),
                      child: LawComponents.rowTwo(
                          child: Image.asset('lib/assets/icons/other/examine.png'),
                          textChild: Text('子标题名称',style: TextStyle(color: Color(0xff4D7FFF),fontSize: sp(26),fontFamily: 'R'),)
                      ),
                    );
                  }
                  ),
                ),
              ),
            ],
          ),
          onTap: (){
            Navigator.pushNamed(context, '/targetDetails');
          },
        ),
      ),
      secondChild: Container(
        height: px(80),
        width: px(702),
        margin: EdgeInsets.only(top: px(20),left: px(20),right: px(20)),
        padding: EdgeInsets.all(px(12)),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FormCheck.formTitle(
              index < 9 ?
              "0${index + 1} name":
              "${index + 1} title",
              showUp: true,
              tidy: packup,
              onTaps: onTaps,
            ),
          ],
        ),
      ),
    );
  }
}

