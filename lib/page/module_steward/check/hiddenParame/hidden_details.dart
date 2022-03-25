import 'dart:convert';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:scet_check/api/api.dart';
import 'package:scet_check/api/request.dart';
import 'package:scet_check/components/generalduty/date_range.dart';
import 'package:scet_check/components/generalduty/down_input.dart';
import 'package:scet_check/components/generalduty/loading.dart';
import 'package:scet_check/components/generalduty/search.dart';
import 'package:scet_check/components/generalduty/toast_widget.dart';
import 'package:scet_check/components/generalduty/upload_image.dart';
import 'package:scet_check/page/module_steward/check/hiddenParame/components/rectify_components.dart';
import 'package:scet_check/page/module_steward/check/hiddenParame/problem_page.dart';
import 'package:scet_check/page/module_steward/check/statisticAnaly/components/form_check.dart';
import 'package:scet_check/utils/screen/screen.dart';
import 'package:scet_check/utils/storage/data_storage_key.dart';
import 'package:scet_check/utils/storage/storage.dart';
import 'package:uuid/uuid.dart';

import 'inventory_page.dart';

///隐患台账企业排查清单
///arguments:{companyId:公司id，companyName：公司名称,uuid:uuid}
class HiddenDetails extends StatefulWidget {
  Map? arguments;
  HiddenDetails({Key? key,this.arguments, }) : super(key: key);

  @override
  _HiddenDetailsState createState() => _HiddenDetailsState();
}

class _HiddenDetailsState extends State<HiddenDetails>  with SingleTickerProviderStateMixin{
  List tabBar = ["隐患问题","排查清单"];//tab列表
  List companyDetails = [];//公司问题列表
  List inventoryDetails = [];//公司清单列表
  List imgDetails = []; //上传图片
  String companyName = '';//公司名
  String companyId = '';//公司id
  Uuid uuid = Uuid(); //uuid
  String _uuid = ''; //uuid
  Position? position; //定位
  String userName = ''; //用户名
  String userId = ''; //用户id
  String checkName = ''; //排查人员
  final DateTime _dateTime = DateTime.now();
  DateTime solvedAt = DateTime.now().add(Duration(days: 7));//整改期限
  DateTime reviewedAt = DateTime.now().add(Duration(days: 14));//复查期限
  late TabController _tabController; //TabBar控制器

  /// 获取企业下的问题
  ///companyId:公司id
  ///page:第几页
  ///size:每页多大
  ///andWhere:查询的条件
  ///添加一个状态 check-提交到企业,environment-提交到环保局
  void _getProblem() async {
    Map<String,dynamic> data = {
      // 'page':1,
      // 'size':50,
      'company.id':companyId,
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
      'company.id':companyId,
    };
    var response = await Request().get(Api.url['inventoryList'],data: data,);
    if(response['statusCode'] == 200 && response['data'] != null) {
      setState(() {
        inventoryDetails = response['data']['list'];
      });
    }
  }

  /// 签到清单
  /// id: uuid
  /// checkPersonnel: 检查人员
  /// checkType: 检查类型: 1,管家排查
  /// images: [],上传的图片
  /// longitude: 经度
  /// latitude: 纬度度
  /// userId: 用户id
  /// companyId: 公司id
  /// solvedAt: 整改期限
  /// reviewedAt: 复查期限
  void _setInventory() async {
    if (position?.longitude == null) {
      ToastWidget.showToastMsg('请获取坐标！');
    } else if (checkName.isEmpty) {
      ToastWidget.showToastMsg('请输入排查人员！');
    } else if (imgDetails.isEmpty) {
      ToastWidget.showToastMsg('请上传问题图片！');
    }else{
      Map<String, dynamic> _data = {
        'id':_uuid,
        'checkPersonnel': checkName,
        'checkType': 1,
        'images': imgDetails,
        'longitude':position?.longitude,
        'latitude':position?.latitude,
        'userId': userId,
        'companyId': companyId,
        'solvedAt': solvedAt.toString(),
        'reviewedAt': reviewedAt.toString(),
      };
      var response = await Request().post(
          Api.url['inventory'],
          data: _data
      );
      if(response['statusCode'] == 200) {
        Navigator.pop(context);
        var res = await Navigator.pushNamed(context, '/stewardCheck',arguments: {
          'uuid': _uuid,
          'company':false
        });
        if(res == null){
          _getInventoryList();
        }
      }
    }
  }

