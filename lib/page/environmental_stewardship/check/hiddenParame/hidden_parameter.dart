import 'package:flutter/material.dart';
import 'package:scet_check/api/api.dart';
import 'package:scet_check/api/request.dart';
import 'package:scet_check/page/environmental_stewardship/check/hiddenParame/hidden_details.dart';
import 'package:scet_check/page/environmental_stewardship/check/statisticAnaly/components/layout_page.dart';
import 'package:scet_check/utils/screen/screen.dart';

import 'Components/client_list_page.dart';

class HiddenParameter extends StatefulWidget {
  const HiddenParameter({Key? key}) : super(key: key);

  @override
  _HiddenParameterState createState() => _HiddenParameterState();
}

class _HiddenParameterState extends State<HiddenParameter> {

  List tabBar = ["全园区","第一片区","第二片区","第三片区"];
  final PageController pagesController = PageController();
  int _companyId = 0;//公司
  String _companyName = '';//公司名称
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
  _getLatestData();
  super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutPage(
      tabBar: tabBar,
      pageBody: [
        Column(
          children: [
            Container(
              height: px(24),
              margin: EdgeInsets.only(left:px(20),right: px(20)),
              color: Colors.white,
            ),
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
            ),
          ],
        ),
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
      ],
    );
  }

}
