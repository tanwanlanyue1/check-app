import 'dart:convert';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:geolocator/geolocator.dart';
import 'package:scet_check/api/api.dart';
import 'package:scet_check/api/request.dart';
import 'package:scet_check/components/generalduty/down_input.dart';
import 'package:scet_check/components/generalduty/loading.dart';
import 'package:scet_check/components/generalduty/no_data.dart';
import 'package:scet_check/components/generalduty/search.dart';
import 'package:scet_check/components/generalduty/sliver_app_bar.dart';
import 'package:scet_check/components/generalduty/toast_widget.dart';
import 'package:scet_check/components/generalduty/upload_image.dart';
import 'package:scet_check/page/module_steward/check/statisticAnaly/components/form_check.dart';
import 'package:scet_check/utils/easyRefresh/easy_refreshs.dart';
import 'package:scet_check/utils/screen/screen.dart';
import 'package:scet_check/utils/storage/data_storage_key.dart';
import 'package:scet_check/utils/storage/storage.dart';
import 'package:uuid/uuid.dart';

import 'components/rectify_components.dart';

///隐患问题页
///hiddenProblem:隐患数据
///firm:是否企业端
class ProblemPage extends StatefulWidget {
  String companyId;
  bool firm;
  ProblemPage({Key? key,required this.companyId,required this.firm}) : super(key: key);

  @override
  _ProblemPageState createState() => _ProblemPageState();
}

class _ProblemPageState extends State<ProblemPage> {
  final EasyRefreshController _controller = EasyRefreshController(); // 上拉组件控制器
  int _pageNo = 1; // 当前页码
  int _total = 10; // 总条数
  bool _enableLoad = true; // 是否开启加载
  bool firm = false; // 是否为企业
  List hiddenProblem = []; //隐患问题数组
  List imgDetails = []; //签到图片
  Uuid uuid = Uuid(); //uuid
  String _uuid = ''; //uuid
  Position? position; //定位
  List problemStatus = [
    {'name':'未整改','id':1},
    {'name':'已整改','id':2},
    {'name':'整改已通过','id':3},
    {'name':'整改未通过','id':4},
  ]; //问题的状态
  List checkNameList = [];//排查人员数组
  DateTime? startTime;//选择开始时间
  DateTime? endTime;//选择结束时间
  String checkName = ''; //排查人员
  String inputCheckName = ''; //输入的排查人员
  String companyId = '';//企业id
  String companyName = '';//企业名称
  String district = '';//企业归属片区
  String region = '';//企业归属区域
  String userName = ''; //用户名
  String userId = ''; //用户id
  final DateTime _dateTime = DateTime.now();
  DateTime solvedAt = DateTime.now().add(Duration(days: 7));//整改期限
  DateTime reviewedAt = DateTime.now().add(Duration(days: 14));//复查期限
  Map<String,dynamic> typeStatus = {'name':'请选择','id':0};//默认类型
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();//侧边栏key

  @override
  void initState() {
    // TODO: implement initState
    companyId = widget.companyId;
    firm = widget.firm;
    userId= jsonDecode(StorageUtil().getString(StorageKey.PersonalData))['id'];
    userName= jsonDecode(StorageUtil().getString(StorageKey.PersonalData))['nickname'];
    checkNameList.add({'name':userName});
    _problemSearch(
        type: typeStatusEnum.onRefresh,
        data: {
          'pageNo': 1,
          'pageSize': 50,
          'company.id':companyId,
        }
    );
    _getProblems();
    super.initState();
  }

  /// 获取企业下的问题/问题搜索筛选
  ///companyId:公司id
  ///page:第几页
  ///size:每页多大
  /// 'timeSearch':确认传递时间,
  /// 'startTime':开始时间,
  /// 'endTime':结束时间,
  ///添加一个状态 check-提交到企业,environment-提交到环保局
  _problemSearch({typeStatusEnum? type,Map<String,dynamic>? data}) async {

    var response = await Request().get(Api.url['problemList'],data: data);

    if(response['statusCode'] == 200 && response['data'] != null){
      Map _data = response['data'];
      _pageNo++;
      if (mounted) {
        if(type == typeStatusEnum.onRefresh) {
          // 下拉刷新
          _onRefresh(data: _data['list'], total: _data['total']);
        }else if(type == typeStatusEnum.onLoad) {
          // 上拉加载
          _onLoad(data: _data['list'], total: _data['total']);
        }
      }
    }
  }

  //查询企业详情
  void _getProblems() async {
    var response = await Request().get(Api.url['company']+'/$companyId',);
    if(response['statusCode'] == 200) {
      companyName = response['data']['name'];
      district = response['data']['district']['name'];
      region = response['data']['region']['name'];
      setState(() {});
    }
  }

