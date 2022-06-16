import 'package:flutter/material.dart';
import 'package:scet_check/page/module_steward/check/statisticAnaly/components/form_check.dart';
import 'package:scet_check/page/module_steward/personal/components/task_compon.dart';
import 'package:scet_check/utils/screen/screen.dart';

///指标详情页
///three 三级目录
///arguments:{"id",three:true}
class TargetDetails extends StatefulWidget {
  final Map? arguments;
  const TargetDetails({Key? key,this.arguments}) : super(key: key);

  @override
  _TargetDetailsState createState() => _TargetDetailsState();
}

class _TargetDetailsState extends State<TargetDetails> {
  String title = '原则性指标';
  int index = 0; //选择下标
  bool three = false;//三级目录

  @override
  void initState() {
    // TODO: implement initState
    three = widget.arguments?['three'] ?? false;
    super.initState();
  }

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
          Expanded(
            child: ListView(
              padding: EdgeInsets.only(top: 0),
              children: [
                details(),
                three ?
                levelFour() :
                Container(),
                !three ?
                _radio() :
                Container(),
                // revocation(),
              ],
            ),
          ),
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
          !three ?
          Container(
            margin: EdgeInsets.only(left: px(48)),
            child: FormCheck.rowItem(
              title: '四级指标',
              child: Text('清洁生产开展及验收'*3,style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),),
            ),
          ) :
          Container(),
        ],
      ),
    );
  }

  //四级指标
  Widget levelFour(){
    return Container(
      margin: EdgeInsets.only(left: px(24),right: px(24),top: px(24)),
      color: Colors.white,
      padding: EdgeInsets.only(bottom: px(24)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: px(24),top: px(24)),
            child: FormCheck.formTitle('四级指标'),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  margin: EdgeInsets.only(left: px(24),top: px(12)),
                  child: Text("1.强制审核的企业，按要求依次进行审核进行通过"*4,style: TextStyle(fontSize: sp(28)),),
                ),
              ),
              Container(
                width: px(230),
                margin: EdgeInsets.only(top: px(12)),
                child: Column(
                  children: [
                    SizedBox(
                      height: px(50),
                      child: Row(
                        children: [
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
                            "部分符合",
                            style: TextStyle(fontSize: sp(28)),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: px(50),
                      child: Row(
                        children: [
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
                            "符和",
                            style: TextStyle(fontSize: sp(28)),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: px(50),
                      child: Row(
                        children: [
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
                            "不符和",
                            style: TextStyle(fontSize: sp(28)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
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
                // setState(() {
                //   index = val!;
                // });
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
                // setState(() {
                //   index = val!;
                // });
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
                // setState(() {
                //   index = val!;
                // });
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
  ///按钮
  Widget revocation(){
    return Container(
      height: px(88),
      margin: EdgeInsets.only(top: px(24)),
      color: Colors.white,
      alignment: Alignment.center,
      child: GestureDetector(
        child: Container(
          width: px(240),
          height: px(56),
          alignment: Alignment.center,
          margin: EdgeInsets.only(left: px(40)),
          child: Text(
            '提交',
            style: TextStyle(
                fontSize: sp(24),
                fontFamily: "M",
                color: Color(0xff4D7FFF)),
          ),
          decoration: BoxDecoration(
            border: Border.all(width: px(2),color: Color(0xff4D7FFF)),
            borderRadius: BorderRadius.all(Radius.circular(px(28))),
          ),
        ),
        onTap: () {
          // Navigator.pop(context);
        },
      ),
    );
  }
}
