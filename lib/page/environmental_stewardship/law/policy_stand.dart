import 'package:flutter/material.dart';
import 'package:scet_check/utils/screen/screen.dart';
import 'package:scet_check/api/api.dart';
import 'package:scet_check/api/request.dart';

import 'components/law_components.dart';

class PolicyStand extends StatefulWidget {
  const PolicyStand({Key? key}) : super(key: key);

  @override
  _PolicyStandState createState() => _PolicyStandState();
}

class _PolicyStandState extends State<PolicyStand> {
  late TextEditingController textEditingController;
  List lawList = [];
  List nationList = [];//国家文件
  List icons = [
    {'name':'国家标准文件','icon':'lib/assets/icons/other/country.png'},
    {'name':'地方标准文件','icon':'lib/assets/icons/other/place.png'},
    {'name':'行业标准文件','icon':'lib/assets/icons/other/industry.png'},
    {'name':'通知文件','icon':'lib/assets/icons/other/inform.png'},
    {'name':'其他文件','icon':'lib/assets/icons/other/acronym.png'},
  ];

  // 获取法律文件
  void _getProfile() async {
    var response = await Request().get(Api.url['lawFile']);
    if(response['statusCode'] == 200) {
      lawList = response['data'];
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    _getProfile();
    textEditingController = TextEditingController();
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
          children: List.generate(icons.length, (i) => rowFile(i)),
        ),
      ],
    );
  }
//
  Widget rowFile(int i){
    return InkWell(
      child: Container(
        height: px(88),
        margin: EdgeInsets.only(top: px(20)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(px(4))),
        ),
        child: Row(
          children: [
            Container(
                width: px(64),
                height: px(64),
                margin: EdgeInsets.only(right: px(24),left: px(20)),
                child: Image.asset('${icons[i]['icon']}')
            ),
            Container(
                margin: EdgeInsets.only(right: px(24),left: px(20)),
                child: Text('${icons[i]['name']}',style: TextStyle(fontSize: sp(28),color: Color(0xff323233),fontFamily: 'R'),)
            ),
            Spacer(),
            Container(
                width: px(64),
                height: px(64),
                margin: EdgeInsets.only(right: px(24),left: px(20)),
                child: Image.asset('lib/assets/icons/other/right.png')
            ),
          ],
        ),
      ),
      onTap: (){
        nationList = [];
        for(var j=0; j<lawList.length; j++){
          if(lawList[j]['type'] == i){
            nationList.add(lawList[j]);
          }
        }
        Navigator.pushNamed(context, '/fileLists',arguments: {'type':i,'file':nationList});
      },
    );
  }

  //搜索
  Widget search(){
    return Container(
        height: px(56),
        margin: EdgeInsets.only(left: px(16),right: px(18)),
        decoration: BoxDecoration(
            // border: Border.all(color: Color.fromARGB(255, 225, 226, 230), width: 0.33),
            color: Color(0xffF5F6FA),
            borderRadius: BorderRadius.circular(4)),
        child: TextField(
          autofocus: false,
          onChanged: (value) {},
          controller: textEditingController,
          decoration: InputDecoration(
            border: InputBorder.none,
            prefixIcon: Image.asset(
              'lib/assets/icons/other/search.png',
              color: Color(0xffC8C9CC),),
            suffixIcon: Offstage(
              offstage: textEditingController.text.isEmpty,
              child: InkWell(
                onTap: () {
                  textEditingController.clear();
                },
                child: Icon(
                  Icons.cancel,
                  color: Colors.grey,
                ),
              ),
            ),
            hintText: '搜索',
            hintStyle: TextStyle(
                height: 0.8,
                fontSize: sp(24),
                color: Color(0xffC8C9CC),
                fontFamily: 'R',
                decorationStyle: TextDecorationStyle.dashed
            ),
          ),
        ),
      );
  }
}
