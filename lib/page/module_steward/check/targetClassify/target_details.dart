import 'package:flutter/material.dart';
import 'package:scet_check/api/api.dart';
import 'package:scet_check/api/request.dart';
import 'package:scet_check/components/generalduty/toast_widget.dart';
import 'package:scet_check/page/module_steward/check/statisticAnaly/components/form_check.dart';
import 'package:scet_check/page/module_steward/personal/components/task_compon.dart';
import 'package:scet_check/utils/screen/screen.dart';

///指标详情页
///three 三级目录
///arguments:{
/// "three": false,
///  'id': childData[i]['parentId'],//三级id
///  'companyId': widget.arguments?['id'],//企业id
///  'companyName': widget.arguments?['companyName'],//企业名称
///  'name': widget.arguments?['name'],//标题
///  'children': childData[i]['id'],}//四级id
class TargetDetails extends StatefulWidget {
  final Map? arguments;
  const TargetDetails({Key? key,this.arguments}) : super(key: key);

  @override
  _TargetDetailsState createState() => _TargetDetailsState();
}

class _TargetDetailsState extends State<TargetDetails> {
  String title = '原则性指标';
  String companyId = '';//企业id
  String companyName = '';//企业名称
  String targetId = '';//指标id
  String childrenId = '';//四级id
  int index = 4; //选择下标
  bool three = false;//三级目录
  Map targetList = {};//指标列表
  List childList = [];//四级列表

  @override
  void initState(){
    // TODO: implement initState
    three = widget.arguments?['three'] ?? false;
    companyId = widget.arguments?['companyId'] ?? '';
    targetId = widget.arguments?['id'] ?? '';
    childrenId = widget.arguments?['children'] ?? '';
    companyName = widget.arguments?['companyName'] ?? '';
    title = widget.arguments?['name'] ?? '';
    _getTargetDetail();
    if(childrenId.isNotEmpty){
      _getTarget(childrenId:childrenId).then((res){
        if(res != null && res.isNotEmpty){
          if(res == '符合'){
            index = 0;
          }else if(res == '不符合'){
            index = 1;
          }else if(res == '部分符合'){
            index = 2;
          }
        }
     });
    }
    super.initState();
  }
  /// 查询指标
  /// 查询三级，没有targetCompanys，查询四级，没有一级的指标
  /// 判断三级下的所有四级的结果
  void _getTargetDetail() async {
    var response = await Request().get(Api.url['target']+'/$targetId',);
    if(response['statusCode'] == 200) {
      targetList = response['data'];
      if(three){
        childList = targetList['children'];
        for(var i = 0; i < childList.length; i++){
          childList[i]['tidy'] = 4;
          var res = await _getTarget(childrenId: childList[i]['id']);
          if(res != null && res.isNotEmpty){
            if(res == '符合'){
              childList[i]['tidy'] = 0;
            }else if(res == '不符合'){
              childList[i]['tidy'] = 1;
            }else if(res == '部分符合'){
              childList[i]['tidy'] = 2;
            }
          }
        }
      }
      setState(() {});
    }
  }

  /// 查询指标企业
  /// childrenIdL: 四级的id
  /// companyId:企业id
  _getTarget({required String childrenId}) async {
    var response = await Request().get(Api.url['targetCompanyList'],
        data: {
          "targetId": childrenId,
          "companyId":companyId
       });
    if(response['statusCode'] == 200 && response['data']['list'].length != 0) {
      String res = response['data']['list'][0]['result'] ?? '';
      setState(() {});
      return res;
    }
  }

  /// 提交指标企业
  _postTarget({required String childrenId,required String body}) async {
    var response = await Request().post(Api.url['targetCompany'],data: {
      'targetId':childrenId,
      'companyId':companyId,
      'result':body
    });
    if(response['statusCode'] == 200) {
      ToastWidget.showToastMsg('提交完成!');
      return true;
    }else{
      ToastWidget.showToastMsg('提交失败');
      return false;
    }
  }