  ///签到
  void singIn(){
    _uuid = uuid.v4();
    position = null;
    imgDetails = [];
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context,state){
            return ListView(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: px(32)),
                  child: FormCheck.dataCard(
                      title: '签到',
                      children: [
                        FormCheck.rowItem(
                          title: '企业名称',
                          titleColor: Color(0xff323233),
                          child: Text(companyName,style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),),
                        ),
                        FormCheck.rowItem(
                          title: '归属片区',
                          titleColor: Color(0xff323233),
                          child: Text('第一片区',style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),),
                        ),
                        FormCheck.rowItem(
                          title: '区域位置',
                          titleColor: Color(0xff323233),
                          child: Text('西区',style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),),
                        ),
                        FormCheck.rowItem(
                          title: '实时定位',
                          titleColor: Color(0xff323233),
                          child: Row(
                            children: [
                              Visibility(
                                visible: position != null,
                                child: Text('${position?.longitude.toStringAsFixed(2)}, ',
                                  style: TextStyle(color: Color(0xff969799),fontSize: sp(28)),),
                              ),
                              Visibility(
                                visible: position != null,
                                child: Text('${(position?.latitude.toStringAsFixed(2))}',
                                  style: TextStyle(color: Color(0xff969799),fontSize: sp(28)),),
                              ),
                              position == null ?
                              Container(
                                height: px(48),
                                margin: EdgeInsets.only(left: px(24)),
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all<Color>(Color(0XFF2288F4)),
                                  ),
                                  onPressed: () async{
                                    BotToast.showCustomLoading(
                                        ignoreContentClick: true,
                                        toastBuilder: (cancelFunc) {
                                          return Loading(cancelFunc: cancelFunc);
                                        }
                                    );
                                    position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
                                    if(position!=null){
                                      BotToast.cleanAll();
                                    }
                                    state(() {});},
                                  child: Text(
                                    '获取定位',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ) :
                              Container()
                            ],
                          ),
                        ),
                        FormCheck.rowItem(
                            title: '排查人员',
                            titleColor: Color(0xff323233),
                            child: FormCheck.inputWidget(
                                hintText: '请输入排查人员',
                                onChanged: (val){
                                  checkName = val;
                                  state(() {});
                                }
                            )
                        ),
                        FormCheck.rowItem(
                          title: '排查日期',
                          titleColor: Color(0xff323233),
                          child: Text(_dateTime.toString().substring(0,10),style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),),
                        ),
                        FormCheck.rowItem(
                          title: '填报人员',
                          titleColor: Color(0xff323233),
                          child: Text(userName,style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),),
                        ),
                        FormCheck.rowItem(
                          alignStart: true,
                          titleColor: Color(0xff323233),
                          title: "签到照片",
                          child: UploadImage(
                            imgList: imgDetails,
                            uuid: _uuid,
                            closeIcon: true,
                            callback: (List? data) {
                              if (data != null) {
                                imgDetails = data;
                              }
                              setState(() {});
                            },
                          ),
                        ),
                        FormCheck.submit(
                            cancel: (){
                              Navigator.pop(context);
                            },
                            submit: (){
                              _setInventory();
                            }
                        ),
                      ]
                  ),
                )
              ],
            );
          });
        }
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    companyName = widget.arguments?['companyName'] ?? '';
    companyId = widget.arguments?['companyId'].toString() ?? '';
    _tabController = TabController(vsync: this,length: tabBar.length);
    userId= jsonDecode(StorageUtil().getString(StorageKey.PersonalData))['id'];
    userName= jsonDecode(StorageUtil().getString(StorageKey.PersonalData))['nickname'];
    _getProblem();
    _getInventoryList();
    super.initState();
  }

  ///请空已选的数据
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: RectifyComponents.appBarTop(),
      body: Column(
        children: [
          topBar(),
          Container(
            height: px(64.0),
            color: Colors.white,
            child: DefaultTabController(
              length: tabBar.length,
              child: TabBar(
                  controller: _tabController,
                  indicatorSize: TabBarIndicatorSize.label,
                  indicatorPadding: EdgeInsets.only(bottom: 5.0),
                  isScrollable: false,
                  labelColor: Colors.blue,
                  labelStyle: TextStyle(fontSize: sp(30.0),fontFamily: 'M'),
                  unselectedLabelColor: Color(0xff969799),
                  unselectedLabelStyle: TextStyle(fontSize: sp(30.0),fontFamily: 'R'),
                  indicatorColor:Colors.blue,
                  indicatorWeight: px(2),
                  tabs: tabBar.map((item) {
                    return Tab(text: '  $item  ');
                  }).toList()
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
                controller: _tabController,
                children: <Widget>[
                  ProblemPage(
                    hiddenProblem: companyDetails,
                    companyId: companyId,
                  ),
                  InventoryPage(
                    hiddenInventory: inventoryDetails,
                    companyId: companyId,
                  ),// 排查清单
                ]
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
              Navigator.pop(context);
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
              child: Image.asset('lib/assets/icons/form/add.png'),
              // child: Image.asset('lib/assets/images/home/filtrate.png'),
            ),
            onTap: () async{
              singIn();
            },
          ),
        ],
      ),
    );
  }

}
