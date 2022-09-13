import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:scet_check/api/api.dart';
import 'package:scet_check/api/request.dart';
import 'package:scet_check/components/generalduty/no_data.dart';
import 'package:scet_check/components/generalduty/sliver_app_bar.dart';
import 'package:scet_check/page/module_steward/check/statisticAnaly/components/form_check.dart';
import 'package:scet_check/page/module_steward/personal/components/task_compon.dart';
import 'package:scet_check/utils/easyRefresh/easy_refreshs.dart';
import 'package:scet_check/utils/screen/screen.dart';

/// 对接的企业信息详情
/// url ：地址
/// title: 标题
/// companyId :企业id
/// details：详情
class AbutmentEnterpriseDetails extends StatefulWidget {
  final Map? arguments;
  const AbutmentEnterpriseDetails({Key? key,this.arguments}) : super(key: key);

  @override
  _AbutmentEnterpriseDetailsState createState() => _AbutmentEnterpriseDetailsState();
}

class _AbutmentEnterpriseDetailsState extends State<AbutmentEnterpriseDetails> {

  final EasyRefreshController _controller = EasyRefreshController(); // 上拉组件控制器
  String companyId = '';//企业id
  String title = '';//企业分类标题
  String url = '';//企业分类网址
  List companyData = [];//企业信息
  List details = [];//详情信息
  int _pageNo = 1;//页码
  bool _enableLoad = true; // 是否开启加载
  int _total = 10; // 总条数

  /// 获取企业分类
  void _getProblems({typeStatusEnum? type}) async {
    var response = await Request().get(Api.url[url]+'?page=$_pageNo&size=10',
        data: {'companyId':companyId}
    );
    if(response['success'] == true) {
      _pageNo++;
      Map _data = response['result'];
      if(response['result']['list'] != null && response['result']['list'].length > 0){
        if (mounted) {
          if(type == typeStatusEnum.onRefresh) {
            // 下拉刷新
            _onRefresh(data: _data['list'], total: _data['total']);
          }else if(type == typeStatusEnum.onLoad) {
            // 上拉加载
            _onLoad(data: _data['list'], total: _data['total']);
          }
        }
      }else{
        if (mounted) {
          if(type == typeStatusEnum.onRefresh) {
            // 下拉刷新
            _onRefresh(data: [_data], total: _data['total']);
          }else if(type == typeStatusEnum.onLoad) {
            // 上拉加载
            _onLoad(data: [_data], total: _data['total']);
          }
        }
      }
      setState(() {});
    }
  }
  // 下拉刷新
  _onRefresh({required List data,required int total}) {
    _total = total;
    companyData = data;
    _enableLoad = true;
    _pageNo = 2;
    _controller.resetLoadState();
    _controller.finishRefresh();
    if(companyData.length >= total){
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
      if(companyData.length >= total){
        _enableLoad = false;
        _controller.finishLoad(noMore: true);
      }else{
        companyData.addAll(data);
      }
      setState(() {});
    }
    _controller.finishLoadCallBack!();
  }
  @override
  void initState() {
    // TODO: implement initState
    url = widget.arguments?['url'] ?? '';
    title = widget.arguments?['name'] ?? '';
    companyId = widget.arguments?['id'] ?? '';
    details = widget.arguments?['data'] ?? [];
    if(details.isNotEmpty){
      _getProblems(
        type: typeStatusEnum.onRefresh,
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TaskCompon.topTitle(
              title: title,
              left: true,
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
                _getProblems(
                  type: typeStatusEnum.onLoad,
                );
              } : null,
              onRefresh: () async {
                _pageNo = 1;
                _getProblems(
                    type: typeStatusEnum.onRefresh,
                );
              },
              slivers: <Widget>[
                companyData.isEmpty ?
                SliverList(
                  delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
                    return NoData(timeType: true, state: '未获取到数据!');
                  },
                    childCount: 1,),
                ) :
                SliverList(
                  delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
                    return Column(
                      children: List.generate((companyData.isEmpty ? 1 : companyData.length), (i) => info(companyLists: companyData.isEmpty ? {} : companyData[i])),
                    );
                  },
                    childCount: 1,),
                ),
                SliverPersistentHeader(
                  floating: false,//floating 与pinned 不能同时为true
                  pinned: true,
                  delegate: SliverAppBarDelegate(
                      minHeight: px(100),
                      maxHeight: px(100),
                      child: Visibility(
                          visible: companyData.isNotEmpty && _enableLoad == false,
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

  ///基本信息
  ///[{'title':废水排放口数}]
  Widget info({required Map companyLists,}){
    return Container(
      padding: EdgeInsets.only(left: px(24),right: px(24)),
      margin: EdgeInsets.only(top: px(20)),
      color: Colors.white,
      child: FormCheck.dataCard(
          padding: false,
          children: [
            Column(
              children: List.generate(details.length, (i){
                return surveyItem(
                    '${details[i]['title']}:','${companyLists[details[i]['valuer']] ?? '/'}',details[i]['time'] ?? false
                );
              }),
            ),
          ]
      ),
    );
  }
  /// 概况列表
  /// title：左边标题
  /// data：右边标题
  /// color： true 蓝色  false 白色
  /// color：判断字体
  Widget surveyItem(String? title,String? data,bool time){
    return SizedBox(
      child: FormCheck.rowItem(
        title: title,
        expandedLeft: true,
        child: Text((data == 'null' || data == null) ? "" :
        (data == '0' || data == 'false') ? '否' :
        (data == '1' || data == 'true') ? '是' :
        ((time && data != '/') ? DateTime.fromMillisecondsSinceEpoch(int.parse(data)).toString().substring(0,16) : '$data' ),style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),textAlign: TextAlign.right,),
      ),
    );
  }
}
