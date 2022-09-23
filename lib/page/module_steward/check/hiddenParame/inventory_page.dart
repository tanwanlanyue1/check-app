import 'dart:developer';

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

///排查清单页
///hiddenInventory:隐患清单数据
///firm 是否为企业端
class InventoryPage extends StatefulWidget {
  String companyId;
  bool firm;
  InventoryPage({Key? key,required this.companyId,required this.firm}) : super(key: key);


  @override
  _InventoryPageState createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  final EasyRefreshController _controller = EasyRefreshController(); // 上拉组件控制器
  int _pageNo = 1; // 当前页码
  int _total = 10; // 总条数
  bool _enableLoad = true; // 是否开启加载
  bool firm = false; // 是否为企业
  List hiddenInventory = []; //隐患清单数据
  List inventoryStatus = [
    {'name':'未提交','id':6},
    {'name':'待审核','id':3},
    {'name':'整改中','id':0},
    {'name':'已归档','id':2},
  ]; //清单的状态
  String companyId = '';//企业id
  String status = '请选择';//默认状态
  List selectStatus = [];//选中的状态
  DateTime? startTime;//选择开始时间
  DateTime? endTime;//选择结束时间
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();//侧边栏key

  /// 获取企业下的问题/问题搜索筛选
  /// companyId:公司id
  /// page:第几页
  /// size:每页多大
  /// 'timeSearch':确认传递时间,
  /// 'startTime':开始时间,
  /// 'endTime':结束时间,
  ///添加一个状态 check-提交到企业,environment-提交到环保局
  _inventorySearch({typeStatusEnum? type,Map<String,dynamic>? data}) async {
    var response = await Request().get(Api.url['inventoryList'],data: data,);
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

  // 下拉刷新
  _onRefresh({required List data,required int total}) {
    _total = total;
    hiddenInventory = data;
    _enableLoad = true;
    _pageNo = 2;
    _controller.resetLoadState();
    _controller.finishRefresh();
    if(hiddenInventory.length >= total){
      _controller.finishLoad(noMore: true);
      _enableLoad = false;
    }
    setState(() {});
  }

  /// 上拉加载
  /// 当前数据等于总数据，关闭上拉加载
  _onLoad({required List data, required int total}) {
    if(mounted){
        _total = total;
        if(hiddenInventory.length >= total){
          _enableLoad = false;
          _controller.finishLoad(noMore: true);
        }else{
          hiddenInventory.addAll(data);
        }
        setState(() {});
    }
    _controller.finishLoadCallBack!();
  }

  @override
  void initState() {
    // TODO: implement initState
    companyId = widget.companyId;
    firm = widget.firm;
    _inventorySearch(
        type: typeStatusEnum.onRefresh,
        data: {
          'page': 1,
          'size': 10,
          'companyId':companyId,
        }
    );
    super.initState();
  }

  @override
  void didUpdateWidget(covariant InventoryPage oldWidget) {
    // TODO: implement didUpdateWidget
    _inventorySearch(
        type: typeStatusEnum.onRefresh,
        data: {
          'page': 1,
          'size': 10,
          'companyId':companyId,
        }
    );
    startTime = null;
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
              _inventorySearch(
                  type: typeStatusEnum.onRefresh,
                  data: {
                    'regexp':true,//近似搜索
                    'detail': value,
                    'companyId':companyId,
                  }
              );
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
                _inventorySearch(
                    type: typeStatusEnum.onLoad,
                    data: {
                      'page': _pageNo,
                      'size': 10,
                      'companyId':companyId,
                    }
                );
              } : null,
              onRefresh: () async {
                _pageNo = 1;
                _inventorySearch(
                    type: typeStatusEnum.onRefresh,
                    data: {
                      'page': 1,
                      'size': 10,
                      'companyId':companyId,
                    }
                );
              },
              slivers: <Widget>[
                hiddenInventory.isEmpty ?
                SliverList(
                  delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
                    return NoData(timeType: true, state: '未获取到数据!');
                  },
                    childCount: 1,),
                ) :
                SliverList(
                  delegate: SliverChildBuilderDelegate((context, i) {
                    return RectifyComponents.repertoireRow(
                        company: hiddenInventory[i],
                        i: i,
                        callBack:()async{
                          if(firm){
                            //企业端跳转到企业清单详情
                            Navigator.pushNamed(context, '/enterpriseInventory',
                                arguments: {'uuid':hiddenInventory[i]['id'],'company':false});
                          }else{
                            //管家端
                            Navigator.pushNamed(context, '/stewardCheck',arguments: {
                              'uuid':hiddenInventory[i]['id'],
                              'company':false
                            });
                          }
                        }
                    );
                  },
                  childCount: hiddenInventory.length),
                ),
                SliverPersistentHeader(
                  floating: false,//floating 与pinned 不能同时为true
                  pinned: true,
                  delegate: SliverAppBarDelegate(
                      minHeight: px(100),
                      maxHeight: px(100),
                      child: Visibility(
                          visible: hiddenInventory.isNotEmpty && _enableLoad == false,
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
        typeStatus: status,
        status: inventoryStatus,
        currentDataList: selectStatus,
        startTime: startTime ?? DateTime.now(),
        endTime: endTime ?? DateTime.now(),
        callPop: (){
          status = '请选择';
          selectStatus = [];
          startTime = DateTime.now();
          endTime = DateTime.now();
          _inventorySearch(
              type: typeStatusEnum.onRefresh,
              data: {
                'page': 1,
                'size': 10,
                'companyId':companyId,
              }
          );
        },
        callBack: (val){ //状态选择
          selectStatus = val;
          if(val.length == 0){
            status = '请选择';
          }else{
            for(var i = 0; i < val.length;i++){
              if(i > 0){
                status = status + ',' + val[i]['name'];
              }else{
                status = val[i]['name'];
              }
            }
          }
          setState(() {});
        },
        timeBack: (val){ //选择时间
          startTime = val[0];
          endTime = val[1];
          setState(() {});
        },
        trueBack: (){
          List searchStatus = [];
          for(var i = 0; i < selectStatus.length; i++){
            if(selectStatus[i]['id'] == 0){
              searchStatus.addAll({1, 4, 5});
            }else{
              searchStatus.add(selectStatus[i]['id']);
            }
          }
          if(startTime == null){
            _inventorySearch(
                type: typeStatusEnum.onRefresh,
                data: {
                  'status': searchStatus,
                  'companyId':companyId,
                }
            );
          }
          else{
            _inventorySearch(
                type: typeStatusEnum.onRefresh,
                data: {
                  'status': searchStatus,
                  'companyId':companyId,
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
