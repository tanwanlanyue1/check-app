import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:scet_check/api/api.dart';
import 'package:scet_check/api/request.dart';
import 'package:scet_check/components/generalduty/no_data.dart';
import 'package:scet_check/page/module_steward/check/statisticAnaly/components/form_check.dart';
import 'package:scet_check/page/module_steward/law/components/law_components.dart';
import 'package:scet_check/utils/easyRefresh/easy_refreshs.dart';
import 'package:scet_check/utils/screen/screen.dart';


class EasyRefreshs extends StatefulWidget {
  int typeStatus;
  Function? callBack;
  EasyRefreshs({Key? key,required this.typeStatus,this.callBack,}) : super(key: key);

  @override
  _EasyRefreshsState createState() => _EasyRefreshsState();
}

class _EasyRefreshsState extends State<EasyRefreshs> {
  EasyRefreshController _controller = EasyRefreshController(); // 上拉组件控制器
  bool _enableLoad = true; // 是否开启加载
  List gistData = [];
  int _pageNo = 1; // 当前页码
  int _total = 10; // 总条数
  int typeStatus = 1;

  @override
  void initState() {
    // TODO: implement initState
    typeStatus = widget.typeStatus;
    print('widget.typeStatus===${widget.typeStatus}');
    print('typeStatus===${typeStatus}');
    _getBasis(type: typeStatusEnum.onRefresh);
    super.initState();
  }
  /// 获取分类分级列表
  ///page:第几页
  ///size:每页多大
  void _getBasis({typeStatusEnum? type}) async {
    var response = await Request().get(Api.url['targetList'],
        data: {
          "type": typeStatus,
          "size": 15,
          "level":1,
          "page": 1
        });
    print("response=======$response");
    print("typeStatus==$typeStatus");
    if (response['statusCode'] == 200 && response['data'] != null) {
      if (mounted) {
        Map _data = response['data'];
        ///添加一个展开收起的属性
        for (var i = 0; i < _data['list'].length; i++) {
          _data['list'][i]['tidy'] = false;
        }
        _pageNo++;
        if (type == typeStatusEnum.onRefresh) {
          // 下拉刷新
          _onRefresh(data: _data['list'], total: _data['total']);
        } else if (type == typeStatusEnum.onLoad) {
          // 上拉加载
          _onLoad(data: _data['list'], total: _data['total']);
        }
      }
    }else{
      gistData = [];
    }
    setState(() {});
  }

  /// 下拉刷新
  /// 判断是否是企业端,剔除掉非企业端看的问题
  _onRefresh({required List data, required int total}) {
    _total = total;
    _enableLoad = true;
    _pageNo = 2;
    gistData = data;
    if(mounted){
      _controller.resetLoadState();
      _controller.finishRefresh();
      if (gistData.length >= total) {
        _controller.finishLoad(noMore: true);
        _enableLoad = false;
      }
    }
    setState(() {});
  }

  /// 上拉加载
  /// 当前数据等于总数据，关闭上拉加载
  _onLoad({required List data, required int total}) {
    _total = total;
    gistData.addAll(data);
    if (gistData.length >= total) {
      _controller.finishLoad(noMore: true);
      _enableLoad = false;
    }
    _controller.finishLoadCallBack!();
    setState(() {});
  }

  @override
  void didUpdateWidget(covariant EasyRefreshs oldWidget) {
    // TODO: implement didUpdateWidget
    typeStatus = widget.typeStatus;
    _getBasis(type: typeStatusEnum.onRefresh);
    super.didUpdateWidget(oldWidget);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: EasyRefresh(
        enableControlFinishRefresh: true,
        enableControlFinishLoad: true,
        topBouncing: true,
        controller: _controller,
        taskIndependence: false,
        footer: footers(),
        header: headers(),
        onLoad: _enableLoad
            ? () async {
          _getBasis(type: typeStatusEnum.onLoad);
        }
            : null,
        onRefresh: () async {
          _pageNo = 1;
          _getBasis(type: typeStatusEnum.onRefresh,);
        },
        child: gistData.isNotEmpty ?
        Column(
          children: List.generate(gistData.length, (i) =>
              gistDataCard(
                  index: i,
                  title: gistData[i]['name'],
                  data: gistData[i]['children'],
                  packup: gistData[i]['tidy'],
                  onTaps: () {
                    gistData[i]['tidy'] = !gistData[i]['tidy'];
                    setState(() {});
                  })
          ),
        ) :
        NoData(timeType: true, state: '未获取到数据!'),
      ),
    );
  }


  /// 要点卡片
  /// index:下标
  /// data:数据
  /// title:标题
  /// packup:是否渲染
  /// onTaps:回调
  Widget gistDataCard({
    required int index,
    required List data,
    String? title,
    bool packup = false,
    Function? onTaps,
  }) {
    return Container(
      padding: EdgeInsets.only(left: px(24), right: px(24), bottom: px(12), top: px(12)),
      margin: EdgeInsets.only(top: px(24)),
      color: Colors.white,
      child: Visibility(
        visible: packup,
        child: FormCheck.dataCard(padding: false, children: [
          GestureDetector(
            child: Column(
              children: [
                FormCheck.formTitle(
                  '$title',
                  showUp: true,
                  tidy: packup,
                  onTaps: onTaps,
                ),
                childTitle(childData: data),
              ],
            ),
          ),
        ]),
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
  Widget childTitle({List? childData}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: childData == null || childData.isEmpty
          ? []
          : List.generate(childData.length, (i) {
        return Container(
          margin: EdgeInsets.only(left: px(32), top: px(24)),
          child: Column(
            children: [
              //0xff4D7FFF   0xff323233
              GestureDetector(
                child: LawComponents.rowTwo(
                    child: Image.asset(
                      'lib/assets/icons/other/examine.png',
                      color: Color(0xff4D7FFF),
                    ),
                    textChild: Text(
                      "${childData[i]['name']}",
                      style: TextStyle(
                          color: Color(0xff4D7FFF),
                          fontSize: sp(26),
                          fontFamily: 'R'),
                    )),
                onTap: () {
                  widget.callBack?.call(childData[i]);
                },
              ),
              childData[i]['children'] != null ||
                  childData[i]['children']?.length != 0
                  ? childTitle(childData: childData[i]['children'])
                  : Container()
            ],
          ),
        );
      }),
    );
  }
}