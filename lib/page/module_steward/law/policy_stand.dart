import 'package:flutter/material.dart';
import 'package:scet_check/utils/screen/screen.dart';
import 'package:scet_check/api/api.dart';
import 'package:scet_check/api/request.dart';

import 'components/law_components.dart';

///政策标准规范
class PolicyStand extends StatefulWidget {
  const PolicyStand({Key? key}) : super(key: key);

  @override
  _PolicyStandState createState() => _PolicyStandState();
}

class _PolicyStandState extends State<PolicyStand> {
  late TextEditingController textEditingController;//输入框控制器
  List lawList = []; //全部法律文件
  List nationList = [];//分类文件
  ///分类的图标
  List icons = [
    {'name':'国家标准文件','icon':'lib/assets/icons/other/country.png'},
    {'name':'地方标准文件','icon':'lib/assets/icons/other/place.png'},
    {'name':'行业标准文件','icon':'lib/assets/icons/other/industry.png'},
    {'name':'通知文件','icon':'lib/assets/icons/other/inform.png'},
    {'name':'其他文件','icon':'lib/assets/icons/other/acronym.png'},
  ];

  /// 获取法律文件
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

  ///文件行
  ///i: 每一项的下标
  ///方法拿到每一项的分类数据，并赋值传承到下一个页面
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
        nationList = [];//清空分类文件
        for(var j=0; j<lawList.length; j++){
          if(lawList[j]['type'] == i){
            nationList.add(lawList[j]);
          }
        }
        Navigator.pushNamed(context, '/fileLists',arguments: {'type':i,'file':nationList});
      },
    );
  }
}
