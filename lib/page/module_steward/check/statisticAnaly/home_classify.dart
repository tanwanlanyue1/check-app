import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:scet_check/api/api.dart';
import 'package:scet_check/api/request.dart';
import 'package:scet_check/components/generalduty/toast_widget.dart';
import 'package:scet_check/utils/screen/screen.dart';
import 'package:scet_check/utils/storage/data_storage_key.dart';
import 'package:scet_check/utils/storage/storage.dart';

class HomeClassify extends StatefulWidget {
  const HomeClassify({Key? key}) : super(key: key);

  @override
  _HomeClassifyState createState() => _HomeClassifyState();
}

///首页分类
class _HomeClassifyState extends State<HomeClassify> with RouteAware{
  List classify = [
    {"name":'统计分析',"icon":"lib/assets/icons/home/statistics.png"},
    {"name":'待办任务',"icon":"lib/assets/icons/home/backlog.png"},
    {"name":'已办任务',"icon":"lib/assets/icons/home/hoveDone.png"},
    {"name":'台账记录',"icon":"lib/assets/icons/home/standingBook.png"},
    {"name":'法律规范',"icon":"lib/assets/icons/home/law.png"},
    {"name":'分类分级',"icon":"lib/assets/icons/home/classify.png"},
    {"name":'通知中心',"icon":"lib/assets/icons/home/message.png"},
    {"name":'更多',"icon":"lib/assets/icons/home/more.png"}];//分类
  int total = 0;//待办任务总数
  String userId = ''; //用户id
  Map taskDay = {};//任务量


 //选择事件
  void selectClass(int index){
   switch(index) {
     case 0: Navigator.pushNamed(context, '/checkPage'); break;
     case 1: Navigator.pushNamed(context, '/backlogTask'); break;
     case 2: Navigator.pushNamed(context, '/haveDoneTask'); break;
     case 3: Navigator.pushNamed(context, '/historyTask'); break;
     // case 3: Navigator.pushNamed(context, '/enterprisePage',arguments: {"history":true,"name":"台账记录"}); break;
     case 4: Navigator.pushNamed(context, '/policyStand',arguments: true); break;
     case 5: Navigator.pushNamed(context, '/targetClassifyPage'); break;
     case 6: Navigator.pushNamed(context, '/messagePage',arguments: {'company':false}); break;
     default: ToastWidget.showToastMsg('暂无更多页面');
   }
 }

  /// 查询个人工作量
  void _getByOp() async {
    var response = await Request().get(
      Api.url['byOp'],
    );
    if(response['errCode'] == '10000') {
      taskDay = response['result'] ?? {};
      setState(() {});
    }
  }