  ///展示指标
  ///等级为2，没有3,4级内容
  ///showLevel 展示的等级
  ///level 当前等级
  String _showTarget(int level,{required int showLevel}){
    if(level == 2){
      if(showLevel == 1){
        return targetList['parent']['name'];
      }else if(showLevel == 2){
        return targetList['name'];
      }else{
        return '/';
      }
    } else if(level == 3){
      if(showLevel == 1){
        return targetList['parent']['parent']['name'];
      }else if(showLevel == 2){
        return targetList['parent']['name'];
      }else if(showLevel == 3){
        return targetList['name'];
      }else if(three){

      }else{
        for(var i = 0; i < (targetList['children']?.length ?? 0); i++){
          targetList['children'][i]['id'] == childrenId;
          return targetList['children'][i]['name'];
        }
      }
      return '/';
    }else{
      return '/';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TaskCompon.topTitle(
              title: companyName,
              left: true,
              callBack: (){
                Navigator.pop(context);
              }
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.only(top: 0),
              children: [
                targetList.isNotEmpty ?
                details() :
                Container(),
                three ?
                levelFour() :
                Container(),
                targetList['level'] == 3 && !three ?
                _radio() :
                Container(),
                targetList['level'] == 3 ?
                revocation() :
                Container(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //详情
  Widget details(){
    return Container(
      margin: EdgeInsets.only(left: px(24),right: px(24),top: px(24)),
      color: Colors.white,
      padding: EdgeInsets.only(bottom: px(24)),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(left: px(24),top: px(24)),
            child: FormCheck.formTitle(title),
          ),
          Container(
            margin: EdgeInsets.only(left: px(48)),
            child: FormCheck.rowItem(
              title: '一级指标:',
              alignStart: true,
              child: Text(_showTarget(targetList['level'],showLevel: 1),style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: px(48)),
            child: FormCheck.rowItem(
              title: '二级指标:',
              alignStart: true,
              child: Text(_showTarget(targetList['level'],showLevel: 2),style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: px(48)),
            child: FormCheck.rowItem(
              title: '三级指标:',
              alignStart: true,
              child: Text(_showTarget(targetList['level'],showLevel: 3),style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),),
            ),
          ),
          !three ?
          Container(
            margin: EdgeInsets.only(left: px(48)),
            child: FormCheck.rowItem(
              title: '四级指标:',
              alignStart: true,
              child: Text(_showTarget(targetList['level'],showLevel: 4),style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),),
            ),
          ) :
          Container(),
        ],
      ),
    );
  }

  //四级指标
  Widget levelFour(){
    return Container(
      margin: EdgeInsets.only(left: px(24),right: px(24),top: px(24)),
      color: Colors.white,
      padding: EdgeInsets.only(bottom: px(24)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: px(24),top: px(24)),
            child: FormCheck.formTitle('四级指标'),
          ),
          Column(
            children: List.generate(childList.length, (j) => Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                    margin: EdgeInsets.only(left: px(24),top: px(12)),
                    child: Text('${j+1}.'+childList[j]['name'],style: TextStyle(fontSize: sp(28)),),
                  ),
                ),
                Container(
                  width: px(230),
                  margin: EdgeInsets.only(top: px(12)),
                  child: Column(
                    children: [
                      SizedBox(
                        height: px(50),
                        child: Row(
                          children: [
                            SizedBox(
                              width: px(70),
                              child: Radio(
                                value: 0,
                                groupValue: childList[j]['tidy'],
                                onChanged: (val) {
                                  childList[j]['tidy'] = val;
                                  setState(() {});
                                },
                              ),
                            ),
                            InkWell(
                              child: Text(
                                "符和",
                                style: TextStyle(fontSize: sp(28)),
                              ),
                              onTap: (){
                                childList[j]['tidy'] = 0;
                                setState(() {});
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: px(50),
                        child: Row(
                          children: [
                            SizedBox(
                              width: px(70),
                              child: Radio(
                                value: 1,
                                groupValue: childList[j]['tidy'],
                                onChanged: (val) {
                                  setState(() {
                                    childList[j]['tidy'] = val;
                                  });
                                },
                              ),
                            ),
                            InkWell(
                              child: Text(
                                "不符和",
                                style: TextStyle(fontSize: sp(28)),
                              ),
                              onTap: (){
                                setState(() {
                                  childList[j]['tidy'] = 1;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: px(50),
                        child: Row(
                          children: [
                            SizedBox(
                              width: px(70),
                              child: Radio(
                                value: 2,
                                groupValue: childList[j]['tidy'],
                                onChanged: (val){
                                  childList[j]['tidy'] = val;
                                  setState(() {});
                                },
                              ),
                            ),
                            InkWell(
                              child: Text(
                                "部分符合",
                                style: TextStyle(fontSize: sp(28)),
                              ),
                              onTap: (){
                                setState(() {
                                  childList[j]['tidy'] = 2;
                                  setState(() {
                                  });
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )),
          ),
        ],
      ),
    );
  }

  ///单选
  Widget _radio() {
    return Container(
      margin: EdgeInsets.only(left: px(24),right: px(24)),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: px(24)),
            child: Text(
              "相符性：",
              style: TextStyle(fontSize: sp(28)),
            ),
          ),
          SizedBox(
            width: px(70),
            child: Radio(
              value: 0,
              groupValue: index,
              onChanged: (int? val) {
                setState(() {
                  index = val!;
                });
              },
            ),
          ),
          InkWell(
            child: Text(
              "符合",
              style: TextStyle(fontSize: sp(28)),
            ),
            onTap: (){
              setState(() {
                index = 0;
              });
            },
          ),
          SizedBox(
            width: px(70),
            child: Radio(
              value: 1,
              groupValue: index,
              onChanged: (int? val) {
                setState(() {
                  index = val!;
                });
              },
            ),
          ),
          InkWell(
            child: Text(
              "不符合",
              style: TextStyle(fontSize: sp(28)),
            ),
            onTap: (){
              setState(() {
                index = 1;
              });
            },
          ),
          SizedBox(
            width: px(70),
            child: Radio(
              value: 2,
              groupValue: index,
              onChanged: (int? val) {
                setState(() {
                  index = val!;
                });
              },
            ),
          ),
          InkWell(
            child: Text(
              "部分符合",
              style: TextStyle(fontSize: sp(28)),
            ),
            onTap: (){
              setState(() {
                index = 2;
              });
            },
          )
        ],
      ),
    );
  }
  ///按钮
  Widget revocation(){
    return Container(
      height: px(88),
      margin: EdgeInsets.only(top: px(24)),
      color: Colors.white,
      alignment: Alignment.center,
      child: GestureDetector(
        child: Container(
          width: px(240),
          height: px(56),
          alignment: Alignment.center,
          margin: EdgeInsets.only(left: px(40)),
          child: Text(
            '提交',
            style: TextStyle(
                fontSize: sp(24),
                fontFamily: "M",
                color: Color(0xff4D7FFF)),
          ),
          decoration: BoxDecoration(
            border: Border.all(width: px(2),color: Color(0xff4D7FFF)),
            borderRadius: BorderRadius.all(Radius.circular(px(28))),
          ),
        ),
        onTap: () async{
          if(three){
            for(var i = 0; i < childList.length; i++){
              String body = childList[i]['tidy'] == 0 ? '符合' :
              childList[i]['tidy'] == 1 ? "不符合" :
              childList[i]['tidy'] == 2 ? '部分符合' : '';
              if(body.isNotEmpty){
                var res = await _postTarget(childrenId: childList[i]['id'],body: body);
                if(res && i == childList.length-1){
                  Navigator.pop(context);
                }
              }
            }
          }else{
            if(index == 4){
              ToastWidget.showToastMsg('请选择提交类型！');
            }else{
              String body = index == 0 ? '符合' : index == 1 ? "不符合" : '部分符合';
              var res = await _postTarget(childrenId: childrenId,body: body);
              if(res){
                Navigator.pop(context);
              }
            }
          }
        },
      ),
    );
  }
}
