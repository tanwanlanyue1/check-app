import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scet_check/model/provider/provider_home.dart';
import 'package:scet_check/page/module_steward/personal/components/task_compon.dart';
import 'package:scet_check/utils/screen/screen.dart';

//填报任务的选择企业
class AbutmentEnterprise extends StatefulWidget {
  final Map? arguments;
  const AbutmentEnterprise({Key? key,this.arguments}) : super(key: key);


@override
  _AbutmentEnterpriseState createState() => _AbutmentEnterpriseState();
}

class _AbutmentEnterpriseState extends State<AbutmentEnterprise> {
  List companyList = [];//公司列表
  List? searchCompany;//搜索的公司列表
  HomeModel? _homeModel; //全局的焦点
  TextEditingController textEditingController = TextEditingController();//输入框控制器


  @override
  void initState() {
    super.initState();
    companyList = widget.arguments?['companyList'] ?? [];
  }
  ///判断是否选中方法
  pitchOn(Map company){
    if(_homeModel?.select.contains(company['id'])){
      _homeModel?.setSelect([]);
      _homeModel?.setSelectCompany([]);
    }else{
      _homeModel?.setSelect([]);
      _homeModel?.setSelectCompany([]);
      _homeModel?.select.add(company['id']);
      _homeModel?.selectCompany.add({'id':company['id'],"name":company['name']});
    }
    setState(() {});
  }

  ///搜索方法
  void _search(String text) {
    if(text.isNotEmpty){
      List list = companyList.where((v) {
        return v['name']!.toLowerCase().contains(text.toLowerCase());
      }).toList();
      searchCompany = list;
    }else{
      searchCompany = companyList;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    _homeModel = Provider.of<HomeModel>(context, listen: true);
    return Scaffold(
      body: Column(
        children: [
          TaskCompon.topTitle(
              title: '选择企业',
              left: true,
              child: GestureDetector(
                child: Container(
                  height: px(56),
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(right: px(12)),
                  child: Text(
                    '确定',
                    style: TextStyle(
                        fontSize: sp(28),
                        fontFamily: "R",
                        color: Color(0xff323233)),
                  ),
                ),
                onTap: (){
                  Navigator.pop(context,true);
                },
              ),
              callBack: (){
                Navigator.pop(context);
              }
          ),
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
            child: ListView(
              padding: EdgeInsets.only(top: 0),
              children: List.generate(
                  searchCompany == null ? companyList.length : searchCompany!.length, (i) => sourceList(company: searchCompany == null ? companyList[i] : searchCompany![i])),
            ),
          ),
        ],
      ),
    );
  }
  ///数据来源列表
  Widget sourceList({required Map company}){
    return Container(
      margin: EdgeInsets.only(top: px(20),left: px(20),right: px(20)),
      padding: EdgeInsets.only(left: px(16),top: px(20),bottom: px(20)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(px(4.0))),
      ),
      child: InkWell(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    width: px(40),
                    height: px(40),
                    margin: EdgeInsets.only(right: px(2)),
                    child: Checkbox(
                        value: _homeModel?.select.contains(company['id']),
                        onChanged: (bool? onTops){
                          pitchOn(company);
                        })
                ),
                Expanded(
                  child: Text(' ${company['name']}'),
                )
              ],
            ),
          ],
        ),
        onTap: (){
          pitchOn(company);
        },
      ),
    );
  }
}