 @override
  void initState() {
    // TODO: implement initState
   userId= jsonDecode(StorageUtil().getString(StorageKey.PersonalData))['id'].toString();
   _getByOp();
    super.initState();
  }

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            top(),
            personage(),
            Expanded(
              child: ListView(
                padding: EdgeInsets.only(top: px(0)),
                children: [
                  Row(
                    children: [
                      Container(
                        width: px(4),
                        height: px(24),
                        margin: EdgeInsets.only(right: px(12),left: px(24)),
                        decoration: BoxDecoration(
                            color: Color(0xFF4D7FFF),
                            borderRadius: BorderRadius.all(Radius.circular(px(1)))
                        ),
                      ),
                      Expanded(
                          child: Text('功能分类',
                              style: TextStyle(
                                fontSize: sp(32),
                                fontFamily: 'B',
                                color: Color(0xff323233),
                              )
                          )),
                    ],
                  ),
                  classification(),
                ],
              ),
            ),
          ],
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(//渐变位置
              begin: Alignment.topCenter,end: Alignment.bottomCenter,
              stops: const [0.0, 1.0], //[渐变起始点, 渐变结束点]
              colors: const [Color(0xffC0CCFE), Color(0xffF2F3FA)]//渐变颜色[始点颜色, 结束颜色]
          ),
        ),
      ),
    );
  }

  ///头部
  Widget top(){
   return Column(
     children: [
       Container(
         width: px(750),
         height: Adapt.padTopH(),
         color: Color(0xff19191A),
       ),
       Container(
         height: px(88),
         decoration: BoxDecoration(
           gradient: LinearGradient(//渐变位置
               begin: Alignment.topCenter,end: Alignment.bottomCenter,
               stops: const [0.0, 1.0], //[渐变起始点, 渐变结束点]
               colors: const [Color(0xffC0CCFE), Color(0xffC5D0FE)]//渐变颜色[始点颜色, 结束颜色]
           ),
         ),
         child: Row(
           children: [
             Container(
               width: px(56),
               height: px(56),
               margin: EdgeInsets.only(left: px(26),right: px(24)),
               child: Image.asset('lib/assets/icons/home/iconLogo.png',),
             ),
             Expanded(
               flex: 1,
               child: Container(
                 alignment: Alignment.centerLeft,
                 child: Text('现场排查工具',style: TextStyle(color: Color(0xff323233),fontSize: sp(38),fontFamily: 'M'),),
               ),
             ),
           ],
         ),
       ),
     ],
   );
  }

  ///个人问题统计
  Widget personage(){
   return Container(
     margin: EdgeInsets.only(left: px(24),right: px(24),bottom: px(24),top: px(24)),
     child: Column(
       children: [
         Row(
           children: [
             Container(
               width: px(4),
               height: px(24),
               margin: EdgeInsets.only(right: px(12)),
               decoration: BoxDecoration(
                   color: Color(0xFF4D7FFF),
                   borderRadius: BorderRadius.all(Radius.circular(px(1)))
               ),
             ),
             Expanded(
                 child: Text('个人统计',
                   style: TextStyle(
                     fontSize: sp(32),
                     fontFamily: 'B',
                     color: Color(0xff323233),
                   )
                 )),
           ],
         ),
         Row(
           children: [
             Container(
               width: px(88),
               height: px(130),
               margin: EdgeInsets.only(right: px(24),left: px(24)),
               child: Image.asset('lib/assets/icons/home/execute.png',fit: BoxFit.fitHeight,),
             ),
             Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 Text('发现问题数量  ',style: TextStyle(color: Color(0xff323233),fontSize: sp(26)),),
                 Text('${taskDay['problemTotalNum'] ?? 0}',style: TextStyle(color: Color(0xff323233),fontSize: sp(32),fontFamily: "M"),),
               ],
             ),
             Container(
               width: px(88),
               height: px(130),
               margin: EdgeInsets.only(right: px(24),left: px(32)),
               child: Image.asset('lib/assets/icons/home/review.png',fit: BoxFit.fitHeight,),
             ),
             Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 Text('问题总数量',style: TextStyle(color: Color(0xff323233),fontSize: sp(26)),),
                 Text('${taskDay['hiddenProblemTotalNum'] ?? 0}',style: TextStyle(color: Color(0xff323233),fontSize: sp(32),fontFamily: "M"),),
               ],
             ),
           ],
         ),
         Row(
           children: [
             Container(
               width: px(88),
               height: px(130),
               margin: EdgeInsets.only(right: px(24),left: px(24)),
               child: Image.asset('lib/assets/icons/home/total_quantity.png',fit: BoxFit.fitHeight,),
             ),
             Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 Text('执行任务总次数',style: TextStyle(color: Color(0xff323233),fontSize: sp(26)),),
                 Text('${taskDay['recheckTaskYearNum'] ?? 0}',style: TextStyle(color: Color(0xff323233),fontSize: sp(32),fontFamily: "M"),),
               ],
             ),
             Container(
               width: px(88),
               height: px(130),
               margin: EdgeInsets.only(right: px(24),left: px(24)),
               child: Image.asset('lib/assets/icons/home/discover.png',fit: BoxFit.fitHeight,),
             ),
             Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 Text('任务年度总数量',style: TextStyle(color: Color(0xff323233),fontSize: sp(26)),),
                 Text('${taskDay['taskYearNum'] ?? 0}',style: TextStyle(color: Color(0xff323233),fontSize: sp(32),fontFamily: "M"),),
               ],
             ),
           ],
         ),
       ],
     ),
   );
  }
  ///功能分类
  Widget classification(){
   return Container(
     margin: EdgeInsets.only(left: px(24),right: px(24),bottom: px(24)),
     padding: EdgeInsets.only(top: px(12),left: px(12),right: px(12)),
     child: GridView.builder(
       shrinkWrap:true,
       physics: NeverScrollableScrollPhysics(),
       padding: EdgeInsets.all(0),
       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
         crossAxisCount: 4,
         crossAxisSpacing: 12,
         mainAxisSpacing: 12,
       ),
       itemCount: classify.length,
       itemBuilder: (BuildContext context, int index) {
         return InkWell(
           child: Column(
             mainAxisAlignment: MainAxisAlignment.center,
             children: [
               Stack(
                 alignment: AlignmentDirectional.center,
                 children: [
                   SizedBox(
                     width: px(96),
                     height: px(96),
                     child: Image.asset('${classify[index]['icon']}'),
                   ),
                   index == 1 && total != 0?
                   Positioned(
                     right: 0,
                     top: 0,
                     child: Container(
                       padding: EdgeInsets.only(left: px(8),right: px(8)),
                       child: Text("$total",style: TextStyle(fontSize: sp(26),color: Colors.white),),
                       decoration: BoxDecoration(
                         color: Colors.red,
                         borderRadius: BorderRadius.all(Radius.circular(px(20))),
                       ),
                     ),
                   ) :
                   Container()
                 ],
               ),
               Text('${classify[index]['name']}',style: TextStyle(color: Color(0xff323233),fontSize: sp(26)),),
             ],
           ),
           onTap: () {
             selectClass(index);
           },
         );
       },
     ),
   );
  }
}
