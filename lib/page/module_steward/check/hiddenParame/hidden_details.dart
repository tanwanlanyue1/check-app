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
  List status = [];//状态
  List problemStatus = [
    {'name':'未整改','id':1},
    {'name':'已整改','id':2},
    {'name':'整改已通过','id':3},
    {'name':'整改未通过','id':4},
  ]; //问题的状态
  List inventoryStatus = [
    {'name':'整改中','id':1},
    {'name':'已归档','id':2},
    {'name':'待审核','id':3},
    {'name':'审核已通过','id':4},
    {'name':'审核未通过','id':5},
    {'name':'未提交','id':6},
  ]; //清单的状态
  Map<String,dynamic> typeStatus = {'name':'请选择','id':0};//默认类型
  String companyName = '';//公司名
  String companyId = '';//公司id
  int repertoire = 0; //0-渲染清单 1-问题列表
  int selectIndex = 0; //选择的下标
  bool check = false; //申报,排查
  Uuid uuid = Uuid(); //uuid
  String _uuid = ''; //uuid
  Position? position; //定位
  String userName = ''; //用户名
  String userId = ''; //用户id
  String checkName = ''; //排查人员
  String condition = ''; //条件查询
  DateTime? startTime;//选择开始时间
  DateTime? endTime;//选择结束时间
  final DateTime _dateTime = DateTime.now();
  DateTime solvedAt = DateTime.now().add(Duration(days: 7));//整改期限
  DateTime reviewedAt = DateTime.now().add(Duration(days: 14));//复查期限
  late TabController _tabController; //TabBar控制器
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();//侧边栏key

  /// 获取企业下的问题
  ///companyId:公司id
  ///page:第几页
  ///size:每页多大
  ///andWhere:查询的条件
  ///添加一个状态 check-提交到企业,environment-提交到环保局
  void _getProblem() async {
    Map<String,dynamic> data = {
      'page':1,
      'size':50,
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
      // 'page':1,
      // 'size':50,
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
        _getInventoryList();
        Navigator.pop(context);
      }
    }
  }

  /// 问题搜索筛选
  ///name:搜索名
  ///query:搜索的字段
  void _problemSearch({Map<String,dynamic>? data}) async {
    var response = await Request().get(Api.url['problemList'],data: data,);
    if(response['statusCode'] == 200 && response['data'] != null) {
      setState(() {
        companyDetails = response['data']['list'];
      });
    }
  }
  /// 清单搜索筛选
  ///name:搜索名
  ///query:搜索的字段
  void _inventorySearch({Map<String,dynamic>? data}) async {
    var response = await Request().get(Api.url['inventoryList'],data: data,);
    if(response['statusCode'] == 200 && response['data'] != null) {
      setState(() {
        inventoryDetails = response['data']['list'];
      });
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
    status = problemStatus;
    _tabController.addListener(() {
      if(_tabController.index == 0){
        status = problemStatus;
      }else{
        status = inventoryStatus;
      }
      setState(() {});
    });
    _getProblem();
    _getInventoryList();
    super.initState();
  }

  ///请空已选的数据
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
          Search(
            bgColor: Color(0xffffffff),
            textFieldColor: Color(0xFFF0F1F5),
            search: (value) {
              condition = value;
              if(_tabController.index == 0){
                _problemSearch(data: {
                  'regexp':true,//近似搜索
                  'detail': condition,
                  'company.id':companyId,
                });
              }else{
                _inventorySearch(
                    data: {
                      'regexp':true,//近似搜索
                      'detail': condition,
                      'company.id':companyId,
                    }
                );
              }
            },
            screen: (){
              _scaffoldKey.currentState!.openEndDrawer();
            },
          ),
          Expanded(
            child: TabBarView(
                controller: _tabController,
                children: <Widget>[
                  companyDetails.isNotEmpty ?
                  ProblemPage(
                    hiddenProblem: companyDetails,
                  ):// 隐患问题
                  Container(),
                  ListView(
                    padding: EdgeInsets.only(top: 0),
                    children: [
                      Column(
                        children: List.generate(inventoryDetails.length, (i) => RectifyComponents.repertoireRow(
                            company: inventoryDetails[i],
                            i: i,
                            callBack:(){
                              Navigator.pushNamed(context, '/stewardCheck',arguments: {
                                'uuid':inventoryDetails[i]['id'],
                                'company':false
                              });
                            }
                        )),
                      )
                    ],
                  ),// 排查清单
                ]
            ),
          ),
        ],
      ),
      endDrawer: endDrawers(),
    );
  }

  ///头部
  ///筛选
  ///companyDetails要清空并重新赋值
  Widget topBar(){
    return Container(
      color: Colors.white,
      height: px(88),
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

  ///抽屉
  Widget endDrawers(){
    return Container(
      width: px(600),
      color: Color(0xFFFFFFFF),
      padding: EdgeInsets.only(left: px(20), right: px(20),bottom: px(50)),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: Adapt.padTopH()),
            child: Row(
              mainAxisAlignment:MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '问题搜索',
                  style: TextStyle(fontSize: sp(30),color: Color(0xFF2E2F33),fontFamily:"M"),
                ),
                IconButton(
                  icon: Icon(Icons.clear,color: Colors.red,size: px(39),),
                  onPressed: (){Navigator.pop(context);},
                )
              ],
            ),
          ),
          Row(
            children: [
              Container(
                height: px(72),
                width: px(140),
                alignment: Alignment.bottomLeft,
                child: Text('状态：',style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: px(20), right: px(20)),
                  child: DownInput(
                    value: typeStatus['name'],
                    data: status,
                    callback: (val){
                      typeStatus['name'] = val['name'];
                      typeStatus['id'] = val['id'];
                      setState(() {});
                    },
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                height: px(72),
                width: px(140),
                alignment: Alignment.bottomCenter,
                child: Text('起止时间：',style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),),
              ),
              Expanded(
                child: Container(
                  height: px(72),
                  width: px(580),
                  color: Colors.white,
                  margin: EdgeInsets.only(top: px(24),left: px(24),right: px(24)),
                  child: DateRange(
                    start: startTime ?? DateTime.now(),
                    end: endTime ?? DateTime.now(),
                    showTime: false,
                    callBack: (val) {
                      startTime = val[0];
                      endTime = val[1];
                      setState(() { });
                    },
                  ),
                ),
              ),
            ],
          ),
          Spacer(),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  child: Container(
                    alignment: Alignment.center,
                    color: Color(0xffE6EAF5),
                    height: px(56),
                    padding: EdgeInsets.only(left: px(49),right: px(49)),
                    child: Text('取消',style: TextStyle(color: Color(0xff4D7FFF),fontSize: sp(24)),),
                  ),
                  onTap: (){
                    Navigator.pop(context);
                  },
                ),
              ),
              Expanded(
                child: InkWell(
                  child: Container(
                    color: Color(0xff4D7FFF),
                    height: px(56),
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(left: px(49),right: px(49)),
                    child: Text('确定',style: TextStyle(color: Colors.white,fontSize: sp(24)),),
                  ),
                  onTap: (){
                    if(startTime==null){
                      if(_tabController.index == 0){
                        _problemSearch(
                            data: {
                              'status':typeStatus['id'],
                              'company.id':companyId,
                            }
                        );
                      }else{
                        _inventorySearch(
                            data: {
                              'status':typeStatus['id'],
                              'company.id':companyId,
                            }
                        );
                      }
                    }
                    else{
                      if(_tabController.index == 0){
                        _problemSearch(
                            data: {
                              'status':typeStatus['id'],
                              'company.id':companyId,
                              'timeSearch':'createdAt',
                              'startTime':startTime,
                              'endTime':endTime,
                            }
                        );
                      }else{
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
                    }
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
