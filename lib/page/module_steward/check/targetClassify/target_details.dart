import 'package:flutter/material.dart';
import 'package:scet_check/page/module_steward/check/statisticAnaly/components/form_check.dart';
import 'package:scet_check/page/module_steward/personal/components/task_compon.dart';
import 'package:scet_check/utils/screen/screen.dart';

///指标详情页
///arguments:{}
class TargetDetails extends StatefulWidget {
  Map? arguments;
  TargetDetails({Key? key,this.arguments}) : super(key: key);

  @override
  _TargetDetailsState createState() => _TargetDetailsState();
}

class _TargetDetailsState extends State<TargetDetails> {
  String title = '原则性指标';
  int index = 0; //选择下标

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TaskCompon.topTitle(
              title: '企业名称',
              left: true,
              callBack: (){
                Navigator.pop(context);
              }
          ),
          details(),
          _radio(),
        ],
      ),
    );
  }

  //详情
  Widget details(){
    return Container(
      margin: EdgeInsets.only(left: px(24),right: px(24),top: px(24)),
      color: Colors.white,
      padding: EdgeInsets.only(bottom: px(24)),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(left: px(24),top: px(24)),
            child: FormCheck.formTitle('$title'),
          ),
          Container(
            margin: EdgeInsets.only(left: px(48)),
            child: FormCheck.rowItem(
              title: '一级指标',
              child: Text('清洁生产',style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: px(48)),
            child: FormCheck.rowItem(
              title: '二级指标',
              child: Text('清洁生产开展及验收',style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: px(48)),
            child: FormCheck.rowItem(
              title: '三级指标',
              child: Text('清洁生产开展及验收'*3,style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),),
            ),
          ),
        ],
      ),
    );
  }

  ///单选
  Widget _radio() {
    return Container(
      margin: EdgeInsets.only(left: px(24),right: px(24)),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: px(24)),
            child: Text(
              "相符性：",
              style: TextStyle(fontSize: sp(28)),
            ),
          ),
          SizedBox(
            width: px(70),
            child: Radio(
              value: 0,
              groupValue: index,
              onChanged: (int? val) {
                setState(() {
                  index = val!;
                });
              },
            ),
          ),
          Text(
            "符合",
            style: TextStyle(fontSize: sp(28)),
          ),
          SizedBox(
            width: px(70),
            child: Radio(
              value: 1,
              groupValue: index,
              onChanged: (int? val) {
                setState(() {
                  index = val!;
                });
              },
            ),
          ),
          Text(
            "不符合",
            style: TextStyle(fontSize: sp(28)),
          ),
          SizedBox(
            width: px(70),
            child: Radio(
              value: 2,
              groupValue: index,
              onChanged: (int? val) {
                setState(() {
                  index = val!;
                });
              },
            ),
          ),
          Text(
            "部分符合",
            style: TextStyle(fontSize: sp(28)),
          )
        ],
      ),
    );
  }
}
