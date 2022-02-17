import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:scet_check/api/api.dart';
import 'package:scet_check/api/request.dart';
import 'package:scet_check/model/provider/provider_details.dart';
import 'package:scet_check/page/environmental_stewardship/check/hiddenParame/hidden_details.dart';
import 'package:scet_check/utils/screen/screen.dart';

import '../StatisticAnaly/Components/check_compon.dart';
import 'Components/client_list_page.dart';

class HiddenParameter extends StatefulWidget {
  const HiddenParameter({Key? key}) : super(key: key);

  @override
  _HiddenParameterState createState() => _HiddenParameterState();
}

class _HiddenParameterState extends State<HiddenParameter> {

  List tabBar = ["全园区","第一片区","第二片区","第三片区"];
  final PageController pagesController = PageController();
  int _pageIndex = 0;
  int _companyId = 0;//公司
  String _companyName = '';//公司名称
  late ProviderDetaild _ProviderDetaild;
  List companyList = [];//全部公司数据
  bool details = false;//详情

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
    // TODO: implement initState
  _ProviderDetaild = context.read<ProviderDetaild>();
  _getLatestData();
  pagesController.addListener(() {
    if(pagesController.page != null){
      _ProviderDetaild.setOffest(pagesController.page!);
    }
  });
  super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: px(730),
          height: px(74),
          margin: EdgeInsets.only(left:px(20),right: px(18)),
          child:Stack(
            children: [
              CheckCompon.bagColor(
                  pageIndex: _pageIndex,
                  offestLeft: _ProviderDetaild.offestLeft,
                  right: 40
              ),
              CheckCompon.tabCut(
                  index: _pageIndex,
                  tabBar: tabBar,
                  onTap: (i){
                    _pageIndex = i;
                    pagesController.jumpToPage(i);
                    // Navigator.pushNamed(context, '/logIn');
                    setState(() {});
                  }
              ),
            ],
          )
        ),
        Container(
          height: px(24),
          margin: EdgeInsets.only(left:px(20),right: px(20)),
          color: Colors.white,
        ),
        Expanded(
          child: PageView(
            physics: NeverScrollableScrollPhysics(),
            controller: pagesController,
            children: [
              !details ?
              Visibility(
                visible: companyList.isNotEmpty,
                child: ClientListPage(
                  companyList: companyList,
                  callBack: (id,name){
                    _companyId = id;
                    _companyName = name;
                    details = true;
                    setState(() {});
                  },
                ),
              ):
              HiddenDetails(
                companyId: _companyId,
                companyName: _companyName,
                callBack: (){
                  details = false;
                  setState(() {});
                },
              ),
              Container(),
              Container(),
              Container(),
            ],
          ),
        ),
      ],
    );
  }

}
