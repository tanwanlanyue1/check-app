import 'package:flutter/material.dart';
import 'package:scet_check/api/api.dart';
import 'package:scet_check/api/request.dart';
import 'package:scet_check/page/module_steward/personal/components/task_compon.dart';
import 'package:scet_check/utils/screen/screen.dart';

///问题进度
///arguments:{'status':问题状态,inventoryId:清单id}
class ProblemSchedule extends StatefulWidget {
  final Map? arguments;
  const ProblemSchedule({Key? key,this.arguments}) : super(key: key);

  @override
  _ProblemScheduleState createState() => _ProblemScheduleState();
}

class _ProblemScheduleState extends State<ProblemSchedule> {
  int status = 0;//状态 0:下发任务，1：新建排查流程 2：审核中 3：审核不通过 4：审核通过 5:填报整改详情 6:复查未整改 7:整改完成
  Color blues = Color(0xFF4D7FFF); //流程已完成
  Color blacks = Color(0xFF323232);//流程未经过
  bool task = false;//是否为任务
  String uuid = '';//清单id
  int inventoryStatus = 0;//清单的状态码

  @override
  void initState() {
    uuid = widget.arguments?['inventoryId'] ?? '';
    _getCompany();
    super.initState();
  }
  /// 获取清单详情
  /// id:清单id
  /// argumentMap 提交问题传递的参数
  void _getCompany() async {
    var response = await Request().get(Api.url['inventory']+'/$uuid',);
    if(response['statusCode'] == 200 && response['data'] != null) {
      setState(() {
        inventoryStatus = response['data']['status'];
        task = response['data']['latitude'] == null ? true : false; //判断是否从任务过来
        flow();
      });
    }
  }

