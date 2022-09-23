import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:scet_check/api/api.dart';
import 'package:scet_check/api/request.dart';
import 'package:scet_check/components/generalduty/no_data.dart';
import 'package:scet_check/page/module_steward/personal/components/task_compon.dart';
import 'package:scet_check/utils/easyRefresh/easy_refreshs.dart';
import 'package:scet_check/utils/screen/screen.dart';

///文件列表
/// arguments: type类型 1 国家，2 地方，3 行业
/// file: 文件数据
///  law:true//展示提交
class FileLists extends StatefulWidget {
  final Map? arguments;
  const FileLists({Key? key,this.arguments}) : super(key: key);

  @override
  _FileListsState createState() => _FileListsState();
}

class _FileListsState extends State<FileLists> {
  final EasyRefreshController _controller = EasyRefreshController(); // 上拉组件控制器
  List standardFile  = [];//文件数据
  String title = '国家标准文件';//标题
  String knowledgeTypeId = '';//类型id
  bool _enableLoad = true; // 是否开启加载
  int _pageNo = 1;//页码


  /// 知识库/法律文件
  void _getKnowledge({typeStatusEnum? type}) async {
    var response = await Request().post(Api.url['knowledge']+'?page=$_pageNo&size=10',
      data: {
        'knowledgeTypeId':knowledgeTypeId,
      }
    );
    if(response['errCode'] == '10000' && response['result']['list'] != null) {
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
      }
      setState(() {});
    }
  }
  // 下拉刷新
  _onRefresh({required List data,required int total}) {
    _pageNo = 2;
    standardFile = data;
    _controller.resetLoadState();
    _controller.finishRefresh();
    if(standardFile.length >= total){
      _controller.finishLoad(noMore: true);
      _enableLoad = false;
    }
    setState(() {});
  }

  /// 上拉加载
  /// 当前数据等于总数据，关闭上拉加载
  _onLoad({required List data, required int total}) {
    if(mounted){
      standardFile.addAll(data);
      _controller.finishLoadCallBack!();
      if(standardFile.length >= total){
        _enableLoad = false;
        _controller.finishLoad(noMore: true);
      }
      setState(() {});
    }
    _controller.finishLoadCallBack!();
  }
  @override
  void initState() {
    // TODO: implement initState
    title = widget.arguments?['name'] ?? '国家标准文件';
    knowledgeTypeId = widget.arguments?['id'] ?? '';
    _getKnowledge(type: typeStatusEnum.onRefresh,);
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
            child: EasyRefresh(
              enableControlFinishRefresh: true,
              enableControlFinishLoad: true,
              topBouncing: true,
              controller: _controller,
              taskIndependence: false,
              footer: footers(),
              header: headers(),
              onLoad: _enableLoad ? () async{
                _getKnowledge(type: typeStatusEnum.onLoad,);
              }: null,
              onRefresh: () async {
                _pageNo = 1;
                _getKnowledge(type: typeStatusEnum.onRefresh,);
              },
              child: standardFile.isNotEmpty ?
              rectifyRow():
              Column(
                children: [
                  NoData(timeType: true, state: '未获取到数据!')
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  ///文件列表
  ///callBack:回调
  Widget rectifyRow({Function? callBack}){
    return Column(
      children: List.generate(standardFile.length, (i) => Container(
        margin: EdgeInsets.only(top: px(4)),
        padding: EdgeInsets.only(left: px(32),top: px(24),bottom: px(24),right: px(20)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(px(4.0))),
        ),
        child: InkWell(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: px(40),
                width: px(40),
                margin: EdgeInsets.only(top: px(5)),
                alignment: Alignment.center,
                child: Text('${i+1}',style: TextStyle(color: Colors.white,fontSize: sp(22)),),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(px(20))),
                  gradient: LinearGradient(      //渐变位置
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight, //左下
                      stops: const [0.0, 1.0], //[渐变起始点, 渐变结束点]
                      //渐变颜色[始点颜色, 结束颜色]
                      colors: const [Color.fromRGBO(128, 163, 255, 0.7), Color.fromRGBO(77, 127, 255, 0.9)]
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: px(16),right: px(16)),
                  child: Text('${standardFile[i]["title"]}',style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),),
                ),
              ),
              SizedBox(
                width: px(40),
                height: px(40),
                child: Image.asset('lib/assets/icons/other/right.png'),
              ),
            ],
          ),
          onTap: (){
            Navigator.pushNamed(context, '/fillDetails',arguments: {'law': standardFile[i]['detail'],'title':standardFile[i]["title"],"fileList":standardFile[i]['fileList']});
          },
        ),
      )),
    );
  }
}
