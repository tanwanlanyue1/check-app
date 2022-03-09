import 'package:flutter/material.dart';
import 'package:scet_check/page/module_steward/check/hiddenParame/components/rectify_components.dart';
import 'package:scet_check/utils/screen/screen.dart';

import 'components/law_components.dart';

///排查要点列表
class EssentialList extends StatefulWidget {
  const EssentialList({Key? key}) : super(key: key);

  @override
  _EssentialListState createState() => _EssentialListState();
}

class _EssentialListState extends State<EssentialList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          RectifyComponents.topBar(
              title: '环保手续-排查要点',
              callBack: (){
                Navigator.pop(context);
              }
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.only(top: 0,bottom: px(24)),
              children: List.generate(3, (index) => essentList()),
            ),
          )
        ],
      ),
    );
  }

///列表
 Widget essentList(){
    return InkWell(
      child: Container(
        color: Colors.white,
        margin: EdgeInsets.only(left: px(20),right: px(20),top: px(20)),
        padding: EdgeInsets.only(top: px(24),left: px(24)),
        child: Column(
          children: [
            LawComponents.rowTwo(
              child: Image.asset('lib/assets/icons/other/examine.png'),
              textChild: Text('项目建设',style: TextStyle(color: Color(0xff4D7FFF),fontSize: sp(26),fontFamily: 'R'),),
            ),
            Column(
              children:List.generate(3, (index){
                return Container(
                  margin: EdgeInsets.only(left: px(35),right: px(24),top: px(10),bottom: px(5)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: px(26),
                        height: px(26),
                        margin: EdgeInsets.only( top: px(5)),
                        child: Center(
                          child: Text('${index+1}',style: TextStyle(fontSize: sp(18)),),
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                              Radius.circular(px(24))
                          ),
                          border: Border.all(width: px(1.0),color: Color(0Xff646566)),
                        ),
                      ),
                      Expanded(
                        child: Text(' 项目建设'*12,style: TextStyle(color: Color(0xff646566),fontSize: sp(26),fontFamily: 'R'),),
                      ),
                      // Spacer(),
                      SizedBox(
                        height: px(40),
                        width: px(40),
                        child: Image.asset('lib/assets/icons/other/nextPage.png'),
                      ),
                    ],
                  ),
                );
              }
              ),
            )
          ],
        ),
      ),
      onTap: (){
        Navigator.pushNamed(context, '/essentialDetails');
      },
    );
 }
}
