import 'package:azlistview/azlistview.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:lpinyin/lpinyin.dart';
import 'package:provider/provider.dart';
import 'package:scet_check/model/provider/provider_home.dart';
import 'package:scet_check/utils/screen/screen.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'language_helper.dart';
import 'models.dart';

///城市/公司列表
///callBack: 回调
///companyList: 城市数据
class ClientListPage extends StatefulWidget {
  final List? companyList;
  Function? callBack;
  bool sort;//不排序
  bool select;//多选
  ClientListPage({
    Key? key,
    this.callBack,
    this.companyList,
    this.sort = false,
    this.select = false,
  }) : super(key: key);

  @override
  _ClientListPageState createState() => _ClientListPageState();
}

class _ClientListPageState extends State<ClientListPage> {
  /// 控制器滚动或跳转到特定项目。
  final ItemScrollController itemScrollController = ItemScrollController();
  List<Languages> originList = [];//字母列表
  List<Languages> dataList = [];//数据列表
  HomeModel? _homeModel; //全局的焦点
  late TextEditingController textEditingController; //输入框控制器
  List district = [];//片区

  @override
  void initState() {
    super.initState();
    LanguageHelper.language = widget.companyList;
    textEditingController = TextEditingController();
    // loadData();
    sortNumber();
  }

  @override
  void didUpdateWidget(covariant ClientListPage oldWidget) {
    // TODO: implement didUpdateWidget
    LanguageHelper.language = widget.companyList;
    textEditingController = TextEditingController();
    sortNumber();
    // loadData();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  ///处理数据
  ///添加 tag，重新排序
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

  ///处理数据
  ///编号重新排序
  void sortNumber(){
    originList = LanguageHelper.getGithubLanguages()!.map((v) {
      Languages model = Languages.fromJson(v.toJson());
      // String tag = model.number?.substring(0, 1) ?? "#";
      // model.tagIndex = toChinese(int.parse(tag));
      model.tagIndex = model.district?.name ?? "#";
      return model;
    }).toList();
    // dataList = originList;
    // dataList.sort((a,b) {
    //   if(a.number.split('-')[0] == b.number.split('-')[0]){
    //     return int.parse(a.number.split('-')[1]).compareTo(int.parse(b.number.split('-')[1]));
    //   }else{
    //     // print('a${a.number},b===${b.number}');
    //     return int.parse(a.number.split('-')[0]).compareTo(int.parse(b.number.split('-')[0]));
    //   }
    // });
    _handleList(originList);
  }

  ///处理列表
  void _handleList(List<Languages> list) {
    dataList.clear();
    if (ObjectUtil.isEmpty(list)) {
      setState(() {});
      return ;
    }
    // 将中文也进行排序
    for (int i = 0, length = list.length; i < length; i++) {
      list[i].tagIndex = list[i].district?.name ?? "#";
      // String tag = list[i].number?.substring(0, 1) ?? "#";
      // String pinyin = PinyinHelper.getPinyinE(list[i].name ?? "#");
      // String tag = pinyin.substring(0, 1).toUpperCase();
      // // list[i].name = pinyin; //变成拼音
      // if (RegExp("[A-Z]").hasMatch(tag)) {
      //   list[i].tagIndex = tag;
      // } else {
      //   list[i].tagIndex = "#";
      // }
    }
    dataList.addAll(list);
    // A-Z sort.
    // SuspensionUtil.sortListBySuspensionTag(dataList);

    //显示sus标签。
    SuspensionUtil.setShowSuspensionStatus(dataList);
    setState(() {});

    if (itemScrollController.isAttached) {
      itemScrollController.jumpTo(index: 0);
    }
  }
  ///搜索方法
  void _search(String text) {
    if (ObjectUtil.isEmpty(text)) {
      setState(() {});
      _handleList(originList);
    } else {
      List<Languages> list = originList.where((v) {
        return v.name!.toLowerCase().contains(text.toLowerCase());
        // return v.color.toString().toLowerCase().contains(text.toLowerCase());
      }).toList();
      _handleList(list);
    }
  }

  @override
  Widget build(BuildContext context) {
    _homeModel = Provider.of<HomeModel>(context, listen: true);
    return Container(
      margin: EdgeInsets.only(left: px(20),right: px(18)),
      // padding: EdgeInsets.only(top: px(24)),
      // color: Colors.white,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(left: px(16),right: px(18),top: px(12),bottom: px(12)),
            decoration: BoxDecoration(
                border: Border.all(color: Color.fromARGB(255, 225, 226, 230), width: 0.33),
                color: Colors.white,
                borderRadius: BorderRadius.circular(4)),
            child: SizedBox(
              height: px(64),
              child: Center(
                child: TextField(
                  autofocus: false,
                  focusNode: _homeModel!.verifyNode,
                  onChanged: (value) {
                    _search(value);
                  },
                  controller: textEditingController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    filled: true,
                    fillColor: Color(0XffF5F6FA),
                    prefixIcon: Image.asset(
                      'lib/assets/icons/other/search.png',
                      color: Color(0xffC8C9CC),),
                    suffixIcon: Offstage(
                      offstage: textEditingController.text.isEmpty,
                      child: InkWell(
                        onTap: () {
                          textEditingController.clear();
                          _search('');
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
            ),
          ),
          Expanded(
            child: Visibility(
              visible: !widget.sort,
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
                  indexHintWidth: px(52),
                  indexHintHeight: px(52),
                  indexHintAlignment: Alignment.centerRight,
                  indexHintDecoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(Radius.circular(6)),
                  ),
                  indexHintTextStyle: TextStyle(fontSize: sp(24), color: Color(0xff374766)),
                  indexHintOffset: Offset(-30, 0),
                ),
              ),
              replacement: AzListView(
                data: dataList,
                // physics: AlwaysScrollableScrollPhysics(),
                itemCount: dataList.length,
                itemBuilder: (BuildContext context, int index) {
                  Languages model = dataList[index];
                  // return getListItem(context, model);
                  return getItemSort(context, model);
                },
                itemScrollController: itemScrollController,
                susItemBuilder: (BuildContext context, int index) {
                  Languages model = dataList[index];
                  return getSusItem(context, model.getSuspensionTag());
                },
                indexBarData: [],
              ),
            ),
          ),
        ],
      )
    );
  }

