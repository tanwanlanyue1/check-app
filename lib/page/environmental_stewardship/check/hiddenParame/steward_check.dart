import 'package:flutter/material.dart';
import 'package:scet_check/components/form_check.dart';
import 'package:scet_check/page/environmental_stewardship/law/components/law_components.dart';
import 'package:scet_check/utils/dateUtc/date_utc.dart';
import 'package:scet_check/utils/screen/screen.dart';

import 'components/rectify_components.dart';

//管家排查
class StewardCheck extends StatefulWidget {
  const StewardCheck({Key? key}) : super(key: key);

  @override
  _StewardCheckState createState() => _StewardCheckState();
}

class _StewardCheckState extends State<StewardCheck> {
  int type = 0;
  bool packups = true;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Color(0xffF5F6FA),
      child: ListView(
        padding: EdgeInsets.only(top: 0),
        children: [
          topBar(
            '2021-12-14管家排查'
          ),
          survey(),
          concerns(),
          rectification(),
        ],
      ),
    );
  }

  Widget topBar(String title){
    return Container(
      color: Colors.white,
      height: px(88),
      margin: EdgeInsets.only(top: Adapt.padTopH()),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
          child: Container(
            height: px(40),
            width: px(41),
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(left: px(20)),
            child: Image.asset('lib/assets/icons/other/chevronLeft.png',fit: BoxFit.fill,),
          ),
          onTap: (){
            Navigator.pop(context);
          },
        ),
          Expanded(
            flex: 2,
            child: Container(
              alignment: Alignment.centerRight,
              child: Text(title,style: TextStyle(color: Color(0xff323233),fontSize: sp(32),fontFamily: 'M'),),
            ),
          ),
          Container(
            height: px(28),
            width: px(28),
            margin: EdgeInsets.only(bottom: px(15),left: px(12)),
            child: Icon(Icons.star,color: Color(0xffE65C5C),),
          ),
          Spacer(),
        ],
      ),
    );
  }

  //排查概况
  Widget survey(){
    return Container(
      padding: EdgeInsets.only(left: px(24),right: px(24)),
      color: Colors.white,
      child: Visibility(
        visible: packups,
        child: FormCheck.dataCard(
            children: [
              FormCheck.formTitle(
                  '排查概况',
                  showUp: true,
                  packups: packups,
                  onTaps: (){
                    packups = !packups;
                    setState(() {});
                  }
              ),
              surveyItem('归属片区','第一片区'),
              surveyItem('区域位置','西区'),
              surveyItem('环保局检查人','张鹏'),
              surveyItem('管家检查人','张文里、陈秋好'),
              surveyItem('检查类型','管家排查'),
              surveyItem('排查日期','2021-12-14'),
              surveyItem('整改截至日期','2021-4-19'),
              surveyItem('现场复查日期','2021-4-19'),
            ]
        ),
        replacement: SizedBox(
          height: px(88),
          child: FormCheck.formTitle(
              '排查概况',
              showUp: true,
              packups: packups,
              onTaps: (){
                packups = !packups;
                setState(() {});
              }
          ),
        ),
      ),
    );
  }

