import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:scet_check/components/generalduty/no_data.dart';
import 'package:scet_check/page/module_steward/check/statisticAnaly/components/form_check.dart';
import 'package:scet_check/page/module_steward/law/components/law_components.dart';
import 'package:scet_check/utils/easyRefresh/easy_refreshs.dart';
import 'package:scet_check/utils/screen/screen.dart';


class EasyRefreshs extends StatefulWidget {
  List gistData;
  Function? callBack;
  Function? onRefresh;
  Function? onLoad;
  bool? enableLoad;
  EasyRefreshs({Key? key,required this.gistData,this.callBack,this.onLoad,this.onRefresh,this.enableLoad}) : super(key: key);

  @override
  _EasyRefreshsState createState() => _EasyRefreshsState();
}

class _EasyRefreshsState extends State<EasyRefreshs> {
  EasyRefreshController _controller = EasyRefreshController(); // 上拉组件控制器
  bool _enableLoad = true; // 是否开启加载
  List gistData = [];

  @override
  void initState() {
    // TODO: implement initState
    gistData = widget.gistData;
    _enableLoad = widget.enableLoad ?? true;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant EasyRefreshs oldWidget) {
    // TODO: implement didUpdateWidget
    gistData = widget.gistData;
    _enableLoad = widget.enableLoad ?? true;
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
          widget.onLoad?.call();
        }
            : null,
        onRefresh: () async {
          widget.onRefresh?.call();
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