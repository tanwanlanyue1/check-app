import 'package:flutter/material.dart';
import 'package:scet_check/api/api.dart';
import 'package:scet_check/api/request.dart';
import 'package:scet_check/page/module_steward/check/hiddenParame/components/rectify_components.dart';
import 'package:scet_check/utils/screen/screen.dart';

import 'components/law_components.dart';

///排查要点列表
///arguments:{id:依据id]
class EssentialList extends StatefulWidget {
  final Map? arguments;
  const EssentialList ({Key? key,this.arguments}) : super(key: key);

  @override
  _EssentialListState createState() => _EssentialListState();
}

class _EssentialListState extends State<EssentialList> {
  Map gistData = {};//一级数据
  List gistChildren = [];//二级数据
  /// 获取排查依据
  ///
  void _getBasis() async {
    var response = await Request().get(Api.url['basisList'],
        data: {
          "level":2,
          'parentId':gistData['id']
        }
    );
    if(response['statusCode'] == 200 && response['data'] != null) {
      gistChildren =  response['data']['list'];
      setState(() {});
    }
  }
  @override
  void initState() {
    // TODO: implement
    gistData = widget.arguments?['data'];
    _getBasis();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          RectifyComponents.topBar(
              title: '${gistData['name']}',
              callBack: (){
                Navigator.pop(context);
              }
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.only(top: 0,bottom: px(24)),
              children: List.generate(gistChildren.length, (i) => essentList(gistChildren[i])),
            ),
          )
        ],
      ),
    );
  }

///列表
 Widget essentList(Map data){
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(left: px(20),right: px(20),top: px(20)),
      padding: EdgeInsets.only(top: px(24),left: px(24),bottom: px(24)),
      child: Column(
        children: [
          LawComponents.rowTwo(
            child: Image.asset('lib/assets/icons/other/examine.png'),
            textChild: Text('${data['name']}',style: TextStyle(color: Color(0xff4D7FFF),fontSize: sp(26),fontFamily: 'R'),),
          ),
          Column(
            children:List.generate(data['children'].length, (j){
              return InkWell(
                child: Container(
                  margin: EdgeInsets.only(left: px(35),right: px(24),top: px(10),bottom: px(5)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: px(26),
                        height: px(26),
                        margin: EdgeInsets.only( top: px(5)),
                        child: Center(
                          child: Text('${j+1}',style: TextStyle(fontSize: sp(18)),),
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                              Radius.circular(px(24))
                          ),
                          border: Border.all(width: px(1.0),color: Color(0Xff646566)),
                        ),
                      ),
                      Expanded(
                        child: Text(' ${data['children'][j]['name']}',style: TextStyle(color: Color(0xff646566),fontSize: sp(26),fontFamily: 'R'),),
                      ),
                      SizedBox(
                        height: px(40),
                        width: px(40),
                        child: Image.asset('lib/assets/icons/other/nextPage.png'),
                      ),
                    ],
                  ),
                ),
                onTap: (){
                  Navigator.pushNamed(context, '/essentialDetails',arguments: {'id':data['children'][j]['id']});
                },
              );
            }
            ),
          )
        ],
      ),
    );
 }
}
