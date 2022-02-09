import 'package:flutter/material.dart';
import 'package:scet_check/utils/screen/screen.dart';

class Status extends StatelessWidget {
  final int? status;
  Status(this.status);
  @override
  Widget build(BuildContext context) {
    return  Container(
      width: px(100),
      height: px(36),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: _color(status),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(px(15)),
            bottomRight: Radius.circular(px(15)),
          )
      ),
      child: Text(
        _str(status),
        style: TextStyle(
            color: Colors.white,
            fontSize: sp(22)
        ),
      ),
    );
  }
  String _str(int? status){
    switch(status){
      case 0 : return '未提交';
      case 1 : return '已提交';
      case 2 : return '待审核';
      case 3 : return '已审核';
      case 4 : return '未通过';
      default: return '未提交';
    }
  }

  Color _color(int? status){
    switch(status){
      case 0 : return Colors.red;
      case 1 : return Colors.green;
      case 2 : return Colors.black12;
      case 3 : return Colors.green;
      case 4 : return Colors.black12;
      default: return Colors.red;
    }
  }
}


