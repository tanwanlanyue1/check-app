import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:scet_check/api/api.dart';
import 'package:scet_check/api/request.dart';
import 'package:scet_check/components/generalduty/no_data.dart';
import 'package:scet_check/components/generalduty/sliver_app_bar.dart';
import 'package:scet_check/page/module_steward/check/hiddenParame/components/rectify_components.dart';
import 'package:scet_check/page/module_steward/check/statisticAnaly/components/form_check.dart';
import 'package:scet_check/utils/easyRefresh/easy_refreshs.dart';
import 'package:scet_check/utils/screen/screen.dart';
import 'package:scet_check/utils/storage/data_storage_key.dart';
import 'package:scet_check/utils/storage/storage.dart';

import 'components/task_compon.dart';


///审核清单列表
class AuditList extends StatefulWidget {
  const AuditList({Key? key}) : super(key: key);

  @override
  _AuditListState createState() => _AuditListState();
}

class _AuditListState extends State<AuditList> {
  final EasyRefreshController _controller = EasyRefreshController(); // 上拉组件控制器
  int _pageNo = 1; // 当前页码
  int _total = 10; // 总条数
  bool _enableLoad = true; // 是否开启加载
  List hiddenInventory = []; //隐患清单数据
  String orgId = '';

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
    orgId = jsonDecode(StorageUtil().getString(StorageKey.PersonalData))['orgId'].toString();
    _inventorySearch(
        type: typeStatusEnum.onRefresh,
        data: {
          'page': 1,
          'size': 10,
          'status':3,
          "company.parentOrgId":orgId
        }
    );
    super.initState();
  }

  @override
  void didUpdateWidget(covariant AuditList oldWidget) {
    // TODO: implement didUpdateWidget

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TaskCompon.topTitle(
              title: '审核问题',
              left: true,
              callBack: (){
                Navigator.pop(context);
              }
          ),
          Expanded(
            child:  EasyRefresh.custom(
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
                      'status':3,
                      "company.parentOrgId":orgId
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
                      'status':3,
                      "company.parentOrgId":orgId
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
                        callBack:() async {
                          var res = await Navigator.pushNamed(context, '/auditProblem',arguments: {"id":hiddenInventory[i]['id']});
                          if(res == true){
                            _inventorySearch(
                                type: typeStatusEnum.onRefresh,
                                data: {
                                  'page': 1,
                                  'size': 10,
                                  'status':3,
                                  "company.parentOrgId":orgId
                                }
                            );
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
          )
        ],
      ),
    );
  }
}
