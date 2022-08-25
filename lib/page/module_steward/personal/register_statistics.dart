import 'package:flutter/material.dart';
import 'package:scet_check/api/api.dart';
import 'package:scet_check/api/request.dart';
import 'package:scet_check/page/module_steward/check/statisticAnaly/components/form_check.dart';
import 'package:scet_check/utils/screen/screen.dart';

import 'components/task_compon.dart';


///登录统计
class RegisterStatistics extends StatefulWidget {
  const RegisterStatistics({Key? key}) : super(key: key);

  @override
  _RegisterStatisticsState createState() => _RegisterStatisticsState();
}

class _RegisterStatisticsState extends State<RegisterStatistics>{
  List loginUser = [];//登录用户

  /// 登录统计
  void _loginCount() async {
    var response = await Request().get(
        Api.url['loginCount']
    );
    if (response['errCode'] == '10000') {
      loginUser = response['result'];
      setState(() {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    _loginCount();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TaskCompon.topTitle(
              title: '登录统计',
              home: true,
              callBack: (){
                Navigator.pop(context);
              }
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.only(top: 0),
              children: List.generate(loginUser.length, (i){
                return visitCard(
                    i: i
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  ///访问数量卡片
  ///i：下标
  Widget visitCard({required int i}){
    return Container(
      margin: EdgeInsets.only(left: px(24),right: px(24),top: px(24)),
      padding: EdgeInsets.only(left: px(24),right: px(24),bottom: px(24)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(px(8.0))),
      ),
      child: Column(
        children: [
          Container(
            color: Colors.white,
            margin: EdgeInsets.only(top: px(12)),
            height: px(56),
            child: FormCheck.formTitle('${loginUser[i]['opName']}'),
          ),
          Container(
            margin: EdgeInsets.only(bottom: px(18)),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                      margin: EdgeInsets.only(right: px(18)),
                      child: Text(
                          '平台总访问:',
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                              color: Color(0xFF787A80),
                              fontSize: sp(28.0),
                              fontWeight: FontWeight.w500
                          )
                      )
                  ),
                  Text('${loginUser[i]['platFormTotal']}次',style: TextStyle(color: Color(0xff608DFF),fontSize: sp(28)),),
                ]
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: px(18)),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                      margin: EdgeInsets.only(right: px(18)),
                      child: Text(
                          'APP总访问:',
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                              color: Color(0xFF787A80),
                              fontSize: sp(28.0),
                              fontWeight: FontWeight.w500
                          )
                      )
                  ),
                  Text('${loginUser[i]['appTotal']}次',style: TextStyle(color: Color(0xff608DFF),fontSize: sp(28)),),
                ]
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: px(18)),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                      margin: EdgeInsets.only(right: px(18)),
                      child: Text(
                          '今日平台访问:',
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                              color: Color(0xFF787A80),
                              fontSize: sp(28.0),
                              fontWeight: FontWeight.w500
                          )
                      )
                  ),
                  Text('${loginUser[i]['platFormTodayNum']}次',style: TextStyle(color: Color(0xff608DFF),fontSize: sp(28)),),
                ]
            ),
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                    margin: EdgeInsets.only(right: px(18)),
                    child: Text(
                        '今日APP访问:',
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                            color: Color(0xFF787A80),
                            fontSize: sp(28.0),
                            fontWeight: FontWeight.w500
                        )
                    )
                ),
                Text('${loginUser[i]['appTodayNum']}次',style: TextStyle(color: Color(0xff608DFF),fontSize: sp(28)),),
              ]
          ),
        ],
      ),
    );
  }
}
