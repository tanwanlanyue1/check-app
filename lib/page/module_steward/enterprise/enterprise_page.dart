import 'package:flutter/material.dart';
import 'package:scet_check/api/api.dart';
import 'package:scet_check/api/request.dart';
import 'package:scet_check/page/module_steward/check/hiddenParame/Components/client_list_page.dart';
import 'package:scet_check/page/module_steward/check/statisticAnaly/components/layout_page.dart';
import 'package:scet_check/utils/screen/screen.dart';

///企业管理
class EnterprisePage extends StatefulWidget {
  const EnterprisePage({Key? key}) : super(key: key);

  @override
  _EnterprisePageState createState() => _EnterprisePageState();
}

class _EnterprisePageState extends State<EnterprisePage> {
  List tabBar = ["全园区","第一片区","第二片区","第三片区"];//tab
  int pageIndex = 0;//页面下标
  List companyList = [];//公司列表

  /// 获取全部公司
  void _getLatestData() async {
    // Map<String, dynamic> params = pageIndex == 0 ? {}: {'area':pageIndex};
    var response = await Request().get(Api.url['all'],
        // data: params
    );
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
                    Navigator.pushNamed(context, '/enterpriseDetails');
                  },
                ),
              ),
              Visibility(
                visible: companyList.isNotEmpty,
                child: ClientListPage(
                  companyList: companyList,
                  callBack: (id,name){
                    Navigator.pushNamed(context, '/enterpriseDetails');
                  },
                ),
              ),
              Visibility(
                visible: companyList.isNotEmpty,
                child: ClientListPage(
                  companyList: companyList,
                  callBack: (id,name){
                    Navigator.pushNamed(context, '/enterpriseDetails');
                  },
                ),
              ),
              Visibility(
                visible: companyList.isNotEmpty,
                child: ClientListPage(
                  companyList: companyList,
                  callBack: (id,name){
                    Navigator.pushNamed(context, '/enterpriseDetails');
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

}
