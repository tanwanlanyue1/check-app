import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:scet_check/api/api.dart';
import 'package:scet_check/api/request.dart';
import 'package:scet_check/components/generalduty/search.dart';

import 'components/rectify_components.dart';

///排查清单页
///hiddenInventory:隐患清单数据
class InventoryPage extends StatefulWidget {
  List hiddenInventory;
  String companyId;
  InventoryPage({Key? key,required this.hiddenInventory,required this.companyId}) : super(key: key);

  @override
  _InventoryPageState createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  List hiddenInventory = []; //隐患清单数据
  List inventoryStatus = [
    {'name':'整改中','id':1},
    {'name':'已归档','id':2},
    {'name':'待审核','id':3},
    {'name':'审核已通过','id':4},
    {'name':'审核未通过','id':5},
    {'name':'未提交','id':6},
  ]; //清单的状态
  String companyId = '';//企业id
  DateTime? startTime;//选择开始时间
  DateTime? endTime;//选择结束时间
  Map<String,dynamic> typeStatus = {'name':'请选择','id':0};//默认类型
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();//侧边栏key
  /// 清单搜索筛选
  ///name:搜索名
  ///query:搜索的字段
  void _inventorySearch({Map<String,dynamic>? data}) async {
    var response = await Request().get(Api.url['inventoryList'],data: data,);
    if(response['statusCode'] == 200 && response['data'] != null) {
      setState(() {
        hiddenInventory = response['data']['list'];
      });
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    hiddenInventory = widget.hiddenInventory;
    companyId = widget.companyId;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant InventoryPage oldWidget) {
    // TODO: implement didUpdateWidget
    hiddenInventory = widget.hiddenInventory;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: ListView(
        padding: EdgeInsets.only(top: 0),
        children: [
          Search(
            bgColor: Color(0xffffffff),
            textFieldColor: Color(0xFFF0F1F5),
            search: (value) {
              _inventorySearch(data: {
                'regexp':true,//近似搜索
                'detail': value,
                // 'company.id':companyId,
              });
            },
            screen: (){
              _scaffoldKey.currentState!.openEndDrawer();
            },
          ),
          Column(
            children: List.generate(hiddenInventory.length, (i) => RectifyComponents.repertoireRow(
                company: hiddenInventory[i],
                i: i,
                callBack:()async{
                var res = await Navigator.pushNamed(context, '/stewardCheck',arguments: {
                    'uuid':hiddenInventory[i]['id'],
                    'company':false
                  });
                if(res != null){
                  _inventorySearch( data: {
                    'company.id':companyId,
                  });
                }else{
                  _inventorySearch( data: {
                    'company.id':companyId,
                  });
                }
                }
            )),
          ),
        ],
      ),
      endDrawer: RectifyComponents.endDrawers(
        context,
        typeStatus: typeStatus,
        status: inventoryStatus,
        startTime: startTime ?? DateTime.now(),
        endTime: endTime ?? DateTime.now(),
        callBack: (val){
          typeStatus['name'] = val['name'];
          typeStatus['id'] = val['id'];
          setState(() {});
        },
        timeBack: (val){
          startTime = val[0];
          endTime = val[1];
          setState(() {});
        },
        trueBack: (){
          if(startTime==null){
            _inventorySearch(
                data: {
                  'status':typeStatus['id'],
                  'company.id':companyId,
                }
            );
          }
          else{
            _inventorySearch(
                data: {
                  'status':typeStatus['id'],
                  'company.id':companyId,
                  'timeSearch':'createdAt',
                  'startTime':startTime,
                  'endTime':endTime,
                }
            );
          }
          Navigator.pop(context);
          setState(() {});
        },
      ),
    );
  }
}
