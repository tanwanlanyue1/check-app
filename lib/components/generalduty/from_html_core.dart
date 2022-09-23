import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:scet_check/components/generalduty/upload_file.dart';
import 'package:scet_check/page/module_steward/personal/components/task_compon.dart';
import 'package:scet_check/utils/screen/screen.dart';

///富文本页面
///name:标题
///htmlUrl;富文本
///fileList:文件附件
class FromHtmlCore extends StatefulWidget {
  final Map? arguments;
  const FromHtmlCore({Key? key,this.arguments}) : super(key: key);

  @override
  _FromHtmlCoreState createState() => _FromHtmlCoreState();
}

class _FromHtmlCoreState extends State<FromHtmlCore> with SingleTickerProviderStateMixin{
  String htmlUrl = '''''';//富文本内容
  List tabBar = ["文件详情","文件附件"];//tab列表
  List fileList = [];//文件附件
  late TabController _tabController; //TabBar控制器

  @override
  void initState() {
    // TODO: implement initState
    htmlUrl = widget.arguments?['htmlUrl'] ?? '';
    fileList = widget.arguments?['fileList'] ?? [];
    _tabController = TabController(vsync: this,length: tabBar.length);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant FromHtmlCore oldWidget) {
    // TODO: implement didUpdateWidget
    if(widget.arguments != oldWidget.arguments){
      htmlUrl = widget.arguments?['htmlUrl'] ?? '';
    }
    super.didUpdateWidget(oldWidget);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TaskCompon.topTitle(
              title: '${widget.arguments?['name']}',
              left: true,
              callBack: (){
                  Navigator.pop(context);
              }
          ),
          Container(
            height: px(64.0),
            color: Colors.white,
            child: DefaultTabController(
              length: tabBar.length,
              child: TabBar(
                  controller: _tabController,
                  indicatorSize: TabBarIndicatorSize.label,
                  indicatorPadding: EdgeInsets.only(bottom: 5.0),
                  isScrollable: false,
                  labelColor: Colors.blue,
                  labelStyle: TextStyle(fontSize: sp(30.0),fontFamily: 'M'),
                  unselectedLabelColor: Color(0xff969799),
                  unselectedLabelStyle: TextStyle(fontSize: sp(30.0),fontFamily: 'R'),
                  indicatorColor:Colors.blue,
                  indicatorWeight: px(2),
                  tabs: tabBar.map((item) {
                    return Tab(text: '  $item  ');
                  }).toList()
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
                controller: _tabController,
                children: <Widget>[
                  ListView(
                    padding: EdgeInsets.only(top: 0),
                    children: [
                      Container(
                        width: Adapt.screenW(),
                        color: Colors.white,
                        padding: EdgeInsets.only(left: px(12),right: px(12),bottom: px(12)),
                        child: HtmlWidget(htmlUrl),
                      )
                    ],
                  ),
                  ListView(
                    padding: EdgeInsets.only(top: 0),
                    children: [
                      Container(
                        padding: EdgeInsets.only(top: px(24),left: px(24),right: px(24)),
                        color: Colors.white,
                        child: UploadFile(
                          url: '/',
                          amend: false,
                          abutment: true,
                          icon: true,
                          fileList: fileList,
                        ),
                      ),
                    ],
                  ),
                ]
            ),
          ),
        ],
      ),
    );
  }

}
