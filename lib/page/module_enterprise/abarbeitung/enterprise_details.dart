import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:scet_check/api/api.dart';
import 'package:scet_check/api/request.dart';
import 'package:scet_check/components/generalduty/toast_widget.dart';
import 'package:scet_check/page/module_login/login_page.dart';
import 'package:scet_check/page/module_steward/check/hiddenParame/components/drop_down_menu_route.dart';
import 'package:scet_check/page/module_steward/check/hiddenParame/components/rectify_components.dart';
import 'package:scet_check/routers/router_animate/router_animate.dart';
import 'package:scet_check/utils/screen/screen.dart';
import 'package:scet_check/utils/storage/data_storage_key.dart';
import 'package:scet_check/utils/storage/storage.dart';

///企业详情
/// 问题未整改列表/清单下的问题
class EnterpriseDetails extends StatefulWidget {
  const EnterpriseDetails({Key? key}) : super(key: key);

  @override
  _EnterpriseDetailsState createState() => _EnterpriseDetailsState();
}

class _EnterpriseDetailsState extends State<EnterpriseDetails> {
  String companyName = '';//公司名
  String companyId = '';//公司id
  bool show = false; //筛选的显示
  int repertoire = 0; //0-渲染清单 1-问题列表
  bool check = false; //申报,排查
  List companyDetails = [];//公司问题详情
  GlobalKey _globalKey = GlobalKey(); //获取盒子位置

  /// 获取企业下的问题
  ///companyId:公司id
  ///page:第几页
  ///size:每页多大
  ///andWhere:查询的条件
  void _getProblem() async {
    Map<String,dynamic> data = {
      'page':1,
      'size':50,
      'andWhere':"company.id='$companyId'",
    };
    var response = await Request().get(Api.url['problemList'],data: data,);
    if(response['statusCode'] == 200 && response['data'] != null) {
      setState(() {
        companyDetails = response['data']['list'];
      });
    }
  }
  /// 获取企业下的清单
  ///companyId:公司id
  ///page:第几页
  ///size:每页多大
  ///andWhere:查询的条件
  void _getInventoryList() async {
    Map<String,dynamic> data = {
      'page':1,
      'size':50,
      'andWhere':"company.id='$companyId'",
    };
    var response = await Request().get(Api.url['inventoryList'],data: data,);
    if(response['statusCode'] == 200 && response['data'] != null) {
      setState(() {
        companyDetails = response['data']['list'];
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    companyId =  jsonDecode(StorageUtil().getString(StorageKey.PersonalData))['companyId'];
    companyName =  jsonDecode(StorageUtil().getString(StorageKey.PersonalData))['company']['name'];
    _getInventoryList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Color(0xffF5F6FA),
      child: Stack(
        children: [
          Column(
            children: [
              topBar(),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.only(top: 0),
                  children: [
                    repertoire == 0 && companyDetails.isNotEmpty?
                    Column(
                      children: List.generate(companyDetails.length, (i) => RectifyComponents.repertoireRow(
                          company: companyDetails[i],
                          i: i,
                          callBack:(){
                            Navigator.pushNamed(context, '/enterprisInventory',
                                arguments: {'uuid':companyDetails[i]['id'],'company':false});
                          }
                      )),
                    ):
                    Column(
                      children: List.generate(companyDetails.length, (i) => RectifyComponents.rectifyRow(
                          company: companyDetails[i],
                          i: i,
                          detail: true,
                          review: false,
                          callBack:(){
                            Navigator.pushNamed(context, '/abarbeitungFrom',arguments: {'id':companyDetails[i]['id']});
                          }
                      )),
                    ),
                  ],
                ),
              )
            ],
          ),
          Visibility(
            visible: show,
            child: Container(
              margin: EdgeInsets.only(top: Adapt.padTopH()+px(88)),
              color: Colors.black12,
            ),
          ),
        ],
      ),
    );
  }

  ///头部
  ///筛选
  ///companyDetails要清空并重新赋值
  Widget topBar(){
    return Container(
      color: Colors.white,
      height: px(88),
      key: _globalKey,
      margin: EdgeInsets.only(top: Adapt.padTopH()),
      child: Row(
        children: [
          InkWell(
            child: Container(
              height: px(40),
              width: px(41),
              margin: EdgeInsets.only(left: px(20)),
              child: Image.asset('lib/assets/icons/other/chevronLeft.png',fit: BoxFit.fill,),
            ),
            onTap: (){
              ToastWidget.showDialog(
                  msg: '是否退出当前账号？',
                  ok: (){
                    StorageUtil().remove(StorageKey.Token);
                    Navigator.of(context).pushAndRemoveUntil(
                        CustomRoute(LoginPage()), (router) => false);
                  }
              );
              // Navigator.pop(context);
            },
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Text(companyName,style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),),
            ),
          ),
          GestureDetector(
            child: Container(
              width: px(40),
              height: px(41),
              margin: EdgeInsets.only(right: px(20)),
              child: Image.asset('lib/assets/images/home/filtrate.png'),
            ),
            onTap: () async{
              show = true;
              RenderBox renderBox = _globalKey.currentContext!.findRenderObject() as RenderBox;
              Rect box = renderBox.localToGlobal(Offset.zero) & renderBox.size;
              setState(() {});
              var res = await Navigator.push(
                  context,
                  DropDownMenuRoute(
                    position: box, //传递盒子的大小
                    selectIndex: repertoire,
                    callback:(val) {
                      companyDetails = [];
                      if(val == 0){
                        _getInventoryList();
                      }else{
                        _getProblem();
                      }
                      repertoire = val;
                      setState(() {});
                    },
                  )
              );
              if(res == null){
                show = false;
                setState(() {});
              }
            },
          ),
        ],
      ),
    );
  }

}
