import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:scet_check/api/api.dart';
import 'package:scet_check/api/request.dart';
import 'package:scet_check/components/generalduty/down_input.dart';
import 'package:scet_check/components/generalduty/no_data.dart';
import 'package:scet_check/components/generalduty/sliver_app_bar.dart';
import 'package:scet_check/page/module_steward/check/statisticAnaly/components/form_check.dart';
import 'package:scet_check/page/module_steward/personal/components/task_compon.dart';
import 'package:scet_check/utils/easyRefresh/easy_refreshs.dart';
import 'package:scet_check/utils/screen/screen.dart';

///引导详情
///recordList:判研次数列表
///factorBelong: 1: 废水，2：废气
class GuideDetail extends StatefulWidget {
  final Map? arguments;
  const GuideDetail({Key? key, this.arguments}) : super(key: key);

  @override
  _GuideDetailState createState() => _GuideDetailState();
}

class _GuideDetailState extends State<GuideDetail> {
  final EasyRefreshController _controller = EasyRefreshController(); // 上拉组件控制器
  bool _enableLoad = true; // 是否开启加载
  int _pageNo = 1; // 当前页码
  int _total = 10; // 总条数
  int type = 1; //类型 1:废水分钟值，2：废水小时值，3：废气分钟值，4：废气小时值
  List recordList = []; //判研次数列表
  List relExceptionFactorList = []; //异常数据列表
  List allList = []; //全部数据
  List timeList = []; //次数列表
  String times = '第1次'; //次数
  Map companyHeader = {
    "PH值()": "ph",
    "氨氮(mg/L)": "ammoniaNitrogen",
    "总磷(mg/L)": "phosphorus",
    "总氮(mg/L)": "nitrogen",
    "六价铬(mg/L)": "hexavalentChromium",
    "总铬(mg/L)": "chromium",
    "总锌(mg/L)": "zinc",
    "总镍(mg/L)": "nickel",
    "总铁(mg/L)": "iron",
    "总铅(mg/L)": "lead",
    "氰化物(mg/L)": "cyanide",
    "总铜(mg/L)": "copper",
    "总砷(mg/L)": "arsenic",
    "总镉(mg/L)": "cadmium",
    "电导率(S/m)": "conductivity",
    "化学需氧量(mg/L)": "cod",
    "水温(℃)": "waterTemp",
    "废水瞬时流量(m3)": "waterFlowTotal",
    "废水瞬时流量(L/s)": "waterFlow",
    "烟尘(mg/m3)": "soot",
    "烟尘折算浓度(mg/m3)": "sootConc",
    "二氧化硫(mg/m3)": "sulfurDioxide",
    "SO2折算浓度(mg/m3)": "sulfurDioxideConc",
    "氮氧化物(mg/m3)": "nitrogenOxides",
    "NOX折算浓度(mg/m3)": "nitrogenOxidesConc",
     "一氧化碳(mg/m3)": "carbonMonoxide",
    "CO折算浓度(mg/m3)": "carbonMonoxideConc",
    "氯化氢(mg/m3)": "hydrogenChloride",
    "HCL折算浓度(mg/m3)": "hydrogenChlorideConc",
    "甲烷(mg/m3)": "methane",
    "甲烷折算浓度(mg/m3)": "methaneConc",
    "非甲烷总烃(mg/m3)": "noMethaneHydrocarbons",
    "非甲烷总烃折算浓度(mg/m3)": "noMethaneHydrocarbonsConc",
    "总烃(mg/m3)": "hydrocarbons",
    "总烃折算浓度(mg/m3)	": "hydrocarbonsConc",
    "苯系物(mg/m3)": "benzeneSeries",
    "氧气含量(%)": "oxygenContent",
    "烟气温度(℃)": "gasTemp",
    "烟气压力(KPa)": "gasPressure",
    "烟气湿度(%)": "gasHumidity",
    "烟气流速(m/s)": "gasFlowRate",
    "烟气流量(m3)": "gasFlowTotal",
    "烟气流量(m3/s)": "gasFlow",
  }; //表头key
  int? id; //id
  int timeId = 0; //id
  int minute = 1; //分钟/小时
  List gist = [
    {'name':'检查要点','url':'checkStep','tidy':false},
    {'name':'取证要点','url':'forensicsPoint','tidy':false},
    {'name':'法律依据','url':'law','tidy':false},
  ];//要点
  /// 分页查询研判记录的异常数据
  /// type:
  void _findExceptionPage({typeStatusEnum? types}) async {
    var response = await Request().post(
      Api.url['findExceptionPage']+'?page=$_pageNo&size=10',
      data: {
        'id': id,
        "type": type,
      },
    );
    if (response['errCode'] == '10000') {
      _pageNo++;
      if (mounted) {
        if(types == typeStatusEnum.onRefresh) {
          // 下拉刷新
          _onRefresh(data: response['result'], total: response['result']['page']['total']);
        }else if(types == typeStatusEnum.onLoad) {
          // 上拉加载
          _onLoad(data: response['result'], total: response['result']['page']['total']);
        }
      }
      // allList = response['result']['page']['list'];
      // relExceptionFactorList = response['result']['relExceptionFactorList'];
      setState(() {});
    }
  }
  /// 下拉刷新
  /// 判断是否是企业端,剔除掉非企业端看的问题
  _onRefresh({required Map data,required int total}) {
    _total = total;
    allList = data['page']['list'];
    relExceptionFactorList = data['relExceptionFactorList'];
    _enableLoad = true;
    _pageNo = 2;
    _controller.resetLoadState();
    _controller.finishRefresh();
    if(allList.length >= total){
      _controller.finishLoad(noMore: true);
      _enableLoad = false;
    }
    setState(() {});
  }

