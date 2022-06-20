import 'package:flutter/material.dart';
import 'package:scet_check/api/api.dart';
import 'package:scet_check/api/request.dart';
import 'package:scet_check/page/module_steward/check/hiddenParame/components/client_list_page.dart';
import 'package:scet_check/page/module_steward/personal/components/task_compon.dart';
import 'package:scet_check/utils/screen/screen.dart';

///指标分类页
class TargetClassifyPage extends StatefulWidget {
  const TargetClassifyPage({Key? key}) : super(key: key);

  @override
  _TargetClassifyPageState createState() => _TargetClassifyPageState();
}

class _TargetClassifyPageState extends State<TargetClassifyPage> {
  List companyList = [];//企业数据

  /// 获取企业统计
  /// district.id:片区id,切换请求的片区
  void _getCompany() async {
    var response = await Request().get(
        Api.url['companyList'],
        data: {
          // "sort":["CAST(substring_index(number,'-',1) AS SIGNED)","CAST(substring_index(number,'-',-1) AS SIGNED)"],
          // "order":["ASC","ASC"],
        }
    );
    if(response['statusCode'] == 200) {
      companyList = response["data"]['list'];
      setState(() {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    _getCompany();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TaskCompon.topTitle(
              title: '分类分级',
              home: true,
              colors: Colors.transparent,
              callBack: (){
                Navigator.pop(context);
              }
          ),
          Expanded(
            child: ClientListPage(
              companyList: companyList,
              sort: true,
              callBack: (id,name,user){
                Navigator.pushNamed(context, '/targetClassifyList',arguments: {'name':name,'id':id});
              },
            ),
          ),
        ],
      ),
    );
  }

}
