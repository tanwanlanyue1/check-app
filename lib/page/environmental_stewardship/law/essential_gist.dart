import 'package:flutter/material.dart';
import 'package:scet_check/components/form_check.dart';
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
    {"text":"环境监测",
      'data':[
        {'name':'企业环境信息披露'},
        {'name':'排污信息公考'},
        {'name':'自行监测信息公开'},
      ]
    },
    {"text":"环保手续",
      'data':[
        {'name':'项目建设'},
        {'name':'排污许可'},
    ]},
    {"text":"环保信息",
      'data':[
        {'name':'企业环境信息披露'},
        {'name':'排污信息公考'},
        {'name':'自行监测信息公开'},
        {'name':'自行监测信息公开'},
        {'name':'自行监测信息公开'},
        {'name':'自行监测信息公开'},
        {'name':'自行监测信息公开'},
      ]},
    {"text":"工业固废管理",
      'data':[
        {'name':'企业环境信息披露'},
      ]
    },
    {"text":"大气污染防治",},
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

  //计算高度
  calculateHeight(int i){
    if( i == 0){
      return px(120);
    }else if( i == 1){
      return px(160);
    }else if(i == 2){
      return px(220);
    }else{
      return px(i * 75+60);
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
            title: mess[i]["text"],
            packup: mess[i]["packups"],
            index: i,
            data: mess[i]['data'],
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
  Widget messageCard({int? index,List? data,String? title,bool packup = false,Function? onTaps,}){
    return AnimatedCrossFade(
      duration: Duration(milliseconds: 500),
      crossFadeState:
      packup ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      firstChild: Container(
        height: calculateHeight(data?.length ?? 0),
        width: px(702),
        margin: EdgeInsets.only(top: px(20),left: px(20),right: px(20)),
        padding: EdgeInsets.all(px(24)),
        color: Colors.white,
        child: GestureDetector(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FormCheck.formTitle(
                index! < 9 ?
                "0${index + 1} $title":
                "${index + 1} $title",
                showUp: true,
                packups: packup,
                onTaps: onTaps,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(data?.length ?? 0, (i){
                    return Container(
                      margin: EdgeInsets.only(left: px(32),top: px(24)),
                      child: LawComponents.rowTwo(
                        child: Image.asset('lib/assets/icons/other/examine.png'),
                          textChild: Text('${data![i]['name']}',style: TextStyle(color: Color(0xff4D7FFF),fontSize: sp(26),fontFamily: 'R'),)
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
            FormCheck.formTitle(
              index < 9 ?
              "0${index + 1} $title":
              "${index + 1} $title",
                showUp: true,
                packups: packup,
                onTaps: onTaps,
            ),
          ],
        ),
      ),
    );
  }

}
