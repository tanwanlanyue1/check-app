import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scet_check/api/api.dart';
import 'package:scet_check/api/request.dart';
import 'package:scet_check/page/module_steward/check/hiddenParame/components/drop_down_menu_route.dart';
import 'package:scet_check/page/module_steward/check/hiddenParame/components/rectify_components.dart';
import 'package:scet_check/utils/screen/screen.dart';

///隐患台账企业排查清单
///arguments:{companyId:公司id，companyName：公司名称,uuid:uuid}
class HiddenDetails extends StatefulWidget {
  Map? arguments;
  HiddenDetails({Key? key,this.arguments, }) : super(key: key);

  @override
  _HiddenDetailsState createState() => _HiddenDetailsState();
}

class _HiddenDetailsState extends State<HiddenDetails> {
  String companyName = '';//公司名
  String companyId = '';//公司id
  bool show = false; //筛选的显示
  int repertoire = 0; //0-渲染清单 1-问题列表
  bool check = false; //申报,排查
  String uuid = '';//清单id
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
    companyName = widget.arguments?['companyName'] ?? '';
    companyId = widget.arguments?['companyId'].toString() ?? '';
    uuid = widget.arguments?['uuid'].toString() ?? '';
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
                            Navigator.pushNamed(context, '/stewardCheck',arguments: {
                              'uuid':companyDetails[i]['id'],
                              'company':false
                            });
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
                            Navigator.pushNamed(context, '/rectificationProblem',
                                arguments: {'check':true,'problemId':companyDetails[i]['id']}
                            );
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