  ///标签组件
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
          fontSize: sp(26),
          color: Color(0xFF4D7FFF),
        ),
      ),
    );
  }

  ///渲染每一项
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
              alignment: Alignment.center,
              child: Text('${model.name?.substring(0,1)}',style: TextStyle(color: Colors.white,fontSize: sp(22),)),
            ),
            Expanded(
              child: Text("${model.name} ",style: TextStyle(color: Color(0xFF323233),fontSize: sp(24),),),
            )
          ],
        ),
      ),
      onTap: (){
        widget.callBack?.call(model.id,model.name,model.user);
      },
    );
  }

  ///不根据首字母拼音排序
  Widget getItemSort(BuildContext context, Languages model,
      {double susHeight = 50}) {
    return  Column(
      children: [
        GestureDetector(
          child: Container(
            color: widget.select ? (_homeModel?.select.contains(model.id) ? Colors.blue : Colors.white) : Colors.white,
            height: px(84),
            // margin: EdgeInsets.only(bottom: px(4),top: px(12)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(left: px(18),right: px(12)),
                  child: Text(model.number ?? '',style: TextStyle(color: Color(0xFF323233),fontSize: sp(28),)),
                ),
                Expanded(
                  child: Text("${model.name} ",style: TextStyle(color: Color(0xFF323233),fontSize: sp(28),),),
                )
              ],
            ),
          ),
          onTap: (){
            if(widget.select){
              if(_homeModel?.select.contains(model.id)){
                _homeModel?.select.remove(model.id);
                int index =  _homeModel?.selectCompany.indexWhere((item) =>  item['id'] == model.id);
                if(index != -1) {
                  _homeModel?.selectCompany.removeAt(index);
                }
              }else{
                _homeModel?.select.add(model.id);
                _homeModel?.selectCompany.add({'id':model.id!,"name":model.name});
                // _homeModel?.selectCompany.add({'id':model.id!,"user":model.toJson()['user'],"name":model.name});
              }
            }else{
              widget.callBack?.call(model.id,model.name);
              // widget.callBack?.call(model.id,model.name,model.toJson()['user']);
            }
            setState(() {});
          },
        ),
      ],
    );
  }

}