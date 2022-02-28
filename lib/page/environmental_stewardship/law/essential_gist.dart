import 'package:flutter/material.dart';
import 'package:scet_check/utils/screen/screen.dart';

import 'components/law_components.dart';

class EssentialGist extends StatefulWidget {
  const EssentialGist({Key? key}) : super(key: key);

  @override
  _EssentialGistState createState() => _EssentialGistState();
}

class _EssentialGistState extends State<EssentialGist> {
  late TextEditingController textEditingController;
  List<Map<String,dynamic>> mess = [
    {"text":"环境监测",},
    {"text":"环保手续",},
    {"text":"环保信息",},
    {"text":"工业固废管理"},
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    textEditingController = TextEditingController();
    for(var i=0; i< mess.length;i++){
      mess[i]['packups'] = false;
    }

  }
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.only(top: 0),
      children: [
        Container(
          height: px(88),
          color: Colors.white,
          alignment: Alignment.center,
          child: LawComponents.search(
              textEditingController: textEditingController,
              callBack: (val){}
          ),
        ),
        Column(
          children: List.generate(mess.length, (i) => messageCard(
            label: mess[i]["text"],
            packup: mess[i]["packups"],
            length: 3,
            onTaps: (){
              mess[i]["packups"] = !mess[i]["packups"];
              setState(() {});
            },
          ),
        ),
        ),
      ]
    );
  }

  //信息卡片
  Widget messageCard({int? index,int length = 2,String? label,bool packup = false,Function? onTaps,}){
    return AnimatedCrossFade(
      duration: Duration(milliseconds: 500),
      crossFadeState:
      packup ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      firstChild: Container(
        height: px(length * 95),
        width: px(702),
        margin: EdgeInsets.only(top: px(20),left: px(20),right: px(20)),
        padding: EdgeInsets.all(px(24)),
        color: Colors.white,
        child: GestureDetector(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              lebleText(
                title: label,
                onTaps: onTaps,
                packups: packup,
              ),
              Expanded(
                child: Column(
                  children: List.generate(3, (index){
                    return Container(
                      margin: EdgeInsets.only(left: px(32),top: px(24)),
                      child: LawComponents.rowTwo(
                        child: Image.asset('lib/assets/icons/other/examine.png'),
                          textChild: Text('企业环境信息披露',style: TextStyle(color: Color(0xff4D7FFF),fontSize: sp(26),fontFamily: 'R'),)
                      ),
                    );
                  }
                  ),
                ),
              ),
            ],
          ),
          onTap: (){
            Navigator.pushNamed(context, '/essentialList');
          },
        ),
      ),
      secondChild: Container(
        height: px(80),
        width: px(702),
        margin: EdgeInsets.only(top: px(20),left: px(20),right: px(20)),
        padding: EdgeInsets.all(px(12)),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            lebleText(
              title: label,
              onTaps: onTaps,
              packups: packup,
            ),
          ],
        ),
      ),
    );
  }

  //标签头部
  Widget lebleText({String? title,String? unfold,Function? onTaps,bool packups = true}){
    return Row(
      children: [
        Text("0${1} $title",
          style: TextStyle(
            fontSize: sp(30),
            color: Color(0xff323233),
            fontFamily: 'M'
          ),),
        Spacer(),
        GestureDetector(
          child: SizedBox(
            height: px(50),
            width: px(50),
            child: Icon(packups?
            Icons.keyboard_arrow_up:
            Icons.keyboard_arrow_down,
              color: Colors.grey,),
          ),
          onTap: (){
            onTaps?.call();
          },
        ),
      ],
    );
  }

}
