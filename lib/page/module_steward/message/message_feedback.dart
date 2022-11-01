import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:scet_check/api/api.dart';
import 'package:scet_check/api/request.dart';
import 'package:scet_check/components/generalduty/no_data.dart';
import 'package:scet_check/components/generalduty/upload_file.dart';
import 'package:scet_check/page/module_steward/check/statisticAnaly/components/form_check.dart';
import 'package:scet_check/page/module_steward/personal/components/task_compon.dart';
import 'package:scet_check/utils/easyRefresh/easy_refreshs.dart';
import 'package:scet_check/utils/screen/screen.dart';

///消息反馈列表
class MessageFeedback extends StatefulWidget {
  Map? arguments;
  MessageFeedback({Key? key, this.arguments}) : super(key: key);

  @override
  State<MessageFeedback> createState() => _MessageFeedbackState();
}

class _MessageFeedbackState extends State<MessageFeedback> {
  final EasyRefreshController _controller = EasyRefreshController(); // 上拉组件控制器
  int _pageNo = 1; // 当前页码
  int _total = 10; // 总条数
  bool _enableLoad = true; // 是否开启加载
  List feedbackList = [];//反馈列表

  /// 查询反馈列表
  ///page:第几页
  ///size:每页多大
  /// noticeId 公告id
  _getFeedback({typeStatusEnum? type}) async {
    var response = await Request().post(Api.url['findNoticeReadPage']+'?page=$_pageNo&size=10',data: {
      "noticeId":widget.arguments?['id']
    });
    if(response['errCode'] == '10000'){
      Map _data = response['result'];
      _pageNo++;
      if (mounted) {
        if(type == typeStatusEnum.onRefresh) {
          // 下拉刷新
          _onRefresh(data: _data['records'], total: _data['total']);
        }else if(type == typeStatusEnum.onLoad) {
          // 上拉加载
          _onLoad(data: _data['records'], total: _data['total']);
        }
      }
      setState(() {});
    }
  }

  /// 下拉刷新
  /// 判断是否是企业端,剔除掉非企业端看的问题
  _onRefresh({required List data,required int total}) {
    _total = total;
    _enableLoad = true;
    _pageNo = 2;
    feedbackList = data;
    _controller.resetLoadState();
    _controller.finishRefresh();
    if(data.length >= total){
      _controller.finishLoad(noMore: true);
      _enableLoad = false;
    }
    setState(() {});
  }

  /// 上拉加载
  /// 当前数据等于总数据，关闭上拉加载
  _onLoad({required List data,required int total}) {
    _total = total;
    feedbackList.addAll(data);
    if(data.length >= total){
      _controller.finishLoad(noMore: true);
      _enableLoad = false;
    }
    _controller.finishLoadCallBack!();
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    _getFeedback();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TaskCompon.topTitle(
              title: '反馈列表',
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
                _getFeedback(
                    type: typeStatusEnum.onLoad,
                );
              }: null,
              onRefresh: () async {
                _pageNo = 1;
                _getFeedback(
                    type: typeStatusEnum.onRefresh,
                );
              },
              child: itemTask(),
            ),
          ),
        ],
      ),
    );
  }

  ///管理员查看反馈列表
  Widget feedback({required Map feed}){
    print("feed===$feed");
    return Container(
      margin: EdgeInsets.only(left: px(24),right: px(24),top: px(24)),
      padding: EdgeInsets.only(left: px(24),right: px(24),bottom: px(24)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(px(8.0))),
      ),
      child: Column(
        children: [
          FormCheck.rowItem(
            title: '反馈人:',
            child: Text('${feed['objName']}',style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),),
          ),
          FormCheck.rowItem(
            title: '反馈内容:',
            child: Text('${feed['feedback']}',style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),),
          ),
          FormCheck.rowItem(
            title: '反馈附件:',
            alignStart: true,
            child: UploadFile(
              url: '/',
              amend: false,
              abutment: true,
              fileList: feed['fileList'] ?? [],
            ),
          ),
        ],
      ),
    );
  }

  ///任务列表
  Widget itemTask(){
    return !feedbackList.isNotEmpty ?
    ListView(
      padding: EdgeInsets.only(top: 0),
      children: List.generate(feedbackList.length, (i){
        return feedback(feed: feedbackList[i] ?? {});
      }),
    ) :
    Column(
      children: [
        NoData(timeType: true, state: '未获取到数据!')
      ],
    );
  }
}