  /// 上拉加载
  /// 当前数据等于总数据，关闭上拉加载
  _onLoad({required Map data,required int total}) {
    _total = total;
    allList.addAll(data['page']['list']);
    relExceptionFactorList.addAll(data['relExceptionFactorList']);
    if(allList.length >= total){
      _controller.finishLoad(noMore: true);
      _enableLoad = false;
    }
    _controller.finishLoadCallBack!();
    setState(() {});
  }

  ///表头
  ///item:表头
  List<Widget> topRow(item) {
    List<Widget> bodyRow = [];
    for (var i = 0; i < item.length; i++) {
      bodyRow.add(Expanded(
        child: Container(
          height: px(71),
          padding: EdgeInsets.symmetric(vertical: 8.0),
          alignment: Alignment.topCenter,
          child: Text('${item[i]}',
              style: TextStyle(
                  color: Color(0XFF969799),
                  fontSize: sp(24.0),
                  fontFamily: 'M')),
        ),
      ));
    }
    return bodyRow;
  }

  @override
  void initState() {
    // TODO: implement initState
    recordList = widget.arguments?['recordList']['recordList'] ?? [];
    for (var i = 0; i < recordList.length; i++) {
      timeList.add({"name": "第${i + 1}次", "id": i});
    }
    id = recordList[0]['id'];
    type = widget.arguments?['factorBelong'] == 1 ? 1 : 3;
    _findExceptionPage(types: typeStatusEnum.onRefresh,);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TaskCompon.topTitle(
            title: '判研结果',
            left: true,
            callBack: () {
              Navigator.pop(context);
            },
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
                _findExceptionPage(types: typeStatusEnum.onLoad,);
              }
                  : null,
              onRefresh: () async {
                _pageNo = 1;
                _findExceptionPage(types: typeStatusEnum.onRefresh,);
              },
              child: detail(),
            ),
          ),
        ],
      ),
    );
  }

  ///详情
  Widget detail() {
    return Container(
      padding: EdgeInsets.only(left: px(24), right: px(24)),
      child: Column(
        children: [
          Column(
            children: List.generate(gist.length, (i) => mainPoint(i: i)),
          ),
          Container(
            color: Colors.white,
            padding: EdgeInsets.only(
              left: px(8),right: px(12)
            ),
            child: FormCheck.rowItem(
                title: '研判数据:',
                child: DownInput(
                  data: timeList,
                  value: times,
                  callback: (val) {
                    times = val['name'];
                    timeId = val['id'];
                    id = recordList[val['id']]['id'];
                    if (minute == 1) {
                      type = widget.arguments?['factorBelong'] == 1 ? 1 : 3;
                    } else {
                      type = widget.arguments?['factorBelong'] == 1 ? 2 : 4;
                    }
                    _findExceptionPage(types: typeStatusEnum.onRefresh,);
                    setState(() {});
                  },
                )),
          ),
          Container(
            margin: EdgeInsets.only(top: px(24)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  child: Container(
                      margin: EdgeInsets.only(left: px(24), bottom: px(24)),
                      child: Text(
                        '分钟值',
                        style: TextStyle(
                            fontFamily: minute == 1 ? 'B' : "R",
                            fontSize: sp(minute == 1 ? 32 : 28)),
                      )),
                  onTap: () {
                    minute = 1;
                    type = widget.arguments?['factorBelong'] == 1 ? 1 : 3;
                    _findExceptionPage(types: typeStatusEnum.onRefresh,);
                    setState(() {});
                  },
                ),
                InkWell(
                  child: Container(
                      margin: EdgeInsets.only(left: px(24), bottom: px(24)),
                      child: Text(
                        '时均值',
                        style: TextStyle(
                            fontFamily: minute == 2 ? 'B' : "R",
                            fontSize: sp(minute == 2 ? 32 : 28)),
                      )),
                  onTap: () {
                    minute = 2;
                    type = widget.arguments?['factorBelong'] == 1 ? 2 : 4;
                    _findExceptionPage(types: typeStatusEnum.onRefresh,);
                    setState(() {});
                  },
                ),
              ],
            ),
          ),
          Visibility(
            visible: allList.isNotEmpty,
            child: Column(
              children: List.generate(allList.length,
                      (index) => factorCard(factorList: allList[index])),
            ),
            replacement: Column(
              children: [
                NoData(timeType: true, state: '未获取到数据!')
              ],
            ),
          ),
        ],
      ),
    );
  }

  ///异常卡片
  Widget factorCard({required Map factorList}) {
    return Container(
      padding: EdgeInsets.only(top: px(12), bottom: px(12), left: px(12)),
      margin: EdgeInsets.only(bottom: px(24)),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(bottom: px(12), top: px(12)),
            child: FormCheck.rowItem(
              title: '监测时间:',
              alignStart: true,
              child: Text(
                '${factorList['monitoringDateStr'].substring(0, 16)}',
              ),
            ),
          ),
          Column(
            children: List.generate(
                relExceptionFactorList.length,
                (i) => Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('${relExceptionFactorList[i]['factorName']}:',
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                                color: Color(0XFF969799),
                                fontSize: sp(28.0),
                                fontWeight: FontWeight.w500)),
                        Text(
                          ' ${factorList[companyHeader[relExceptionFactorList[i]['factorName']]] ?? '/'}',
                          style: TextStyle(
                              color: Color(0xff323233), fontSize: sp(28)),
                        ),
                      ],
                    )),
          ),
        ],
      ),
    );
  }

  ///要点
  Widget mainPoint({required int i}){
    return Container(
      margin: EdgeInsets.only(bottom: px(24)),
      padding: EdgeInsets.all(px(12)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(px(8.0))),
      ),
      child: InkWell(
        child: Column(
          children: [
            FormCheck.formTitle(
                gist[i]['name'],
                showUp: true,
                tidy: gist[i]['tidy'],
                onTaps: (){
                  gist[i]['tidy'] = !gist[i]['tidy'];
                  setState(() {});
                }
            ),
            Visibility(
              visible: gist[i]['tidy'],
              child: GestureDetector(
                child: Container(
                  width: Adapt.screenW(),
                  color: Colors.white,
                  child: HtmlWidget(
                    widget.arguments?['recordList'][gist[i]['url']] ?? '/',
                    // customWidgetBuilder: (element) {
                    //         if(element.innerHtml.contains('img')){
                    //           String url = '';
                    //           int first = element.innerHtml.indexOf('src="');
                    //           url = element.innerHtml.substring(first+5);
                    //           int two = url.indexOf('"');
                    //           url = url.substring(0,two);
                    //           if(url.contains('http:') == false){
                    //             url = Api.baseUrlApp + url;
                    //           }
                    //           return Image.network(url);
                    //         }
                    // },
                  ),
                ),
              ),
            ),
          ],
        ),
        onTap: (){
          gist[i]['tidy'] = !gist[i]['tidy'];
          setState(() {});
        },
      ),
    );
  }
}