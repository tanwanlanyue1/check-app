import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:scet_check/api/api.dart';
import 'package:scet_check/api/request.dart';
import 'package:scet_check/components/generalduty/no_data.dart';
import 'package:scet_check/page/module_steward/personal/components/task_compon.dart';
import 'package:scet_check/utils/easyRefresh/easy_refreshs.dart';
import 'package:scet_check/utils/screen/screen.dart';


///对接任务列表
class AbutmentList extends StatefulWidget {
  Map? arguments;
  AbutmentList({Key? key,this.arguments}) : super(key: key);

  @override
  _AbutmentListState createState() => _AbutmentListState();
}

class _AbutmentListState extends State<AbutmentList> with SingleTickerProviderStateMixin{
  List taskList = [];//任务列表
  final EasyRefreshController _controller = EasyRefreshController(); // 上拉组件控制器

  @override
  void initState() {
    // TODO: implement initState
    _getTaskList();
    super.initState();
  }

  /// 查询任务列表
  /// status 1：待办 2：已办
  /// type 1:现场检查 2:表格填报
  void _getTaskList() async {
    var response = await Request().post(
      Api.url['houseTaskList'],
    );
    if(response['success'] == true) {
      taskList = response['result']['list'];
      setState(() {});
    }else{
      _getTaskList();
    }
  }

  @override
  void didUpdateWidget(covariant AbutmentList oldWidget) {
    // TODO: implement didUpdateWidget
    _getTaskList();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return EasyRefresh(
      enableControlFinishRefresh: true,
      enableControlFinishLoad: true,
      topBouncing: true,
      controller: _controller,
      taskIndependence: false,
      footer: footers(),
      header: headers(),
      onLoad: () async{
        _getTaskList();
      },
      onRefresh: () async {
        _getTaskList();
      },
      child: itemTask(),
    );
  }

  Widget itemTask(){
    return taskList.isNotEmpty ?
    ListView(
      padding: EdgeInsets.only(top: 0),
      children: List.generate(taskList.length, (i){
        return Container(
          margin: EdgeInsets.only(top: px(24),left: px(20),right: px(24)),
          padding: EdgeInsets.only(left: px(24),top: px(20),bottom: px(20)),
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
                        gradient: LinearGradient(//渐变位置
                            begin: Alignment.topLeft,end: Alignment.bottomRight,
                            stops: const [0.0, 1.0], //[渐变起始点, 渐变结束点]
                            colors: const [Color(0xff9EB9FF), Color(0xff608DFF)]//渐变颜色[始点颜色, 结束颜色]
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                      child: Text('${i+1}',style: TextStyle(color: Colors.white,fontSize: sp(28)),),
                    ),
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: Adapt.screenW()-px(250),
                      ),
                      child: Container(
                        margin: EdgeInsets.only(left: px(16),right: px(12)),
                        child: Text('${taskList[i]['taskItem']}',style: TextStyle(color: Color(0xff323233),fontSize: sp(30),fontFamily: "M",overflow: TextOverflow.ellipsis),),
                      ),
                    ),
                    Spacer(),
                    Container(
                      width: px(110),
                      height: px(48),
                      alignment: Alignment.center,
                      child: Text('',
                        style: TextStyle(color: Colors.white,fontSize: sp(22)),),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(bottom: px(16),top: px(24)),
                  child: Row(
                    children: [
                      SizedBox(
                        height: px(32),
                        child: Image.asset('lib/assets/icons/my/group.png'),
                      ),
                      Text('${taskList[i]['managerOpName']}',style: TextStyle(color: Color(0xff969799),fontSize: sp(26),overflow: TextOverflow.ellipsis),),
                    ],
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(
                      height: px(32),
                      width: px(32),
                      child: Image.asset('lib/assets/icons/check/sandClock.png'),
                    ),
                    Text('${taskList[i]['createDate']}',
                      style: TextStyle(color: Color(0xff969799),fontSize: sp(26)),),
                  ],
                ),
              ],
            ),
            onTap: (){
              Navigator.pushNamed(context, '/abutmentTask',arguments: {'id':taskList[i]['id']});
            },
          ),
        );
      }),
    ):Column(
      children: [
        NoData(timeType: true, state: '未获取到数据!')
      ],
    );
  }

}
