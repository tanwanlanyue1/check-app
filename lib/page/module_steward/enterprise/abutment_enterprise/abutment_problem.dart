import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:scet_check/api/api.dart';
import 'package:scet_check/api/request.dart';
import 'package:scet_check/components/generalduty/no_data.dart';
import 'package:scet_check/page/module_steward/personal/components/task_compon.dart';
import 'package:scet_check/utils/easyRefresh/easy_refreshs.dart';
import 'package:scet_check/utils/screen/screen.dart';

///问题管理列表
class AbutmentProblem extends StatefulWidget {
  Map? arguments;
  AbutmentProblem({Key? key, this.arguments}) : super(key: key);

  @override
  _AbutmentProblemState createState() => _AbutmentProblemState();
}

class _AbutmentProblemState extends State<AbutmentProblem> {
  List problemList = []; //任务列表
  final EasyRefreshController _controller = EasyRefreshController(); // 上拉组件控制器
  bool _enableLoad = true; // 是否开启加载
  int _pageNo = 1; // 当前页码
  int _total = 10; // 总条数
  String companyId = ''; //企业id
  String title = ''; //企业分类标题
  String url = ''; //企业分类网址

  @override
  void initState() {
    // TODO: implement initState
    url = widget.arguments?['url'] ?? '';
    title = widget.arguments?['name'] ?? '';
    companyId = widget.arguments?['id'] ?? '';
    _getTaskList(
      type: typeStatusEnum.onRefresh,
    );
    super.initState();
  }

  /// 查询企业问题列表
  ///page:第几页
  ///size:每页多大
  _getTaskList({typeStatusEnum? type}) async {
    var response = await Request().post(Api.url[url] + '?page=$_pageNo&size=10',
        data: {"companyId": companyId});
    if (response['errCode'] == '10000') {
      Map _data = response['result'];
      _pageNo++;
      if (mounted) {
        if (type == typeStatusEnum.onRefresh) {
          // 下拉刷新
          _onRefresh(data: _data['list'], total: _data['total']);
        } else if (type == typeStatusEnum.onLoad) {
          // 上拉加载
          _onLoad(data: _data['list'], total: _data['total']);
        }
      }
    }
  }

  /// 下拉刷新
  /// 判断是否是企业端,剔除掉非企业端看的问题
  _onRefresh({required List data, required int total}) {
    _total = total;
    _enableLoad = true;
    _pageNo = 2;
    problemList = data;
    _controller.resetLoadState();
    _controller.finishRefresh();
    if (problemList.length >= total) {
      _controller.finishLoad(noMore: true);
      _enableLoad = false;
    }
    setState(() {});
  }

  /// 上拉加载
  /// 当前数据等于总数据，关闭上拉加载
  _onLoad({required List data, required int total}) {
    _total = total;
    problemList.addAll(data);
    if (problemList.length >= total) {
      _controller.finishLoad(noMore: true);
      _enableLoad = false;
    }
    _controller.finishLoadCallBack!();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TaskCompon.topTitle(
              title: '$title列表',
              left: true,
              callBack: (){
                Navigator.pop(context);
              }
          ),
          Expanded(
            child: EasyRefresh(
              enableControlFinishRefresh: true,
              enableControlFinishLoad: true,
              topBouncing: true,
              controller: _controller,
              taskIndependence: false,
              footer: footers(),
              header: headers(),
              onLoad: _enableLoad
                  ? () async {
                _getTaskList(
                  type: typeStatusEnum.onLoad, );
              }
                  : null,
              onRefresh: () async {
                _pageNo = 1;
                _getTaskList(
                    type: typeStatusEnum.onRefresh);
              },
              child: itemTask(),
            ),
          )
        ],
      ),
    );
  }

  Widget itemTask() {
    return problemList.isNotEmpty
        ? ListView(
            padding: EdgeInsets.only(top: 0),
            children: List.generate(problemList.length, (i) {
              return Container(
                margin:
                    EdgeInsets.only(top: px(24), left: px(20), right: px(24)),
                padding:
                    EdgeInsets.only(left: px(24), top: px(20), bottom: px(20)),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(px(8.0))),
                ),
                child: InkWell(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: px(40),
                            height: px(40),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  //渐变位置
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  stops: const [0.0, 1.0], //[渐变起始点, 渐变结束点]
                                  colors: const [Color(0xff9EB9FF), Color(0xff608DFF)] //渐变颜色[始点颜色, 结束颜色]
                                  ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                            ),
                            child: Text(
                              '${i + 1}',
                              style: TextStyle(
                                  color: Colors.white, fontSize: sp(28)),
                            ),
                          ),
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: Adapt.screenW() - px(250),
                            ),
                            child: Container(
                              margin: EdgeInsets.only(left: px(16), right: px(12)),
                              child: Text(
                                '${problemList[i]['issueRootTypeName'] ?? '/'}',
                                style: TextStyle(
                                    color: Color(0xff323233),
                                    fontSize: sp(30),
                                    fontFamily: "M",
                                    overflow: TextOverflow.ellipsis),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(top: px(2)),
                        child: Text(
                          DateTime.fromMillisecondsSinceEpoch(problemList[i]['createDate']).toString().substring(0,16),
                          style: TextStyle(
                              color: Color(0xff969799),
                              fontSize: sp(26)),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: px(16), top: px(12)),
                        child: Text(
                          '${problemList[i]['description']}',
                          style: TextStyle(
                              color: Color(0xff969799),
                              fontSize: sp(26)),
                        ),
                      ),
                    ],
                  ),
                  onTap: () async {
                    widget.arguments?['id'] = problemList[i]['id'];
                    widget.arguments?['url'] = 'problemDetail';
                    Map? arguments = widget.arguments;
                    Navigator.pushNamed(context, '/abutmentDetails',arguments: arguments);
                  },
                ),
              );
            }),
          )
        : Column(
            children: [NoData(timeType: true, state: '未获取到数据!')],
          );
  }
}
