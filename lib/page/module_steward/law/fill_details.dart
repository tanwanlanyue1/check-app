import 'package:flutter/material.dart';
import 'package:scet_check/components/generalduty/from_html_core.dart';
import 'package:scet_check/page/module_steward/check/hiddenParame/components/rectify_components.dart';
import 'package:scet_check/utils/screen/screen.dart';

///文件详情
///  sub:true//展示提交
///  law:文件数据
class FillDetails extends StatefulWidget {
  final Map? arguments;
  const FillDetails({Key? key,this.arguments}) : super(key: key);

  @override
  _FillDetailsState createState() => _FillDetailsState();
}

class _FillDetailsState extends State<FillDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FromHtmlCore(
        arguments: {
          "name":widget.arguments?['title'],
          "htmlUrl":widget.arguments?['law'],
          "fileList":widget.arguments?['fileList'] ?? [],
        },
      ),
    );
  }
}
