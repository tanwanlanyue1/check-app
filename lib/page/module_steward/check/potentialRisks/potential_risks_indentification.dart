import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:scet_check/api/api.dart';
import 'package:scet_check/api/request.dart';
import 'package:scet_check/components/generalduty/toast_widget.dart';
import 'package:scet_check/components/generalduty/upload_image.dart';
import 'package:scet_check/page/module_steward/check/statisticAnaly/components/form_check.dart';
import 'package:scet_check/page/module_steward/check/hiddenParame/components/client_list_page.dart';
import 'package:scet_check/page/module_steward/check/statisticAnaly/components/layout_page.dart';
import 'package:scet_check/utils/screen/screen.dart';
import 'package:scet_check/utils/storage/data_storage_key.dart';
import 'package:scet_check/utils/storage/storage.dart';
import 'package:uuid/uuid.dart';

///隐患排查
class PotentialRisksIndentification extends StatefulWidget {
  const PotentialRisksIndentification({Key? key}) : super(key: key);

  @override
  _PotentialRisksIndentificationState createState() => _PotentialRisksIndentificationState();
}

class _PotentialRisksIndentificationState extends State<PotentialRisksIndentification> {
  List tabBar = ["全园区","第一片区","第二片区","第三片区"];//头部
  final PageController pagesController = PageController();//页面控制器
  String _companyId = ''; //公司id
  String _companyName = ''; //公司名称
  String checkName = ''; //排查人员
  List companyList = []; //全部公司数据
  List imgDetails = []; //上传图片
  Position? position; //定位
  int pageIndex = 0; //下标
  Uuid uuid = Uuid(); //uuid
  String _uuid = ''; //uuid
  String userName = ''; //用户名
  String userId = ''; //用户id
  final DateTime _dateTime = DateTime.now();
  DateTime solvedAt = DateTime.now().add(Duration(days: 7));//整改期限
  DateTime reviewedAt = DateTime.now().add(Duration(days: 14));//复查期限
  List districtId = [""];//片区id
  List districtList = [];//片区统计数据
  Map<String,dynamic> data = {};//获取企业数据传递的参数

  /// 获取企业统计
  /// district.id:片区id
  void _getCompany() async {
    if(pageIndex != 0){
      data = {
        'district.id': districtList[pageIndex]['id']
      };
    }else{
      data = {};
    }
    var response = await Request().get(
        Api.url['companyList'],
        data: data
    );
    if(response['statusCode'] == 200) {
      companyList = response["data"]['list'];
      setState(() {});
    }
  }
  /// 获取片区统计
  /// 获取tabbar表头，不在写死,
  /// 片区id也要获取，传递到页面请求片区详情
  void _getStatistics() async {
    var response = await Request().get(Api.url['district']);
    if(response['statusCode'] == 200) {
      tabBar = [];
      tabBar.add('全园区');
      setState(() {
        districtList = response["data"];
        for(var i = 0; i<districtList.length;i++){
          tabBar.add(districtList[i]['name']);
          districtId.add(districtList[i]['id']);
        }
      });
      _getCompany();
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
        'images': imgDetails,
        'longitude':position?.longitude,
        'latitude':position?.latitude,
        'userId': userId,
        'companyId': _companyId,
        'solvedAt': solvedAt.toString(),
        'reviewedAt': reviewedAt.toString(),
      };
      var response = await Request().post(
          Api.url['inventory'],
          data: _data
      );
      if(response['statusCode'] == 200) {
        Navigator.pop(context);
        setState(() {
          Navigator.pushNamed(context, '/stewardCheck', arguments: {'uuid':_uuid,'company':false});
        });
      }
    }
  }

  ///签到
  void singIn(){
    _uuid = uuid.v4();
    position = null;
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
                            child: Text(_companyName,style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),),
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
                              Container(
                                height: px(48),
                                margin: EdgeInsets.only(left: px(24)),
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all<Color>(Color(0XFF2288F4)),
                                  ),
                                  onPressed: () async{
                                    position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
                                    state(() {});},
                                  child: Text(
                                    '获取定位',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              )
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
                            title: "问题照片",
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
    _getStatistics();
    Map res = jsonDecode(StorageUtil().getString(StorageKey.PersonalData));
    userName = res['nickname'];
    userId = res['id'];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutPage(
      tabBar: tabBar,
      callBack: (val){
        pageIndex = val;
        _getCompany();
        setState(() {});
      },
      pageBody: List.generate(4, (index) => Column(
        children: [
          Container(
            height: px(24),
            margin: EdgeInsets.only(left:px(20),right: px(20)),
            color: Colors.white,
          ),
          Visibility(
            visible: companyList.isNotEmpty,
            child: Expanded(
              child: ClientListPage(
                companyList: companyList,
                callBack: (id,name){
                  _companyId = id;
                  _companyName = name;
                  imgDetails = [];
                  singIn();
                  setState(() {});
                },
              ),
            ),
          ),
        ],
      )),
    );
  }

}
