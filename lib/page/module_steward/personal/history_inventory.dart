import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:scet_check/api/api.dart';
import 'package:scet_check/api/request.dart';
import 'package:scet_check/components/generalduty/date_range.dart';
import 'package:scet_check/components/generalduty/no_data.dart';
import 'package:scet_check/components/generalduty/sliver_app_bar.dart';
import 'package:scet_check/page/module_steward/check/hiddenParame/components/rectify_components.dart';
import 'package:scet_check/utils/easyRefresh/easy_refreshs.dart';
import 'package:scet_check/utils/screen/screen.dart';
import 'package:scet_check/utils/storage/data_storage_key.dart';
import 'package:scet_check/utils/storage/storage.dart';
import 'package:scet_check/utils/time/utc_tolocal.dart';


///排查清单页
///hiddenInventory:隐患清单数据
class HistoryInventory extends StatefulWidget {
  final String? companyId;
  const HistoryInventory({Key? key, this.companyId,}) : super(key: key);


  @override
  _HistoryInventoryState createState() => _HistoryInventoryState();
}

class _HistoryInventoryState extends State<HistoryInventory> {
  final EasyRefreshController _controller = EasyRefreshController(); // 上拉组件控制器
  String userId = '';//用户id
  int _pageNo = 1; // 当前页码
  int _total = 10; // 总条数
  bool _enableLoad = true; // 是否开启加载
  List hiddenInventory = []; //隐患清单数据
  String companyId = '';//企业id
  DateTime startTime = DateTime.now().add(Duration(days: -1));//选择开始时间
  DateTime endTime = DateTime.now();//选择结束时间
  Map<String,dynamic> data = {};
  bool createdAt = false;

  /// 获取企业下的问题/问题搜索筛选
  /// companyId:公司id
  /// page:第几页
  /// size:每页多大
  /// 'timeSearch':确认传递时间,
  /// 'startTime':开始时间,
  /// 'endTime':结束时间,
  ///添加一个状态 check-提交到企业,environment-提交到环保局
  _inventorySearch({typeStatusEnum? type,}) async {
    if(companyId.isNotEmpty){
      data.addAll(
          {'companyId':companyId,}
      );
    }
    if(createdAt){
      data.addAll(
          {
            'timeSearch':'createdAt',
            'startTime':formatTime(startTime),
            'endTime':formatTime(endTime),
          }
      );
    }
    var response = await Request().get(Api.url['inventoryList'],data: data,);
    // print("data===$data");
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
      setState(() {
        _total = total;
        if(hiddenInventory.length >= total){
          _controller.finishLoad(noMore: true);
          _enableLoad = false;
        }else{
          hiddenInventory.addAll(data);
        }
        _controller.finishLoadCallBack!();
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    companyId = widget.companyId ?? "";
    userId= jsonDecode(StorageUtil().getString(StorageKey.PersonalData))['id'].toString();
    data = {
      'page': _pageNo,
      'size': 10,
      "userId":userId,
    };
    _inventorySearch(
        type: typeStatusEnum.onRefresh,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          selectTime(),
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
                _inventorySearch(
                    type: typeStatusEnum.onLoad,
                );
              } : null,
              onRefresh: () async {
                _pageNo = 1;
                _inventorySearch(
                    type: typeStatusEnum.onRefresh,
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
                          if(mounted){
                            var res = await Navigator.pushNamed(context, '/stewardCheck',arguments: {
                              'uuid':hiddenInventory[i]['id'],
                              'company':false
                            });
                            if(res == null){
                              _pageNo = 1;
                              _inventorySearch(
                                  type: typeStatusEnum.onRefresh,
                              );
                            }
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
    );
  }
  ///日期选择
  Widget selectTime(){
    return Container(
      margin: EdgeInsets.only(left: px(24),top: px(24),right: px(24)),
      padding: EdgeInsets.only(bottom: px(12),left: px(12),top: px(12)),
      color: Colors.white,
      child: Row(
        children: [
          Container(
            width: px(140),
            alignment: Alignment.bottomCenter,
            child: Text('日期 ',style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),),
          ),
          Expanded(
            child: Container(
              width: px(580),
              margin: EdgeInsets.only(left: px(24),right: px(24)),
              child: DateRange(
                start: startTime,
                end: endTime,
                showTime: false,
                callBack: (val) {
                  startTime = val[0];
                  endTime = val[1];
                  _pageNo = 1;
                  createdAt = true;
                  _inventorySearch(
                    type: typeStatusEnum.onRefresh,
                  );
                  setState(() {});
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  ///时间格式
  ///time:时间
  static String formatTime(time) {
    return utcToLocal(time.toString()).substring(0,16);
  }
}