  ///判断流程
    void flow(){
      if(inventoryStatus == 1){
        status = 4;
        if(widget.arguments?['status'] == 2){
          status = 5;
        }else if(widget.arguments?['status'] == 3){
          status = 7;
        }else if(widget.arguments?['status'] == 4){
          status = 6;
        }
      }else if(inventoryStatus == 2){
        status = 7;
      }else if(inventoryStatus == 3){
        status = 2;
      }else if(inventoryStatus == 5){
        status = 3;
      }else if(inventoryStatus == 6){
        status = 1;
      }
    }
  ///判断颜色
  ///colorStatus 状态大于当前颜色状态，就可以选中
  ///also 并且的状态
  ///only 唯一的状态
  Color switchColor({int? colorStatus,int? also,int? only}){
    if(also == null && only == null){
      return status >= colorStatus! ? blues : blacks;
    }else if(also != null){
      return (status >= colorStatus! && status != also) ? blues : blacks;
    }else{
      return status == only ? blues : blacks;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TaskCompon.topTitle(
              title: '流程状态',
              left: true,
              callBack: (){
                Navigator.pop(context);
              }
          ),
          Container(
            height: px(80),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    child: Text('项目经理',style: TextStyle(color: Colors.black,fontFamily: 'M',fontSize: sp(32)),),
                  ),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    child: Text('管家人员',style: TextStyle(color: Colors.black,fontFamily: 'M',fontSize: sp(32)),),
                  ),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    child: Text('企业',style: TextStyle(color: Colors.black,fontFamily: 'M',fontSize: sp(32)),),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                processBox(),
                processLine(),
                CustomPaint(
                  painter: MyPainter(),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  ///流程盒子
  Widget processBox(){
    return ListView(
      padding: EdgeInsets.only(top: 0),
      children: [
        //下发排查任务
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            task ?
            Container(
              margin: EdgeInsets.only(left: px(24),top: px(24)),
              padding: EdgeInsets.only(left: px(12),right: px(12),top: px(6)),
              height: px(52),
              child: Text("下发排查任务",style: TextStyle(fontSize: sp(22),color: switchColor(colorStatus: 0)),),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(px(5))),
                border: Border.all(width: px(4),color: switchColor(colorStatus: 0)),
              ),
            ) : Container(
              height: px(75),
            ),
          ],
        ),
        //新建排查流程
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(left: px(24),top: px(24)),
              padding: EdgeInsets.only(left: px(12),right: px(12),top: px(6)),
              height: px(52),
              child: Text("新建排查流程",style: TextStyle(fontSize: sp(22),color: switchColor(colorStatus:1)),),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(px(5))),
                border: Border.all(width: px(4),color: switchColor(colorStatus:1)),
              ),
            )
          ],
        ),
        //填报并提交
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(left: px(24),top: px(80)),
              padding: EdgeInsets.only(left: px(12),right: px(12)),
              height: px(52),
              width: px(165),
              alignment: Alignment.center,
              child: Text("填报并提交",style: TextStyle(fontSize: sp(22),color: switchColor(colorStatus:2)),),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(px(5))),
                border: Border.all(width: px(4),color: switchColor(colorStatus:2)),
              ),
            )
          ],
        ),
        //审核
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(left: px(24),top: px(50)),
              padding: EdgeInsets.only(left: px(12),right: px(12)),
              height: px(52),
              width: px(165),
              alignment: Alignment.center,
              child: Text("审核",style: TextStyle(fontSize: sp(22),color: switchColor(colorStatus:3)),),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(px(5))),
                border: Border.all(width: px(4),color: switchColor(colorStatus:3)),
              ),
            ),
          ],
        ),
        //填报整改详情
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              margin: EdgeInsets.only(right: px(24),top: px(50)),
              padding: EdgeInsets.only(left: px(12),right: px(12)),
              height: px(52),
              width: px(165),
              alignment: Alignment.center,
              child: Text("填报整改详情",style: TextStyle(fontSize: sp(22),color: switchColor(colorStatus:5)),),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(px(5))),
                border: Border.all(width: px(4),color: switchColor(colorStatus:5)),
              ),
            )
          ],
        ),
        //现场复查
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(left: px(24),top: px(80)),
              padding: EdgeInsets.only(left: px(12),right: px(12)),
              height: px(52),
              width: px(165),
              alignment: Alignment.center,
              child: Text("现场复查",style: TextStyle(fontSize: sp(22),color: switchColor(colorStatus:5)),),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(px(5))),
                border: Border.all(width: px(4),color: switchColor(colorStatus:5)),
              ),
            )
          ],
        ),
        //再次整改并填报
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              margin: EdgeInsets.only(right: px(24),top: px(50)),
              padding: EdgeInsets.only(left: px(24),right: px(24)),
              height: px(72),
              width: px(165),
              alignment: Alignment.center,
              child: Text("再次整改并填报",style: TextStyle(fontSize: sp(22),color: switchColor(only:6)),),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(px(5))),
                border: Border.all(width: px(4),color: switchColor(only:6)),
              ),
            )
          ],
        ),
        //流程结束
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(left: px(24),top: px(80)),
              padding: EdgeInsets.only(left: px(12),right: px(12)),
              height: px(52),
              width: px(165),
              alignment: Alignment.center,
              child: Text("流程结束",style: TextStyle(fontSize: sp(22),color: switchColor(colorStatus:7)),),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(px(5))),
                border: Border.all(width: px(4),color: switchColor(colorStatus:7)),
              ),
            )
          ],
        ),
      ],
    );
  }

  ///流程线条
  Widget processLine(){
    return Stack(
      children: [
        //下发排查任务
        task ?
        Positioned(
          left: px(100),
          top: px(75),
          child: Container(
            width: px(4),
            height: px(50),
            color: switchColor(colorStatus:0),
          ),
        ) : Container(),
        task ?
        Positioned(
          left: px(100),
          top: px(125),
          child: Container(
            width: px(195),
            height: px(4),
            color: switchColor(colorStatus:0),
          ),
        ) : Container(),
        task ?
        Positioned(
          left: px(275),
          top: px(102),
          child: Icon(Icons.arrow_right,color: switchColor(colorStatus:0),),
        ) : Container(),

        //新建排查流程
        Positioned(
          left: px(390),
          top: px(153),
          child: Container(
            width: px(4),
            height: px(68),
            color: switchColor(colorStatus:1),
          ),
        ),
        Positioned(
          left: px(368),
          top: px(200),
          child: Icon(Icons.arrow_drop_down,color: switchColor(colorStatus:1),),
        ),

        //审核中
        Positioned(
          left: px(390),
          top: px(285),
          child: Container(
            width: px(4),
            height: px(70),
            color: switchColor(colorStatus:2,also: 3),
          ),
        ),
        Positioned(
          left: px(200),
          top: px(355),
          child: Container(
            width: px(195),
            height: px(4),
            color: switchColor(colorStatus:2,also: 3),
          ),
        ),
        Positioned(
          left: px(175),
          top: px(333),
          child: Icon(Icons.arrow_left_outlined,color: switchColor(colorStatus:2,also: 3),),
        ),

        //审核不通过
        Positioned(
          left: px(100),
          top: px(256),
          child: Container(
            width: px(4),
            height: px(80),
            color: switchColor(only: 3),
          ),
        ),
        Positioned(
          left: px(100),
          top: px(256),
          child: Container(
            width: px(200),
            height: px(4),
            color: switchColor(only:3),
          ),
        ),
        Positioned(
          left: px(150),
          top: px(220),
          child: Text("不通过",style: TextStyle(fontSize: sp(22),color: switchColor(only:3)),),
        ),
        Positioned(
          left: px(275),
          top: px(236),
          child: Icon(Icons.arrow_right,color: switchColor(only:3),),
        ),

        //审核通过
        Positioned(
          left: px(100),
          top: px(384),
          child: Container(
            width: px(4),
            height: px(80),
            color: switchColor(colorStatus: 4),
          ),
        ),
        Positioned(
          left: px(100),
          top: px(464),
          child: Container(
            width: px(450),
            height: px(4),
            color: switchColor(colorStatus: 4),
          ),
        ),
        Positioned(
          left: px(270),
          top: px(430),
          child: Text("通过",style: TextStyle(fontSize: sp(22),color: switchColor(colorStatus: 4),),),
        ),
        Positioned(
          left: px(530),
          top: px(443),
          child: Icon(Icons.arrow_right,color: switchColor(colorStatus: 4),),
        ),

        //复查中
        Positioned(
          left: px(640),
          top: px(484),
          child: Container(
            width: px(4),
            height: px(110),
            color: switchColor(colorStatus: 5),
          ),
        ),
        Positioned(
          left: px(480),
          top: px(590),
          child: Container(
            width: px(160),
            height: px(4),
            color: switchColor(colorStatus: 5),
          ),
        ),
        Positioned(
          left: px(452),
          top: px(570),
          child: Icon(Icons.arrow_left,color: switchColor(colorStatus: 5)),
        ),

        //复查未整改
        Positioned(
          left: px(380),
          top: px(620),
          child: Container(
            width: px(4),
            height: px(80),
            color: switchColor(colorStatus: 6),
          ),
        ),
        Positioned(
          left: px(380),
          top: px(700),
          child: Container(
            width: px(170),
            height: px(4),
            color: switchColor(only: 6),
          ),
        ),
        Positioned(
          left: px(440),
          top: px(650),
          child: Text("未整改",style: TextStyle(fontSize: sp(22),color: switchColor(only: 6)),),
        ),
        Positioned(
          left: px(530),
          top: px(678),
          child: Icon(Icons.arrow_right,color: switchColor(only: 6)),
        ),

        //整改完成
        Positioned(
          left: px(380),
          top: px(700),
          child: Container(
            width: px(4),
            height: px(110),
            color: switchColor(colorStatus: 7),
          ),
        ),
        Positioned(
          left: px(280),
          top: px(700),
          child: Text("整改完成",style: TextStyle(fontSize: sp(22),color: switchColor(colorStatus: 7),),),
        ),
        Positioned(
          left: px(358),
          top: px(790),
          child: Icon(Icons.arrow_drop_down,color: switchColor(colorStatus: 7),),
        ),

      ],
    );
  }
}

