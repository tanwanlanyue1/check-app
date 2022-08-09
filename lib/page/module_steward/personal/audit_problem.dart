import 'package:flutter/material.dart';
import 'package:scet_check/api/api.dart';
import 'package:scet_check/api/request.dart';
import 'package:scet_check/components/generalduty/toast_widget.dart';
import 'package:scet_check/page/module_steward/check/hiddenParame/components/rectify_components.dart';
import 'package:scet_check/page/module_steward/check/statisticAnaly/components/form_check.dart';
import 'package:scet_check/utils/screen/screen.dart';

import 'components/task_compon.dart';


///审核清单问题
///id:清单id
class AuditProblem extends StatefulWidget {
  final Map? arguments;
  const AuditProblem({Key? key,this.arguments}) : super(key: key);

  @override
  _AuditProblemState createState() => _AuditProblemState();
}

class _AuditProblemState extends State<AuditProblem> {

  String uuid = '';//清单id
  List problemList = [];//企业下的问题

  /// 获取问题
  ///companyId:公司id
  ///page:第几页
  ///size:每页多大
  ///andWhere:查询的条件
  ///check 添加一个提交问题的判断
  ///有一个问题未通过，就不可以归档
  void _getProblem() async {
    var response = await Request().get(Api.url['problemList'],
      data: {
        'inventoryId':uuid
      },);
    if(response['statusCode'] == 200 && response['data'] != null) {
      setState(() {
        problemList = response['data']['list'];
      });
    }
  }
  /// 签到清单
  /// id: uuid
  /// solvedAt: 整改期限
  /// reviewedAt: 复查期限
  void _setInventory(Map<String, dynamic> _data) async {
    var response = await Request().post(
        Api.url['inventory'],
        data: _data
    );
    if(response['statusCode'] == 200) {
      setState(() {});
      ToastWidget.showToastMsg('审核成功');
      Navigator.pop(context,true);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    uuid = widget.arguments?['id'] ?? '';
    _getProblem();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TaskCompon.topTitle(
              title: '审核问题',
              left: true,
              callBack: (){
                Navigator.pop(context);
              }
          ),
          Expanded(
            child: concerns(),
          ),
          pigeonhole(),
        ],
      ),
    );
  }
  ///隐患问题
  ///res:问题提交完成，
  Widget concerns(){
    return Container(
      margin: EdgeInsets.only(top: px(24),left: px(24),right: px(24)),
      color: Colors.white,
      child: ListView(
        padding: EdgeInsets.only(top: 0),
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(top: px(20),left: px(32),),
                  height: px(55),
                  child: FormCheck.formTitle(
                    '问题列表',
                  ),
                ),
              ),
            ],
          ),
          Column(
            children: List.generate(problemList.length, (i) => RectifyComponents.rectifyRow(
                company: problemList[i],
                i: i,
                callBack:() async {
                  Navigator.pushNamed(context, '/abarbeitungFrom',arguments: {'id':problemList[i]['id'],'audit':false,"inventoryStatus":3});
                }
            )),
          ),
        ],
      ),
    );
  }

  ///审核按钮
  Widget pigeonhole(){
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: px(88),
        margin: EdgeInsets.only(top: px(12)),
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              child: Container(
                width: px(240),
                height: px(56),
                alignment: Alignment.center,
                margin: EdgeInsets.only(left: px(40)),
                child: Text(
                  '审核不通过',
                  style: TextStyle(
                      fontSize: sp(24),
                      fontFamily: "R",
                      color: Colors.white),
                ),
                decoration: BoxDecoration(
                  color: Color(0xff4D7FFF),
                  border: Border.all(width: px(2),color: Color(0XffE8E8E8)),
                  borderRadius: BorderRadius.all(Radius.circular(px(28))),
                ),
              ),
              onTap: (){
                _setInventory(
                    {
                      'id':uuid,
                      'status': 5,
                    }
                );
                setState(() {});
              },
            ),
            GestureDetector(
              child: Container(
                width: px(240),
                height: px(56),
                alignment: Alignment.center,
                margin: EdgeInsets.only(left: px(40)),
                child: Text(
                  '审核通过',
                  style: TextStyle(
                      fontSize: sp(24),
                      fontFamily: "R",
                      color: Colors.white),
                ),
                decoration: BoxDecoration(
                  color: Color(0xff4D7FFF),
                  border: Border.all(width: px(2),color: Color(0XffE8E8E8)),
                  borderRadius: BorderRadius.all(Radius.circular(px(28))),
                ),
              ),
              onTap: (){
                _setInventory(
                    {
                      'id':uuid,
                      'status': 1,
                    }
                );
                setState(() {});
              },
            ),
          ],
        ),
      ),
    );
  }
}