  /// 下拉刷新
  /// 判断是否是企业端,剔除掉非企业端看的问题
  _onRefresh({required List data,required int total}) {
    _total = total;
    if(firm){
      hiddenProblem = [];
      for(var i = 0; i < data.length; i++){
        if(data[i]['isCompanyRead'] == true){
          hiddenProblem.add(data[i]);
        }
      }
    }else{
      hiddenProblem = data;
    }
    _enableLoad = true;
    _pageNo = 2;
    _controller.resetLoadState();
    _controller.finishRefresh();
    if(hiddenProblem.length >= total){
      _controller.finishLoad(noMore: true);
      _enableLoad = false;
    }
    setState(() {});
  }

  /// 上拉加载
  /// 当前数据等于总数据，关闭上拉加载
  _onLoad({required List data,required int total}) {
    _total = total;
    _controller.finishLoadCallBack!();
    if(hiddenProblem.length >= total){
      _controller.finishLoad(noMore: true);
      _enableLoad = false;
    }else{
      if(firm){
        for(var i = 0; i < data.length; i++){
          if(data[i]['isCompanyRead'] == true){
            hiddenProblem.add(data[i]);
          }
        }
      }else{
        hiddenProblem.addAll(data);
      }
    }
    setState(() {});
  }

  @override
  void didUpdateWidget(covariant ProblemPage oldWidget) {
    // TODO: implement didUpdateWidget
    _problemSearch(
        type: typeStatusEnum.onRefresh,
        data: {
          'pageNo': 1,
          'pageSize': 50,
          'company.id':companyId,
        }
    );
  super.didUpdateWidget(oldWidget);
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
      ToastWidget.showToastMsg('请上传签到图片！');
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
        Navigator.pushNamed(context, '/stewardCheck',arguments: {
          'uuid': _uuid,
          'company':false
        });
      }
    }
  }

  ///签到
  ///获取uuid,用来上传
  ///position,imgDetails清空每次的坐标和图片
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
                          child: Text(district,style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),),
                        ),

                        FormCheck.rowItem(
                          title: '区域位置',
                          titleColor: Color(0xff323233),
                          child: Text(region,style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),),
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
                                    //发起加载，禁止多次点击
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
                            child:  Container(
                              margin: EdgeInsets.only(left: px(20), right: px(20)),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: DownInput(
                                      value: checkName,
                                      // data: [{'name':userName}],checkNameList
                                      data: checkNameList,
                                      more: true,
                                      hitStr: '请选择排查人员',
                                      callback: (val){
                                        checkName = '';
                                        for(var i = 0; i < val.length;i++){
                                          if(i>0){
                                            checkName = checkName + ',' + val[i]['name'];
                                          }else{
                                            checkName = val[i]['name'];
                                          }
                                        }
                                        state(() {});
                                      },
                                    ),
                                  ),
                                  GestureDetector(
                                    behavior: HitTestBehavior.translucent,
                                    child: Container(
                                      margin: EdgeInsets.only(left: px(24),right: px(24),bottom: px(4)),
                                      padding: EdgeInsets.only(left: px(12),right: px(12),bottom: px(4),top: px(4)),
                                      child: Text('添加人员',style: TextStyle(
                                          fontSize: sp(26),
                                          color: Colors.white
                                        // color: Color(0xff323233),
                                      )),
                                      decoration: BoxDecoration(
                                        color: Color(0xff4D7FFF),
                                        border: Border.all(width: px(2),color: Color(0XffE8E8E8)),
                                        borderRadius: BorderRadius.all(Radius.circular(px(12))),
                                      ),
                                    ),
                                    onTap: () async{
                                      showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (BuildContext context) {
                                          return GestureDetector(
                                              onTap: () {
                                                Navigator.of(context).pop(); //退出弹出框
                                              },
                                              child: Material(
                                                color: Color.fromRGBO(0, 0, 0, 0.5),
                                                child: Center(
                                                  child: Container(
                                                    width: px(540),
                                                    height: px(140),
                                                    padding: EdgeInsets.only(left: px(24),top: px(12)),
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius: BorderRadius.only(
                                                          topLeft: Radius.circular(px(15)),
                                                          topRight: Radius.circular(px(15)),
                                                        )
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          child: FormCheck.inputWidget(
                                                              hintText: '请输入排查人员',
                                                              onChanged: (val){
                                                                inputCheckName = val;
                                                                state(() {});
                                                              }
                                                          ),
                                                        ),
                                                        GestureDetector(
                                                          child: Container(
                                                            margin: EdgeInsets.only(left: px(24),right: px(24),bottom: px(4)),
                                                            padding: EdgeInsets.only(left: px(12),right: px(12),bottom: px(4),top: px(4)),
                                                            child: Text('添加',style: TextStyle(
                                                                fontSize: sp(26),
                                                                color: Colors.white
                                                            )),
                                                            decoration: BoxDecoration(
                                                              color: Color(0xff4D7FFF),
                                                              border: Border.all(width: px(2),color: Color(0XffE8E8E8)),
                                                              borderRadius: BorderRadius.all(Radius.circular(px(12))),
                                                            ),
                                                          ),
                                                          onTap: (){
                                                            setState(() {
                                                              checkNameList.add({'name':inputCheckName});
                                                              // checkName = checkName + '，' +inputCheckName;
                                                              inputCheckName = '';
                                                              Navigator.pop(context);
                                                            });
                                                          },
                                                        )
                                                      ],
                                                    )
                                                  ),
                                                ),
                                              )
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
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
                              imgDetails = data ?? [];
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
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Column(
        children: [
          Search(
            bgColor: Color(0xffffffff),
            textFieldColor: Color(0xFFF0F1F5),
            search: (value) {
              _problemSearch(
                type: typeStatusEnum.onRefresh,
                data: {
                'regexp':true,//近似搜索
                'detail': value,
                'company.id':companyId,
              });
            },
            screen: (){
              _scaffoldKey.currentState!.openEndDrawer();
            },
          ),
          Expanded(
            child: EasyRefresh.custom(
              enableControlFinishRefresh: true,
              enableControlFinishLoad: true,
              topBouncing: true,
              controller: _controller,
              taskIndependence: false,
              reverse: false,
              footer: footers(),
              header: headers(),
              onLoad:  _enableLoad ? () async {
                _problemSearch(
                    type: typeStatusEnum.onLoad,
                    data: {
                        'pageNo': _pageNo,
                        'pageSize': 50,
                        'company.id':companyId,
                      }
                );
              } : null,
              onRefresh: () async {
                _pageNo = 1;
                _problemSearch(
                    type: typeStatusEnum.onRefresh,
                    data: {
                      'pageNo': 1,
                      'pageSize': 50,
                      'company.id':companyId,
                    }
                );
              },
              slivers: <Widget>[
                hiddenProblem.isEmpty ?
                SliverList(
                  delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
                    return NoData(timeType: true, state: '未获取到数据!');
                  },
                    childCount: 1,),
                ) :
                SliverList(
                  delegate: SliverChildBuilderDelegate((context, i) {
                    return RectifyComponents.rectifyRow(
                        company: hiddenProblem[i],
                        i: i,
                        detail: true,
                        review: false,
                        callBack:(){
                          if(firm){
                            Navigator.pushNamed(context, '/abarbeitungFrom',arguments: {'id':hiddenProblem[i]['id']});
                          }else{
                            Navigator.pushNamed(context, '/rectificationProblem',
                                arguments: {'check':true,'problemId':hiddenProblem[i]['id']}
                            );
                          }
                        }
                    );
                  },
                      childCount: hiddenProblem.length),
                ),
                SliverPersistentHeader(
                  floating: false,//floating 与pinned 不能同时为true
                  pinned: true,
                  delegate: SliverAppBarDelegate(
                      minHeight: px(100),
                      maxHeight: px(100),
                      child: Visibility(
                          visible: hiddenProblem.isNotEmpty && _enableLoad == false,
                          child: Container(
                              padding: EdgeInsets.only(top: px(24.0)),
                              child: Text(
                                '到底啦~',
                                style: TextStyle(
                                    color: Color(0X99A1A6B3),
                                    fontSize: sp(22.0)
                                ),
                                textAlign: TextAlign.center,
                              )
                          )
                      )
                  ),
                )
              ],
            ),
          ),
          Visibility(
            visible: !firm,
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              child: Container(
                height: px(64),
                margin: EdgeInsets.only(left: px(24),right: px(24),bottom: px(4)),
                padding: EdgeInsets.only(left: px(12),right: px(12),top: px(8)),
                child: Text('签到清单',style: TextStyle(
                    fontSize: sp(26),
                    color: Colors.white,
                ),),
                decoration: BoxDecoration(
                  color: Color(0xff4D7FFF),
                  border: Border.all(width: px(2),color: Color(0XffE8E8E8)),
                  borderRadius: BorderRadius.all(Radius.circular(px(20))),
                ),
              ),
              onTap: () async{
                singIn();
              },
            ),
          ),
        ],
      ),
      endDrawer: RectifyComponents.endDrawers(
          context,
          typeStatus: typeStatus,
          status: problemStatus,
          startTime: startTime ?? DateTime.now(),
          endTime: endTime ?? DateTime.now(),
          callPop: (){
            _problemSearch(
                type: typeStatusEnum.onRefresh,
                data: {
                  'pageNo': 1,
                  'pageSize': 50,
                  'company.id':companyId,
                }
            );
          },
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
            //判断搜索日期传递的参数
            if(startTime==null){
              _problemSearch(
                  type: typeStatusEnum.onRefresh,
                  data: {
                    'status':typeStatus['id'],
                    'company.id':companyId,
                  }
              );
            }
            else{
              _problemSearch(
                  type: typeStatusEnum.onRefresh,
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