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
///firm:是否企业端
class ProblemPage extends StatefulWidget {
  String companyId;
  bool firm;
  ProblemPage({Key? key,required this.companyId,required this.firm}) : super(key: key);

  @override
  _ProblemPageState createState() => _ProblemPageState();
}

class _ProblemPageState extends State<ProblemPage> {
  final EasyRefreshController _controller = EasyRefreshController(); // 上拉组件控制器
  int _pageNo = 1; // 当前页码
  int _total = 10; // 总条数
  bool _enableLoad = true; // 是否开启加载
  bool firm = false; // 是否为企业
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

  @override
  void initState() {
    // TODO: implement initState
    companyId = widget.companyId;
    firm = widget.firm;
    _problemSearch(
        type: typeStatusEnum.onRefresh,
        data: {
          'pageNo': 1,
          'pageSize': 50,
          'company.id':companyId,
        }
    );
    super.initState();
  }

  /// 获取企业下的问题/问题搜索筛选
  ///companyId:公司id
  ///page:第几页
  ///size:每页多大
  /// 'timeSearch':确认传递时间,
  /// 'startTime':开始时间,
  /// 'endTime':结束时间,
  ///添加一个状态 check-提交到企业,environment-提交到环保局
  _problemSearch({typeStatusEnum? type,Map<String,dynamic>? data}) async {

    var response = await Request().get(Api.url['problemList'],data: data);

    if(response['statusCode'] == 200 && response['data'] != null){
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

  /// 下拉刷新
  /// 判断是否是企业端,剔除掉非企业端看的问题
  _onRefresh({required List data,required int total}) {
    _total = total;
    if(firm){
      hiddenProblem = [];
      for(var i = 0; i < data.length; i++){
        if(data[i]['isCompanyRead'] == true){
          hiddenProblem.add(data[i]);
        }
      }
    }else{
      hiddenProblem = data;
    }
    _enableLoad = true;
    _pageNo = 2;
    _controller.resetLoadState();
    _controller.finishRefresh();
    if(hiddenProblem.length >= total){
      _controller.finishLoad(noMore: true);
      _enableLoad = false;
    }
    setState(() {});
  }

  /// 上拉加载
  /// 当前数据等于总数据，关闭上拉加载
  _onLoad({required List data,required int total}) {
    _total = total;
    _controller.finishLoadCallBack!();
    if(hiddenProblem.length >= total){
      _controller.finishLoad(noMore: true);
      _enableLoad = false;
    }else{
      if(firm){
        for(var i = 0; i < data.length; i++){
          if(data[i]['isCompanyRead'] == true){
            hiddenProblem.add(data[i]);
          }
        }
      }else{
        hiddenProblem.addAll(data);
      }
    }
    setState(() {});
  }

  @override
  void didUpdateWidget(covariant ProblemPage oldWidget) {
    // TODO: implement didUpdateWidget
    _problemSearch(
        type: typeStatusEnum.onRefresh,
        data: {
          'pageNo': 1,
          'pageSize': 50,
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
              _problemSearch(
                type: typeStatusEnum.onRefresh,
                data: {
                'regexp':true,//近似搜索
                'detail': value,
                'company.id':companyId,
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
              footer: footers(),
              header: headers(),
              onLoad:  _enableLoad ? () async {
                _problemSearch(
                    type: typeStatusEnum.onLoad,
                    data: {
                        'pageNo': _pageNo,
                        'pageSize': 50,
                        'company.id':companyId,
                      }
                );
              } : null,
              onRefresh: () async {
                _pageNo = 1;
                _problemSearch(
                    type: typeStatusEnum.onRefresh,
                    data: {
                      'pageNo': 1,
                      'pageSize': 50,
                      'company.id':companyId,
                    }
                );
              },
              slivers: <Widget>[
                hiddenProblem.isEmpty ?
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
                          if(firm){
                            Navigator.pushNamed(context, '/abarbeitungFrom',arguments: {'id':hiddenProblem[i]['id']});
                          }else{
                            Navigator.pushNamed(context, '/rectificationProblem',
                                arguments: {'check':true,'problemId':hiddenProblem[i]['id']}
                            );
                          }
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
                          visible: hiddenProblem.isNotEmpty && _enableLoad == false,
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
            //判断搜索日期传递的参数
            if(startTime==null){
              _problemSearch(
                  type: typeStatusEnum.onRefresh,
                  data: {
                    'status':typeStatus['id'],
                    'company.id':companyId,
                  }
              );
            }
            else{
              _problemSearch(
                  type: typeStatusEnum.onRefresh,
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