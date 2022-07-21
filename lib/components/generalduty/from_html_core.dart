import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:scet_check/page/module_steward/personal/components/task_compon.dart';
import 'package:scet_check/utils/screen/screen.dart';

///富文本页面
class FromHtmlCore extends StatefulWidget {
  final Map? arguments;
  const FromHtmlCore({Key? key,this.arguments}) : super(key: key);

  @override
  _FromHtmlCoreState createState() => _FromHtmlCoreState();
}

class _FromHtmlCoreState extends State<FromHtmlCore> {

  String htmlUrl = '''''';//富文本内容

  @override
  void initState() {
    // TODO: implement initState
    htmlUrl = widget.arguments?['htmlUrl'] ?? '';
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
          Expanded(
            child: ListView(
              padding: EdgeInsets.only(top: 0),
              children: [
                Container(
                  width: Adapt.screenW(),
                  color: Colors.white,
                  child: HtmlWidget(htmlUrl),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

}