class MyPainter extends CustomPainter {
  List? data;
  Offset? startPoint;

  MyPainter({this.data, Offset? startPoint}) {
    this.startPoint = startPoint ?? Offset(0,0);
  }
  Color colors = Color(0xff6688CC);
  double marginTB = px(8); // 盒子的上下边距
  double fontSize = sp(22); //文字大小
  double tpPaddingLR = px(14); //文字左右边距
  double tpPaddingTB = px(6); //文字上下边距
  double pathWidth = px(24); //下级延申的线宽

  // 头部启动函数
  header({Map? relation,required Canvas canvas}){
    double x = startPoint!.dx;
    double y = startPoint!.dy;

    var paint = Paint();
    paint.color = Color(0xff969799);
    paint.strokeWidth  = px(2);

    // 文字
    // TextSpan textSpan = TextSpan(style: TextStyle(color: Colors.white,fontSize: fontSize), text: 'qwe');
    //
    // TextPainter tp = TextPainter(
    //     text: textSpan,
    //     textAlign: TextAlign.center,
    //     textDirection: TextDirection.ltr
    // );
    // tp.layout();
    // double width = tp.width + ( tpPaddingLR * 2); //盒子宽
    // double height = tp.height + (tpPaddingTB * 2) + marginTB * 2; //盒子高
    //起点
    // canvas.drawRRect(RRect.fromLTRBR(
    //     px(24),
    //     px(30),
    //     px(24) + width,
    //     px(30) + height,
    //     Radius.circular(4)
    // ),paint);

    //文字
    // tp.paint(
    //     canvas,
    //      Offset(x, tp.height+(tpPaddingTB))
    // );
    //
    // paint.style = PaintingStyle.stroke;
    //
    //   canvas.drawLine(
    //       Offset(x + width/2, y + height-marginTB,),
    //       Offset(x + width/2, y,),
    //       paint
    //   );
    //   canvas.drawLine(
    //       Offset(x + width + px(36), y + height - marginTB,),
    //       Offset(x + width/2, y + height - marginTB,),
    //       paint
    //   );

     ///虚线
    canvas.drawLine(
        Offset(x  + px(240), y,),
        Offset(x + px(240), y + Adapt.screenH()-px(300),),
        paint
    );
    ///虚线
    canvas.drawLine(
        Offset(x  + px(520), y,),
        Offset(x + px(520), y + Adapt.screenH()-px(300),),
        paint
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    header(canvas: canvas);
  }

  //在实际场景中正确利用此回调可以避免重绘开销，本示例我们简单的返回true
  @override
  bool shouldRepaint(MyPainter oldDelegate) {
    return this != oldDelegate;
  }
}