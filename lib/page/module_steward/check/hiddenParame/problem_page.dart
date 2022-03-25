import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:scet_check/api/api.dart';
import 'package:scet_check/api/request.dart';
import 'package:scet_check/components/generalduty/no_data.dart';
import 'package:scet_check/components/generalduty/search.dart';
import 'package:scet_check/components/generalduty/sliver_app_bar.dart';
import 'package:scet_check/utils/easyRefresh/easy_refreshs.dart';
import 'package:scet_check/utils/screen/screen.dart';

import 'components/rectify_components.dart';

///隐患问题页
///hiddenProblem:隐患数据
class ProblemPage extends StatefulWidget {
  List? hiddenProblem;
  String companyId;
  ProblemPage({Key? key,this.hiddenProblem,required this.companyId}) : super(key: key);

  @override
  _ProblemPageState createState() => _ProblemPageState();
}

class _ProblemPageState extends State<ProblemPage> {
  EasyRefreshController _controller = EasyRefreshController(); // 上拉组件控制器
  int _pageNo = 1; // 当前页码
  int _total = 10; // 总条数
  bool _enableLoad = true; // 是否开启加载

  List hiddenProblem = []; //隐患问题数组
  List problemStatus = [
    {'name':'未整改','id':1},
    {'name':'已整改','id':2},
    {'name':'整改已通过','id':3},
    {'name':'整改未通过','id':4},
  ]; //问题的状态
  DateTime? startTime;//选择开始时间
  DateTime? endTime;//选择结束时间
  String companyId = '';//企业id
  Map<String,dynamic> typeStatus = {'name':'请选择','id':0};//默认类型
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();//侧边栏key

  /// 问题搜索筛选
  ///name:搜索名
  ///query:搜索的字段
  void _problemSearch({Map<String,dynamic>? data}) async {
    var response = await Request().get(Api.url['problemList'],data: data,);
    if(response['statusCode'] == 200 && response['data'] != null) {
      setState(() {
        hiddenProblem = response['data']['list'];
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    hiddenProblem = widget.hiddenProblem ?? [];
    companyId = widget.companyId;
    _problemSearch(
        data: {
          'company.id':companyId,
        }
    );
    super.initState();
  }
  /// 获取企业下的问题
  ///companyId:公司id
  ///page:第几页
  ///size:每页多大
  ///andWhere:查询的条件
  ///添加一个状态 check-提交到企业,environment-提交到环保局
  alarmsList({typeStatusEnum? type,int pageNo = 1}) async {
    Map<String, dynamic> _data = {
      'pageNo': pageNo,
      'pageSize': 50,
      'company.id':companyId,
    };
    var response = await Request().get(Api.url['problemList'],data: _data);

    if(response['statusCode'] == 200){
      Map _data = response['data'];
      _pageNo++;
      if (mounted) {
        if(type == typeStatusEnum.onRefresh) {
          // 下拉刷新
          _onRefresh(data: _data['list'], total: _data['total']);
        }else if(type == typeStatusEnum.onLoad) {
          // 上拉加载
          _onLoad(data: _data['list'], total: _data['total']);
        }
      }
    }
  }

  // 返回刷新
  refresh(){
    alarmsList(type: typeStatusEnum.onRefresh);
  }

  // 下拉刷新
  _onRefresh({required List data,required int total}) {
    _total = total;
    hiddenProblem = data;
    _enableLoad = true;
    _controller.resetLoadState();
    _controller.finishRefresh();
    if(hiddenProblem.length >= total){
      _controller.finishLoad(noMore: true);
    }
    setState(() {});
  }
  // 上拉加载
  _onLoad({required List data,required int total}) {
    _total = total;
    hiddenProblem.addAll(data);
    _controller.finishLoadCallBack!();
    if(hiddenProblem.length >= total){
      _controller.finishLoad(noMore: true);
      _enableLoad = false;
    }
    setState(() {});
  }

  @override
  void didUpdateWidget(covariant ProblemPage oldWidget) {
    // TODO: implement didUpdateWidget
    hiddenProblem = widget.hiddenProblem ?? [];
    _problemSearch(
        data: {
          'company.id':companyId,
        }
    );
    super.didUpdateWidget(oldWidget);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Column(
        children: [
          Search(
            bgColor: Color(0xffffffff),
            textFieldColor: Color(0xFFF0F1F5),
            search: (value) {
              _problemSearch(data: {
                'regexp':true,//近似搜索
                'detail': value,
                // 'company.id':companyId,
              });
            },
            screen: (){
              _scaffoldKey.currentState!.openEndDrawer();
            },
          ),
          Expanded(
            child: EasyRefresh.custom(
              enableControlFinishRefresh: true,
              enableControlFinishLoad: true,
              topBouncing: true,
              controller: _controller,
              taskIndependence: false,
              reverse: false,
              // firstRefresh:true,
              footer: footers(),
              header: headers(),
              onLoad:  _enableLoad ? () async {
                alarmsList(type: typeStatusEnum.onLoad, pageNo: _pageNo);
              } : null,
              onRefresh: () async {
                _pageNo = 1;
                alarmsList(type: typeStatusEnum.onRefresh);
              },
              slivers: <Widget>[
                hiddenProblem.length == 0 ?
                SliverList(
                  delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
                    return NoData(timeType: true, state: '未获取到数据!');
                  },
                    childCount: 1,),
                ) :
                SliverList(
                  delegate: SliverChildBuilderDelegate((context, i) {
                    return RectifyComponents.rectifyRow(
                        company: hiddenProblem[i],
                        i: i,
                        detail: true,
                        review: false,
                        callBack:(){
                          Navigator.pushNamed(context, '/rectificationProblem',
                              arguments: {'check':true,'problemId':hiddenProblem[i]['id']}
                          );
                        }
                    );
                  },
                      childCount: hiddenProblem.length),
                ),
                SliverPersistentHeader(
                  floating: false,//floating 与pinned 不能同时为true
                  pinned: true,
                  delegate: SliverAppBarDelegate(
                      minHeight: px(100),
                      maxHeight: px(100),
                      child: Visibility(
                          visible: hiddenProblem.length > 0 && _enableLoad == false,
                          child: Container(
                              padding: EdgeInsets.only(top: px(24.0)),
                              child: Text(
                                '到底啦~',
                                style: TextStyle(
                                    color: Color(0X99A1A6B3),
                                    fontSize: sp(22.0)
                                ),
                                textAlign: TextAlign.center,
                              )
                          )
                      )
                  ),
                )
              ],
            ),
          ),

        ],
      ),
      endDrawer: RectifyComponents.endDrawers(
          context,
          typeStatus: typeStatus,
          status: problemStatus,
          startTime: startTime ?? DateTime.now(),
          endTime: endTime ?? DateTime.now(),
          callBack: (val){
            typeStatus['name'] = val['name'];
            typeStatus['id'] = val['id'];
            setState(() {});
          },
          timeBack: (val){
            startTime = val[0];
            endTime = val[1];
            setState(() {});
          },
          trueBack: (){
            if(startTime==null){
              _problemSearch(
                  data: {
                    'status':typeStatus['id'],
                    'company.id':companyId,
                  }
              );
            }
            else{
              _problemSearch(
                  data: {
                    'status':typeStatus['id'],
                    'company.id':companyId,
                    'timeSearch':'createdAt',
                    'startTime':startTime,
                    'endTime':endTime,
                  }
              );
            }
            Navigator.pop(context);
            setState(() {});
          },
      ),
    );
  }
}
/// 页面状态
enum typeStatusEnum {
  onRefresh, // 刷新
  onLoad // 加载
}