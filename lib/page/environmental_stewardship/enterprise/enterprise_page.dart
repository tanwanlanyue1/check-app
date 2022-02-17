import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scet_check/api/api.dart';
import 'package:scet_check/api/request.dart';
import 'package:scet_check/model/provider/provider_details.dart';
import 'package:scet_check/page/environmental_stewardship/check/StatisticAnaly/Components/check_compon.dart';
import 'package:scet_check/page/environmental_stewardship/check/hiddenParame/Components/client_list_page.dart';
import 'package:scet_check/page/environmental_stewardship/check/hiddenParame/hidden_details.dart';
import 'package:scet_check/utils/screen/screen.dart';

class EnterprisePage extends StatefulWidget {
  const EnterprisePage({Key? key}) : super(key: key);

  @override
  _EnterprisePageState createState() => _EnterprisePageState();
}

class _EnterprisePageState extends State<EnterprisePage> {
  List tabBar = ["全园区","第一片区","第二片区","第三片区"];
  PageController pagesController = PageController();
  ProviderDetaild? _roviderDetaild;
  int pageIndex = 0;
  List companyList = [];

  // 获取全部公司
  void _getLatestData() async {
    var response = await Request().get(Api.url['all']);
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
    pagesController.addListener(() {
      if(pagesController.page != null){
        _roviderDetaild!.setOffest(pagesController.page!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _roviderDetaild = Provider.of<ProviderDetaild>(context, listen: true);
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: px(750),
            height: px(88),
            decoration: BoxDecoration(
              color: Color(0xff19191A),
              border: Border(bottom: BorderSide(color: Color(0xff19191A),width: 0.0)),),
          ),
          Container(
            width: px(730),
            height: px(74),
            margin: EdgeInsets.only(left:px(20),right: px(18)),
            child: Stack(
              children: [
                CheckCompon.bagColor(
                  pageIndex: pageIndex,
                  offestLeft:_roviderDetaild!.offestLeft,
                  right: 40
                ),
                CheckCompon.tabCut(
                    index: pageIndex,
                    tabBar: tabBar,
                    onTap: (i){
                      pageIndex = i;
                      pagesController.jumpToPage(i);
                      setState(() {});
                    }
                ),

              ],
            ),
          ),
          Expanded(
            child: PageView(
              controller: pagesController,
              children: [
                Visibility(
                  visible: companyList.isNotEmpty,
                  child: ClientListPage(
                    companyList: companyList,
                    callBack: (id,name){
                      print("id===$id");
                      print("name===$name");
                    },
                  ),
                ),
                HiddenDetails(
                  companyId: 1,
                  companyName:'公司',
                ),
                HiddenDetails(
                  companyId: 1,
                ),
                HiddenDetails(
                  companyId: 1,
                ),
              ],
              onPageChanged: (val){
                pageIndex = val;
                setState(() {});
              },
            ),
          ),
        ],
      ),
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
