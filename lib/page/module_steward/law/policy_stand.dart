import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:scet_check/page/module_steward/check/hiddenParame/components/rectify_components.dart';
import 'package:scet_check/page/module_steward/personal/components/task_compon.dart';
import 'package:scet_check/utils/screen/screen.dart';
import 'package:scet_check/api/api.dart';
import 'package:scet_check/api/request.dart';

import 'components/law_components.dart';

///政策标准规范
///search：判断要不要输入框
///topBar: 头部
class PolicyStand extends StatefulWidget {
  bool search;
  bool topBar;
  PolicyStand({Key? key,this.search = true,this.topBar = false}) : super(key: key);

  @override
  _PolicyStandState createState() => _PolicyStandState();
}

class _PolicyStandState extends State<PolicyStand> {
  late TextEditingController textEditingController;//输入框控制器
  List lawList = []; //全部法律文件
  List typeList = [];//分类文件
  List? searchCompany;//搜索的法律文件

  /// 获取知识类型
  void _getFindKnowledgeSelector() async {
    var response = await Request().get(Api.url['findKnowledgeSelector'],);
    if(response['errCode'] == '10000') {
      typeList = response['result'];
      setState(() {});
    }
  }
  //选择图标
  String hierarchySelect(String? title) {
    switch(title) {
      case '国家标准文件':
        return 'lib/assets/icons/other/country.png';
      case '地方标准文件':
        return 'lib/assets/icons/other/place.png';
      case '行业标准文件':
        return 'lib/assets/icons/other/industry.png';
      default:
        return 'lib/assets/icons/other/acronym.png';
    }
  }
  ///搜索方法
  void _search(String text) {
    if(text.isNotEmpty){
      List list = typeList.where((v) {
        return v['typeName']!.toLowerCase().contains(text.toLowerCase());
      }).toList();
      searchCompany = list;
    }else{
      searchCompany = typeList;
    }
    setState(() {});
  }
  @override
  void initState() {
    super.initState();
    _getFindKnowledgeSelector();
    textEditingController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.only(top: 0),
        children: [
          widget.topBar ?
          TaskCompon.topTitle(
              title: '法律规范',
              home: true,
              colors: Colors.transparent,
              callBack: (){
                Navigator.pop(context);
              }
          ):Container(),
          widget.search ?
          Container(
            height: px(88),
            color: Colors.white,
            alignment: Alignment.center,
            child: LawComponents.search(
                textEditingController: textEditingController,
                callBack: (val){
                  _search(val);
                }
            ),
          ):
          Container(),
          Column(
            children: List.generate(
                searchCompany == null ? typeList.length : searchCompany!.length,(i) => rowFile(i)),
          ),
        ],
      ),
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
                child: Image.asset(hierarchySelect(typeList[i]['typeName']))
            ),
            Container(
                margin: EdgeInsets.only(right: px(24),left: px(20)),
                child: Text('${typeList[i]['typeName']}',style: TextStyle(fontSize: sp(28),color: Color(0xff323233),fontFamily: 'R'),)
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
        Navigator.pushNamed(context, '/fileLists',arguments: {'name':typeList[i]['typeName'],'id':typeList[i]['id'],'law': !widget.search});
      },
    );
  }
}
