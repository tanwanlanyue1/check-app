import 'package:azlistview/azlistview.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:lpinyin/lpinyin.dart';
import 'package:scet_check/utils/screen/screen.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import 'language_helper.dart';
import 'models.dart';

class ClientListPage extends StatefulWidget {
  final int? fromType;
  final List? companyList;
  Function? callBack;
  ClientListPage({
    Key? key,
    this.fromType,
    this.callBack,
    this.companyList,
  }) : super(key: key);

  @override
  _ClientListPageState createState() => _ClientListPageState();
}

class _ClientListPageState extends State<ClientListPage> {

  /// 控制器滚动或跳转到特定项目。
  final ItemScrollController itemScrollController = ItemScrollController();
  List<Languages> originList = [];
  List<Languages> dataList = [];

  late TextEditingController textEditingController;

  @override
  void initState() {
    super.initState();
    LanguageHelper.languageMap = LanguageHelper.getResource(widget.companyList);
    LanguageHelper.language = widget.companyList;
    textEditingController = TextEditingController();
    loadData();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  void loadData() async {
    originList = LanguageHelper.getGithubLanguages()!.map((v) {
      Languages model = Languages.fromJson(v.toJson());
      String tag = model.name?.substring(0, 1).toUpperCase() ?? "#";
      if (RegExp("[A-Z]").hasMatch(tag)) {
        model.tagIndex = tag;
      } else {
        model.tagIndex = "#";
      }
      return model;
    }).toList();
    _handleList(originList);
  }

  void _handleList(List<Languages> list) {
    dataList.clear();
    if (ObjectUtil.isEmpty(list)) {
      setState(() {});
      return;
    }
    // 将中文也进行排序
    for (int i = 0, length = list.length; i < length; i++) {
      String pinyin = PinyinHelper.getPinyinE(list[i].name ?? "#");
      String tag = pinyin.substring(0, 1).toUpperCase();
      // list[i].name = pinyin; //变成拼音
      if (RegExp("[A-Z]").hasMatch(tag)) {
        list[i].tagIndex = tag;
      } else {
        list[i].tagIndex = "#";
      }
    }
    dataList.addAll(list);

    // A-Z sort.
    SuspensionUtil.sortListBySuspensionTag(dataList);

    //显示sus标签。
    SuspensionUtil.setShowSuspensionStatus(dataList);

    setState(() {});

    if (itemScrollController.isAttached) {
      itemScrollController.jumpTo(index: 0);
    }
  }

  Widget getSusItem(BuildContext context, String? tag, {double susHeight = 40}) {
    return Container(
      height: px(52),
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(left: 16.0),
      color: Colors.white,
      alignment: Alignment.centerLeft,
      child: Text(
        '$tag',
        softWrap: false,
        style: TextStyle(
          fontSize: sp(24),
          color: Color(0xFF969799),
        ),
      ),
    );
  }

  //渲染
  Widget getListItem(BuildContext context, Languages model,
      {double susHeight = 50}) {
    return GestureDetector(
      child: Container(
        color: Colors.white,
        height: px(84),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: px(40),
              height: px(40),
              margin: EdgeInsets.only(left: px(16),right: px(12)),
              decoration: BoxDecoration(
                color: Color(0xff72B1ED),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
            ),
            Expanded(
              child: Text("${model.name} ",style: TextStyle(color: Color(0xFF323233),fontSize: sp(24),),),
            )
          ],
        ),
      ),
      onTap: (){
          widget.callBack?.call(model.id,model.name);
        // widget.callBack!(model.region);
        // setState(() {});
      },
    );
  }

  //搜索方法
  void _search(String text) {
    if (ObjectUtil.isEmpty(text)) {
      _handleList(originList);
    } else {
      List<Languages> list = originList.where((v) {
        return v.name!.toLowerCase().contains(text.toLowerCase());
        // return v.color.toString().toLowerCase().contains(text.toLowerCase());
      }).toList();
      _handleList(list);
    }
  }

  //搜索某一个字段
  // void _labSearch(String text) {
  //   if (ObjectUtil.isEmpty(text)) {
  //     _handleList(originList);
  //   } else {
  //     List<Languages> list = originList.where((v) {
  //       return v.region.toString().toLowerCase().contains(text.toLowerCase());
  //     }).toList();
  //     _handleList(list);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(left: px(20),right: px(18)),
        padding: EdgeInsets.only(top: px(24)),
      color: Colors.white,
      child:Column(
        children: [
          Container(
            height: px(56),
            margin: EdgeInsets.only(left: px(16),right: px(18)),
            decoration: BoxDecoration(
                border: Border.all(
                    color: Color.fromARGB(255, 225, 226, 230), width: 0.33),
                color: Color(0xffF5F6FA),
                borderRadius: BorderRadius.circular(4)),
            child: TextField(
              autofocus: false,
              onChanged: (value) {
                _search(value);
              },
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
                      // _search('');
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
                    fontSize: sp(28),
                    color: Color(0xffC8C9CC),
                    decorationStyle: TextDecorationStyle.dashed
                ),
              ),
            ),
          ),
          Expanded(
            child: AzListView(
              data: dataList,
              physics: AlwaysScrollableScrollPhysics(),
              itemCount: dataList.length,
              itemBuilder: (BuildContext context, int index) {
                Languages model = dataList[index];
                return getListItem(context, model);
              },
              itemScrollController: itemScrollController,
              susItemBuilder: (BuildContext context, int index) {
                Languages model = dataList[index];
                return getSusItem(context, model.getSuspensionTag());
              },
              indexBarWidth: px(45),
              indexBarAlignment: Alignment.topRight,
              indexBarOptions: IndexBarOptions(
                needRebuild: true,
                indexHintWidth: 98,
                indexHintHeight: 98,
                indexHintAlignment: Alignment.centerRight,
                indexHintTextStyle: TextStyle(fontSize: 24.0, color: Color(0xff374766)),
                indexHintOffset: Offset(-30, 0),
              ),

            ),
          ),
        ],
      )
    );
  }
}
