import 'package:flutter/material.dart';
import 'package:scet_check/api/api.dart';
import 'package:scet_check/api/request.dart';
import 'package:scet_check/components/generalduty/no_data.dart';
import 'package:scet_check/page/module_steward/check/statisticAnaly/components/form_check.dart';
import 'package:scet_check/page/module_steward/law/components/law_components.dart';
import 'package:scet_check/page/module_steward/personal/components/task_compon.dart';
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

  ///依据数据
  List<dynamic> gistData = [];

  @override
  void initState() {
    // TODO: implement initState
    _tabController = TabController(vsync: this,length: tabBar.length);
    companyName = widget.arguments?['name'];
    _getBasis();
    super.initState();
  }

  /// 获取排查依据
  void _getBasis() async {
    var response = await Request().get(Api.url['basisList'],data: {"level":1});
    if(response['statusCode'] == 200 && response['data'] != null) {
      gistData = response['data']['list'];
      ///添加一个展开收起的属性
      for(var i=0; i< gistData.length;i++){
        gistData[i]['tidy'] = false;
      }
      gistData[0]['child'] = ['qwe'];
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TaskCompon.topTitle(
              title: companyName,
              left: true,
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
                  ListView(
                    padding: EdgeInsets.only(top: 0),
                    children: List.generate(gistData.length, (i) => gistDataCard(
                      index: i,
                      title: gistData[i]['name'],
                      data: gistData[i]['children'],
                      packup: gistData[i]['tidy'],
                        onTaps: (){
                          gistData[i]['tidy'] = !gistData[i]['tidy'];
                          setState(() {});
                        }
                    )),
                    ),
                  Column(
                    children: [
                      NoData(timeType: true, state: '未获取到数据!')
                    ],
                  ),
                  Column(
                    children: [
                      NoData(timeType: true, state: '未获取到数据!')
                    ],
                  ),
                  Column(
                    children: [
                      NoData(timeType: true, state: '未获取到数据!')
                    ],
                  ),
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
  Widget gistDataCard({required int index,required List data,String? title,bool packup = false,Function? onTaps,}){
    return Container(
      padding: EdgeInsets.only(left: px(24),right: px(24),bottom: px(12),top: px(12)),
      margin: EdgeInsets.only(top: px(24)),
      color: Colors.white,
      child: Visibility(
        visible: packup,
        child: FormCheck.dataCard(
            padding: false,
            children: [
              GestureDetector(
                child: Column(
                  children: [
                    FormCheck.formTitle(
                      '$title',
                      showUp: true,
                      tidy: packup,
                      onTaps: onTaps,
                    ),
                    childTitle(),
                  ],
                ),
              ),
            ]
        ),
        replacement: SizedBox(
          height: px(64),
          child: FormCheck.formTitle(
              '$title',
              showUp: true,
              tidy: packup,
            onTaps: onTaps,
          ),
        ),
      ),
    );
  }

  ///子标题
  Widget childTitle({List? childData}){
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(gistData.length, (i){
        return Container(
          margin: EdgeInsets.only(left: px(32),top: px(24)),
          child: Column(
            children: [
              GestureDetector(
                child: LawComponents.rowTwo(
                    child: Image.asset('lib/assets/icons/other/examine.png'),
                    textChild: Text("${gistData[i]['name']}",style: TextStyle(color: Color(0xff4D7FFF),fontSize: sp(26),fontFamily: 'R'),)
                ),
                onTap: (){
                  print('第二级目录');
                  Navigator.pushNamed(context, '/targetDetails',arguments: {"three":false});
                },
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(gistData.length, (i){
                  return Container(
                    margin: EdgeInsets.only(left: px(32),top: px(24)),
                    child: Column(
                      children: [
                        GestureDetector(
                          child: LawComponents.rowTwo(
                              child: Image.asset('lib/assets/icons/other/examine.png'),
                              textChild: Text("${gistData[i]['name']}",style: TextStyle(color: Color(0xff4D7FFF),fontSize: sp(26),fontFamily: 'R'),)
                          ),
                          onTap: (){
                            print('第三级目录');
                            Navigator.pushNamed(context, '/targetDetails',arguments: {"three":true});
                          },
                        ),
                        // gistData[i]['child'] != null?
                        //   childTitle():
                        //   Container()
                      ],
                    ),
                  );
                }),
              ),
              // gistData[i]['child'] != null?
              //   childTitle():
              //   Container()
            ],
          ),
        );
      }),
    );
  }
}

