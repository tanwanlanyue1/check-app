import 'package:flutter/material.dart';
import 'package:scet_check/utils/screen/adapter.dart';
import 'package:scet_check/utils/screen/screen.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

///pdf页
///pathPDF ： PDF地址
class PDFView extends StatelessWidget {
  final String? pathPDF;
   const PDFView({Key? key, this.pathPDF}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(Adapt.screenW(), px(Adapter.topBarHeight)),
        child: AppBar(
            title: Text(
                'pdf报告查看',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: sp(Adapter.appBarFontSize)
                )
            ),
            elevation: 0,
            centerTitle: true
        ),
      ),
      body: Visibility(
        visible: pathPDF?.isNotEmpty ?? false,
        child: SfPdfViewer.network(
          '$pathPDF',
        ),
      ),
    );
  }
}