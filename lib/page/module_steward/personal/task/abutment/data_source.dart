import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:provider/provider.dart';
import 'package:scet_check/api/api.dart';
import 'package:scet_check/api/request.dart';
import 'package:scet_check/components/generalduty/no_data.dart';
import 'package:scet_check/components/generalduty/sliver_app_bar.dart';
import 'package:scet_check/model/provider/provider_home.dart';
import 'package:scet_check/page/module_steward/check/statisticAnaly/components/form_check.dart';
import 'package:scet_check/page/module_steward/personal/components/task_compon.dart';
import 'package:scet_check/utils/easyRefresh/easy_refreshs.dart';
import 'package:scet_check/utils/screen/screen.dart';

///数据来源，在线监理，问题复查
class DataSource extends StatefulWidget {
  Map? arguments;
  DataSource({Key? key,this.arguments}) : super(key: key);

  @override
  _DataSourceState createState() => _DataSourceState();
}

class _DataSourceState extends State<DataSource> {
  final EasyRefreshController _controller = EasyRefreshController(); // 上拉组件控制器
  int _pageNo = 1; // 当前页码
  int _total = 10; // 总条数
  bool _enableLoad = true; // 是否开启加载
  List _dataSource = []; //隐患清单数据
  DateTime startTime = DateTime.now().add(Duration(days: -1));//选择开始时间
  DateTime endTime = DateTime.now();//选择结束时间
  Map<String,dynamic> data = {};
  HomeModel? _homeModel; //全局的焦点
  int taskType = 0;
  /// 在线监理-数据来源
  /// page:第几页
  /// size:每页多大
  _summaryPage({typeStatusEnum? type,}) async {
    late Map response;
    if(taskType == 2){
      response = await Request().post(Api.url['summaryFindPage']+'?page=$_pageNo&size=10',data:{});
    }else{
      response = await Request().post(Api.url['problemIssue']+'?page=$_pageNo&size=10',data:{"status":5});
    }
    if(response['errCode'] == '10000'){
      Map _data = response['result'];
      ///添加一个展开收起的属性
      for (var i = 0; i < _data['list'].length; i++) {
        _data['list'][i]['tidy'] = false;
      }
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
    _dataSource = data;
    _enableLoad = true;
    _pageNo = 2;
    _controller.resetLoadState();
    _controller.finishRefresh();
    if(_dataSource.length >= total){
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
        if(_dataSource.length >= total){
          _controller.finishLoad(noMore: true);
          _enableLoad = false;
        }else{
          _dataSource.addAll(data);
        }
        _controller.finishLoadCallBack!();
      });
    }
  }

  ///判断是否选中方法
  pitchOn(int i){
    if(_homeModel?.select.contains(_dataSource[i]['id'])){
      _homeModel?.select.remove(_dataSource[i]['id']);
      int index =  _homeModel?.selectCompany.indexWhere((item) =>  item['id'] == _dataSource[i]['id']);
      if(index != -1) {
        _homeModel?.selectCompany.removeAt(index);
      }
    }else{
      _homeModel?.select.add(_dataSource[i]['id']);
      _homeModel?.selectCompany.add({'id':_dataSource[i]['id'],"name":_dataSource[i]['companyName']});
    }
    setState(() {});
  }
  @override
  void initState() {
    // TODO: implement initState
    taskType = widget.arguments?['taskType'];
    data = {
      "page":_pageNo,
      "size":10,
    };
    _summaryPage(
      type: typeStatusEnum.onRefresh,
    );
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    _homeModel = Provider.of<HomeModel>(context, listen: true);
    return Scaffold(
      body: Column(
        children: [
          TaskCompon.topTitle(
              title: '数据来源',
              left: true,
              font: 32,
              child: InkWell(
                child: Container(
                  height: px(60),
                  margin: EdgeInsets.only(top: px(12),left: px(24),right: px(24),bottom: px(24)),
                  alignment: Alignment.center,
                  child: Text('提交', style: TextStyle(
                    fontSize: sp(32),),),
                ),
                onTap: (){
                  Navigator.pop(context,true);
                },
              ),
              callBack: (){
                Navigator.pop(context);
              }
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
                data = {
                  "page":_pageNo,
                  "size":10,
                };
                _summaryPage(
                  type: typeStatusEnum.onLoad,
                );
              } : null,
              onRefresh: () async {
                _pageNo = 1;
                _summaryPage(
                  type: typeStatusEnum.onRefresh,
                );
              },
              slivers: <Widget>[
                _dataSource.isEmpty ?
                SliverList(
                  delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
                    return NoData(timeType: true, state: '未获取到数据!');
                  },
                    childCount: 1,),
                ) :
                SliverList(
                  delegate: SliverChildBuilderDelegate((context, i) {
                    return sourceList(i:i);
                  },
                      childCount: _dataSource.length),
                ),
                SliverPersistentHeader(
                  floating: false,//floating 与pinned 不能同时为true
                  pinned: true,
                  delegate: SliverAppBarDelegate(
                      minHeight: px(100),
                      maxHeight: px(100),
                      child: Visibility(
                          visible: _dataSource.isNotEmpty && _enableLoad == false,
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

  ///数据来源列表
  Widget sourceList({required int i}){
    return Container(
      margin: EdgeInsets.only(top: px(20),left: px(20),right: px(20)),
      padding: EdgeInsets.only(left: px(16),top: px(20),bottom: px(20)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(px(4.0))),
      ),
      child: InkWell(
        child: Container(
          color: _homeModel?.select.contains(_dataSource[i]['id']) ? Color(0xffCCD6FF) : Colors.white,
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                      width: px(40),
                      height: px(40),
                      margin: EdgeInsets.only(right: px(2)),
                      child: Checkbox(
                          value: _homeModel?.select.contains(_dataSource[i]['id']),
                          onChanged: (bool? onTops){
                            pitchOn(i);
                          })
                  ),
                  Expanded(
                    child: InkWell(
                        child: FormCheck.formTitle(
                            taskType == 2 ?
                            '${_dataSource[i]['companyName']}——${_dataSource[i]['name']}':
                            '${_dataSource[i]['companyName']}——已整改待复核',
                            showUp: true,
                            left: false,
                            tidy: _dataSource[i]['tidy'],
                            onTaps: (){
                              _dataSource[i]['tidy'] = !_dataSource[i]['tidy'];
                              setState(() {});
                            }
                        ), onTap: (){
                      _dataSource[i]['tidy'] = !_dataSource[i]['tidy'];
                      setState(() {});
                    }
                    ),
                  )
                ],
              ),
              taskType == 2 ?
              Visibility(
                visible: _dataSource[i]['tidy'],
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(left: px(12)),
                        child: Text('判研分值：${_dataSource[i]['score']}\n判研时间：${DateTime.fromMillisecondsSinceEpoch(_dataSource[i]['analyzeDate']).toString().substring(0,19)},'
                            '\n判研结果：${_dataSource[i]['analyzeResult']}',style: TextStyle(color: Color(0xff969799),fontSize: sp(24))),
                      ),
                    ),
                  ],
                ),
              ) :
              Visibility(
                visible: _dataSource[i]['tidy'],
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(left: px(12)),
                        child: Text('问题大类：${_dataSource[i]['issueRootTypeName']}\n问题小类：${_dataSource[i]['issueTypeName']}'
                            '\n创建时间：${DateTime.fromMillisecondsSinceEpoch(_dataSource[i]['createDate']).toString().substring(0,19)},'
                            '\n问题描述：${_dataSource[i]['description']}',style: TextStyle(color: Color(0xff969799),fontSize: sp(24))),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        onTap: (){
          pitchOn(i);
        },
      ),
    );
  }
}
