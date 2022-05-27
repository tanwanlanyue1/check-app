import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:scet_check/api/api.dart';
import 'package:scet_check/api/request.dart';
import 'package:scet_check/components/generalduty/no_data.dart';
import 'package:scet_check/components/generalduty/search.dart';
import 'package:scet_check/components/generalduty/sliver_app_bar.dart';
import 'package:scet_check/page/module_steward/check/hiddenParame/components/rectify_components.dart';
import 'package:scet_check/page/module_steward/check/statisticAnaly/components/form_check.dart';
import 'package:scet_check/utils/easyRefresh/easy_refreshs.dart';
import 'package:scet_check/utils/screen/screen.dart';
import 'package:scet_check/utils/storage/data_storage_key.dart';
import 'package:scet_check/utils/storage/storage.dart';

///隐患问题页
///hiddenProblem:隐患数据
///firm:是否企业端
class PersonalProblem extends StatefulWidget {
  final String companyId;
  const PersonalProblem({Key? key,required this.companyId}) : super(key: key);

  @override
  _PersonalProblemState createState() => _PersonalProblemState();
}

class _PersonalProblemState extends State<PersonalProblem> {
  final EasyRefreshController _controller = EasyRefreshController(); // 上拉组件控制器
  int _pageNo = 1; // 当前页码
  int _total = 10; // 总条数
  int firmTotal = 10; // 企业请求的总条数
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
  String checkName = ''; //排查人员
  String companyId = '';//企业id
  String region = '';//企业归属区域
  String userName = ''; //用户名
  String userId = ''; //用户id
  Map<String,dynamic> typeStatus = {'name':'请选择','id':0};//默认类型
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();//侧边栏key

  @override
  void initState() {
    // TODO: implement initState
    companyId = widget.companyId;
    userId= jsonDecode(StorageUtil().getString(StorageKey.PersonalData))['id'];
    userName= jsonDecode(StorageUtil().getString(StorageKey.PersonalData))['nickname'];
    _problemSearch(
        type: typeStatusEnum.onRefresh,
        data: {
          'page': 1,
          'size': 10,
          'companyId':companyId,
          'sort':"status",
          "order":"ASC"
        }
    );
    super.initState();
  }

  /// 获取企业下的问题/问题搜索筛选
  /// companyId:公司id
  /// page:第几页
  /// size:每页多大
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
    firmTotal = data.length;
    hiddenProblem = data;
    _enableLoad = true;
    _pageNo = 2;
    if(firmTotal >= total){
      _controller.finishLoad(noMore: true);
      _enableLoad = false;
    }
    _controller.resetLoadState();
    _controller.finishRefresh();
    setState(() {});
  }

  /// 上拉加载
  /// 当前数据等于总数据，关闭上拉加载
  _onLoad({required List data,required int total}) {
    _total = total;
    firmTotal += data.length;
    hiddenProblem.addAll(data);
    if(firmTotal >= total){
      _controller.finishLoad(noMore: true);
      _enableLoad = false;
    }
    _controller.finishLoadCallBack!();
    setState(() {});
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
                    'sort':"status",
                    "order":"ASC",
                    'companyId':companyId,
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
                      'page': _pageNo,
                      'size': 10,
                      'sort':"status",
                      "order":"ASC",
                      'companyId':companyId,
                    }
                );
              } : null,
              onRefresh: () async {
                _pageNo = 1;
                _problemSearch(
                    type: typeStatusEnum.onRefresh,
                    data: {
                      'page': 1,
                      'size': 10,
                      'sort':"status",
                      "order":"ASC",
                      'companyId':companyId,
                    }
                );
              },
              slivers: <Widget>[
                hiddenProblem.isNotEmpty ?
                SliverList(
                  delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
                    return Container(
                      margin: EdgeInsets.only(top: px(20),left: px(24),right: px(24)),
                      padding: EdgeInsets.only(left: px(12)),
                      height: px(55),width: double.maxFinite,
                      color: Colors.white,
                      child: FormCheck.formTitle(
                        '隐患问题',
                      ),
                    );
                  },
                    childCount: 1,),
                ) :
                SliverList(
                  delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
                    return Container();
                  },
                    childCount: 1,),
                ),
                hiddenProblem.isEmpty ?
                SliverList(
                  delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
                    return NoData(timeType: true, state: '未获取到数据!');
                  },
                    childCount: 1,),
                ) :
                SliverList(
                  delegate: SliverChildBuilderDelegate((context, i) {
                    return Visibility(
                      visible: hiddenProblem[i]['status'] != 2,
                      child: RectifyComponents.rectifyRow(
                          company: hiddenProblem[i],
                          i: i,
                          detail: true,
                          callBack:(){
                            Navigator.pushNamed(context, '/rectificationProblem',
                                arguments: {'check':true,'problemId':hiddenProblem[i]['id']}
                            );
                          }
                      ),
                    );
                  },
                      childCount: hiddenProblem.length),
                ),
                hiddenProblem.isNotEmpty ?
                SliverList(
                  delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
                    return Container(
                      margin: EdgeInsets.only(top: px(20),left: px(24),right: px(24)),
                      padding: EdgeInsets.only(left: px(12)),
                      height: px(55),width: double.maxFinite,
                      color: Colors.white,
                      child: FormCheck.formTitle(
                        '复查问题',
                      ),
                    );
                  },
                    childCount: 1,),
                ) :
                SliverList(
                  delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
                    return Container();
                  },
                    childCount: 1,),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate((context, i) {
                    return Visibility(
                      visible: hiddenProblem[i]['status'] == 2,
                      child: RectifyComponents.rectifyRow(
                          company: hiddenProblem[i],
                          i: i,
                          detail: true,
                          callBack:() async {
                            var res =  await Navigator.pushNamed(context, '/fillAbarbeitung',arguments: {'id':hiddenProblem[i]['id'],'review':true});
                            if(res == true){
                              _problemSearch(
                                  type: typeStatusEnum.onRefresh,
                                  data: {
                                    'page': 1,
                                    'size': 10,
                                    'sort':"status",
                                    "order":"ASC",
                                    'companyId':companyId,
                                  }
                              );
                            }
                          }
                      ),
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
        callPop: (){
          _problemSearch(
              type: typeStatusEnum.onRefresh,
              data: {
                'page': 1,
                'size': 10,
                'sort':"status",
                "order":"ASC",
                'companyId':companyId,
              }
          );
        },
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
                  'companyId':companyId,
                  'sort':"status",
                  "order":"ASC",
                }
            );
          }
          else{
            _problemSearch(
                type: typeStatusEnum.onRefresh,
                data: {
                  'status':typeStatus['id'],
                  'companyId':companyId,
                  'timeSearch':'createdAt',
                  'startTime':startTime,
                  'endTime':endTime,
                  'sort':"status",
                  "order":"ASC",
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