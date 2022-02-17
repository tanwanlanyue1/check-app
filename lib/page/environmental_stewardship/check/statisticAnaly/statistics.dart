import 'package:flutter/material.dart';
import 'package:scet_check/utils/screen/screen.dart';

import 'Components/same_point_table.dart';

//统计
class Statistics extends StatefulWidget {
  String? type;
  List? tableBody;
  Function? callBack;//下一页
  Function? callPrevious;//上一页
  Statistics({Key? key,this.tableBody,this.type,this.callBack,this.callPrevious}) : super(key: key);

  @override
  _StatisticsState createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {

  List _tableBody = [];//表单


  @override
  void initState() {
    super.initState();
    _tableBody = widget.tableBody ?? [];
  }

  @override
  void didUpdateWidget(Statistics oldWidget) {
    super.didUpdateWidget(oldWidget);
    _tableBody = widget.tableBody ?? [];
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: px(12),right: px(12)),
      child: ListView(
        children: [
          SamePointTable(
            tableHeader: widget.type ?? '',
            tableBody: _tableBody,
            callBack: (){
              widget.callBack?.call();
            },
            callPrevious: (){
              widget.callPrevious?.call();
            },
          ),
        ],
      ),
    );
  }
}