//概况列表
  Widget surveyItem(String title,String data){
    return Container(
      margin: EdgeInsets.only(top: px(24)),
      child: FormCheck.rowItem(
        title: title,
        expandedLeft: true,
        child: Text(data,style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),textAlign: TextAlign.right,),
      ),
    );
  }

  //隐患问题
  Widget concerns(){
    return Container(
      margin: EdgeInsets.only(top: px(4)),
      color: Colors.white,
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: px(20),left: px(32),),
            child: FormCheck.formTitle(
              '隐患问题',
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: px(20),left: px(20),right: px(20)),
            padding: EdgeInsets.only(left: px(16),bottom: px(20)),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xffE8E8E8),width: px(2)))
            ),
            child: InkWell(
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: px(5)),
                        child: Text('1',style: TextStyle(color: Color(0xff4D7FFF),fontSize: sp(28)),),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: px(16),right: px(16),top: px(5)),
                        child: Text('name',style: TextStyle(color: Color(0xff323233),fontSize: sp(30)),),
                      ),
                      SizedBox(
                        height: px(28),
                        width: px(28),
                        child: Icon(Icons.star,color: Color(0xffE65C5C),),
                      ),
                      Spacer(),
                      Container(
                        width: px(100),
                        height: px(48),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: type == -1 ? Color(0xffFAAA5A):
                            type == 1 ? Color(0xff7196F5):
                            Color(0xff95C758),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(px(20)),
                              bottomLeft: Radius.circular(px(20)),
                            )
                        ),//状态；-1：未处理;0:处理完；1：处理中
                        child: Text(type == -1 ? '未整改':
                        type == 1 ? '整改中':'整改完成'
                          ,style: TextStyle(color: Colors.white,fontSize: sp(24)),),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(top: px(20)),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          height: px(18),
                          width: px(18),
                          margin: EdgeInsets.only(left: px(12)),
                          child: Icon(Icons.widgets_outlined,color: Color(0xffC8C9CC),size: 18,),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: px(24),right: px(80)),
                          child: Text('废气',style: TextStyle(color: Color(0xff969799),fontSize: sp(24)),),
                        ),
                        SizedBox(
                          height: px(32),
                          width: px(32),
                          child: Image.asset('lib/assets/icons/check/sandClock.png'),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: px(12),right: px(80)),
                          child: Text('2021-12-14',style: TextStyle(color: Color(0xff969799),fontSize: sp(24)),),
                        ),
                        SizedBox(
                          height: px(32),
                          width: px(32),
                          child: Image.asset('lib/assets/icons/check/sandClockEnd.png'),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: px(12)),
                          child: Text('2021-12-14',style: TextStyle(color: Color(0xff969799),fontSize: sp(24)),),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              onTap: (){
              },
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: px(20),left: px(20),right: px(20)),
            padding: EdgeInsets.only(left: px(16),bottom: px(20)),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(px(4.0))),
            ),
            child: InkWell(
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: px(5)),
                        child: Text('1',style: TextStyle(color: Color(0xff4D7FFF),fontSize: sp(28)),),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: px(16),right: px(16),top: px(5)),
                        child: Text('name',style: TextStyle(color: Color(0xff323233),fontSize: sp(30)),),
                      ),
                      SizedBox(
                        height: px(28),
                        width: px(28),
                        child: Icon(Icons.star,color: Color(0xffE65C5C),),
                      ),
                      Spacer(),
                      Container(
                        width: px(100),
                        height: px(48),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: type == -1 ? Color(0xffFAAA5A):
                            type == 1 ? Color(0xff7196F5):
                            Color(0xff95C758),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(px(20)),
                              bottomLeft: Radius.circular(px(20)),
                            )
                        ),//状态；-1：未处理;0:处理完；1：处理中
                        child: Text(type == -1 ? '未整改':
                        type == 1 ? '整改中':'整改完成'
                          ,style: TextStyle(color: Colors.white,fontSize: sp(24)),),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(top: px(20)),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          height: px(18),
                          width: px(18),
                          margin: EdgeInsets.only(left: px(12)),
                          child: Icon(Icons.widgets_outlined,color: Color(0xffC8C9CC),size: 18,),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: px(24),right: px(80)),
                          child: Text('废气',style: TextStyle(color: Color(0xff969799),fontSize: sp(24)),),
                        ),
                        SizedBox(
                          height: px(32),
                          width: px(32),
                          child: Image.asset('lib/assets/icons/check/sandClock.png'),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: px(12),right: px(80)),
                          child: Text('2021-12-14',style: TextStyle(color: Color(0xff969799),fontSize: sp(24)),),
                        ),
                        SizedBox(
                          height: px(32),
                          width: px(32),
                          child: Image.asset('lib/assets/icons/check/sandClockEnd.png'),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: px(12)),
                          child: Text('2021-12-14',style: TextStyle(color: Color(0xff969799),fontSize: sp(24)),),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              onTap: (){
              },
            ),
          ),
        ],
      ),
    );
  }
  //整改报告
  Widget rectification(){
    return Container(
      margin: EdgeInsets.only(top: px(4),bottom: px(20)),
      color: Colors.white,
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: px(20),left: px(32),),
            child: FormCheck.formTitle(
              '整改报告',
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: px(20),left: px(20),right: px(20)),
            padding: EdgeInsets.only(left: px(16),bottom: px(20)),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(px(4.0))),
            ),
            child: InkWell(
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LawComponents.rowTwo(
                          child: Image.asset('lib/assets/icons/check/PDF.png'),
                          textChild: Text('21-12-14隐患排查问题-整改完成报告',style: TextStyle(color: Color(0xff323233),fontSize: sp(26)),)
                      ),
                      Spacer(),
                      Container(
                        height: px(40),
                        width: px(41),
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(left: px(20)),
                        child: Image.asset('lib/assets/icons/other/right.png',color: Colors.grey,),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(top: px(20)),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          height: px(32),
                          width: px(32),
                          margin: EdgeInsets.only(left: px(12)),
                          child: Image.asset('lib/assets/icons/check/time.png',color:Color(0xff6089F0),),
                        ),
                        Container(
                          margin: EdgeInsets.only(right: px(138)),
                          child: Text('审核中',style: TextStyle(color: Color(0xff6089F0),fontSize: sp(24)),),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: px(12)),
                          child: Text('提交时间:',style: TextStyle(color: Color(0xffC8C9CC),fontSize: sp(24)),),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: px(12)),
                          child: Text('2021-12-14',style: TextStyle(color: Color(0xffC8C9CC),fontSize: sp(24)),),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              onTap: (){
              },
            ),
          ),
        ],
      ),
    );
  }
  //日期转换
  String formatTime(time) {
    return dateUtc(time.toString()).substring(0,10);
  }
}
