import 'package:flutter/material.dart';
import 'package:scet_check/api/api.dart';
import 'package:scet_check/api/request.dart';
import 'package:scet_check/page/environmental_stewardship/check/hiddenParame/Components/client_list_page.dart';
import 'package:scet_check/page/environmental_stewardship/check/statisticAnaly/components/layout_page.dart';
import 'package:scet_check/utils/screen/screen.dart';

///企业管理
class EnterprisePage extends StatefulWidget {
  const EnterprisePage({Key? key}) : super(key: key);

  @override
  _EnterprisePageState createState() => _EnterprisePageState();
}

class _EnterprisePageState extends State<EnterprisePage> {
  List tabBar = ["全园区","第一片区","第二片区","第三片区"];
  int pageIndex = 0;
  List companyList = [];

  // 获取全部公司
  void _getLatestData() async {
    Map<String, dynamic> params = pageIndex == 0 ? {}: {'area':pageIndex};
    var response = await Request().get(Api.url['all'],data: params);
    if(response['code'] == 200) {
      setState(() {
        companyList = response["data"];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getLatestData();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: px(750),
          height: px(88),
          decoration: BoxDecoration(
            color: Color(0xff19191A),
            border: Border(bottom: BorderSide(color: Color(0xff19191A),width: 0.0)),),
        ),
        Expanded(
          child: LayoutPage(
            tabBar: tabBar,
            pageBody: [
              Visibility(
                visible: companyList.isNotEmpty,
                child: ClientListPage(
                  companyList: companyList,
                  callBack: (id,name){
                    print("id===$id");
                    // Navigator.pushNamed(context, '/hiddenDetails');
                  },
                ),
              ),
              Visibility(
                visible: companyList.isNotEmpty,
                child: ClientListPage(
                  companyList: companyList,
                  callBack: (id,name){
                    print("id===$id");
                  },
                ),
              ),
              Visibility(
                visible: companyList.isNotEmpty,
                child: ClientListPage(
                  companyList: companyList,
                  callBack: (id,name){
                    print("id===$id");
                  },
                ),
              ),
              Visibility(
                visible: companyList.isNotEmpty,
                child: ClientListPage(
                  companyList: companyList,
                  callBack: (id,name){
                    print("id===$id");
                  },
                ),
              ),
              // HiddenDetails(
              //   companyId: 1,
              //   companyName: '公司',
              // ),
            ],
          ),
        ),
      ],
    );
  }

  //头部切换
  Widget tabCut({int index = 0,List? tabBar,Function? onTap}){
    return SizedBox(
      height: px(84),
      child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(tabBar?.length ?? 0, (i){
            return GestureDetector(
              child:  Container(
                height: px(64),
                alignment:  Alignment.centerRight,
                child: Text(
                  i == 3 ?
                  "${tabBar![i]}   " :
                  "${tabBar![i]}",
                  style: TextStyle(
                    fontSize: sp(28),
                    color: index == i ? Color(0xff84A7FF):Color(0xff969799),
                    fontFamily: 'R',
                    fontWeight: index == i ? FontWeight.bold : FontWeight.w100,
                  ),
                ),
              ),
              onTap: (){
                onTap?.call(i);
              },
            );}
          )),
    );
  }
}
