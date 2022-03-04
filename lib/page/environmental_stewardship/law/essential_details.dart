import 'package:flutter/material.dart';
import 'package:scet_check/components/image_widget.dart';
import 'package:scet_check/page/environmental_stewardship/check/hiddenParame/components/rectify_components.dart';
import 'package:scet_check/utils/screen/screen.dart';

import 'components/law_components.dart';

class EssentialDetails extends StatefulWidget {
  const EssentialDetails({Key? key}) : super(key: key);

  @override
  _EssentialDetailsState createState() => _EssentialDetailsState();
}

class _EssentialDetailsState extends State<EssentialDetails> {
  TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.only(top: 0),
        children: [
          RectifyComponents.topBar(
              title: '排查要点详情',
              right: true,
              callBack: (){
                Navigator.pop(context);
              }
          ),
          Column(
            children: List.generate(3, (index) => checkFrom()),
          ),
          remark(),
          example(),
        ],
      ),
    );
  }
  //排查表单
  Widget checkFrom(){
    return Container(
      padding: EdgeInsets.only(left: px(30),top: px(26),bottom: px(12)),
      color: Colors.white,
      child: Column(
        children: [
          LawComponents.rowTwo(
            child: Image.asset('lib/assets/icons/other/rhombus.png'),
              textChild: Text('排查要点',style: TextStyle(color: Color(0xff969799),fontSize: sp(26),fontFamily: 'R'),)
          ),
          Container(
            padding: EdgeInsets.only(top: px(5),bottom: px(20)),
            margin: EdgeInsets.only(left: px(32),right: px(24),),
            child: Text('核对企业所有项目皮肤，核查是否存在未批先建。'*3,style: TextStyle(color: Color(0xff323233),fontSize: sp(26),fontFamily: 'R'),),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(width: px(1.0),color: Color(0X99A1A6B3))),
            ),
          )
        ],
      ),
    );
  }

  //备注
  Widget remark(){
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(left: px(30),top: px(26),bottom: px(12)),
      child: Column(
        children: [
          LawComponents.rowTwo(
              child: Image.asset('lib/assets/icons/other/rhombus.png'),
              textChild: Text('备注',style: TextStyle(color: Color(0xff969799),fontSize: sp(26),fontFamily: 'R'),)
          ),
          LawComponents.uniline(
              hint: '备注填写现场排查经验，非规范要求。',
              textEditingController: textEditingController,
              callBack: (val){
              }
          ),
        ],
      ),
    );
  }

  //示例
  Widget example(){
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(left: px(30),top: px(26),bottom: px(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LawComponents.rowTwo(
              child: Image.asset('lib/assets/icons/other/rhombus.png'),
              textChild: Text('示例图片',style: TextStyle(color: Color(0xff969799),fontSize: sp(26),fontFamily: 'R'),)
          ),
          Container(
            margin: EdgeInsets.only(left: px(32),top: px(20),bottom: px(20)),
            child: Text('名称:示例名称',style: TextStyle(color: Color(0xff969799),fontSize: sp(26),fontFamily: 'R'),),
          ),
          ImageWidget(
            imageList: [],
          )
        ],
      ),
    );
  }
}
