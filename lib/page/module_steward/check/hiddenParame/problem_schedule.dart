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
        task = response['data']['latitude'] == null ? true : false; //判断是否从任务过来,任务生成的清单没有坐标
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
                procesStauts(),
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
                  margin: EdgeInsets.only(left: px(24),top: px(36)),
                  child: procesBox(
                      text: '下发排查任务',
                      colorStatus: 0
                  ),
                )
                : Container(
                  margin: EdgeInsets.only(left: px(24),top: px(36)),
                  height: px(52),
                  width: px(166)
              ),
          ],
        ),
        //新建排查流程
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: px(4),
              height: px(80),
              margin: EdgeInsets.only(left: px(107)),
              color: task  ? Color(0xFF4D7FFF) : Colors.transparent,
            ),
            Container(
              width: px(180),
              height: px(4),
              margin: EdgeInsets.only(top: px(76)),
              color: task ? Color(0xFF4D7FFF) : Colors.transparent,
            ),
            Container(
              margin: EdgeInsets.only(top: px(26)),
              child: procesBox(
                  text: '新建排查流程',
                  colorStatus: 1,
                  right: task ? true : false,
                  onlyTop: 25,
                  rightColor: task ? true : false,
              ),
            ),
          ],
        ),
        //填报并提交
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: px(4),
              height: px(80),
              margin: EdgeInsets.only(left: px(24)),
              color: switchColor(colorStatus:1),
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: px(196),
                  height: px(4),
                  margin: EdgeInsets.only(top: px(36),left: px(99)),
                  color: switchColor(only: 3),
                ),
                Container(
                  width: px(4),
                  height: px(26),
                  margin: EdgeInsets.only(left: px(99)),
                  color: switchColor(only: 3),
                ),
              ],
            ),
            Container(
              child: procesBox(
                  text: '填报并提交',
                  colorStatus: 2,
                  down: true,
                  downColor: status >= 1 ? true : false,
                  right: true,
                  rightColor: status == 3 ? true : false
              ),
            ),
          ],
        ),
        //审核
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  width: px(4),
                  height: px(50),
                  color: switchColor(only: 3),
                ),
                Container(
                  margin: EdgeInsets.only(left: px(24)),
                  child: procesBox(
                      text: '审核',
                      colorStatus: 3,
                      left: true,
                      leftColor: status >= 2 ? true : false,
                  ),
                ),
              ],
            ),
            Container(
              width: px(180),
              height: px(4),
              margin: EdgeInsets.only(top: px(74)),
              color: switchColor(colorStatus:2,also: 3),
            ),
            Container(
              width: px(4),
              height: px(78),
              color: switchColor(colorStatus:2,also: 3),
            ),
          ],
        ),
        //填报整改详情
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: px(4),
              height: px(86),
              margin: EdgeInsets.only(left: px(99)),
              color: switchColor(colorStatus:4),
            ),
            Container(
              width: Adapt.screenW()-px(310),
              height: px(4),
              margin: EdgeInsets.only(top: px(82)),
              color: switchColor(colorStatus:4),
            ),
            Container(
              margin: EdgeInsets.only(top: px(58)),
              child: procesBox(
                  text: '填报整改详情',
                  colorStatus: 5,
                  right: true,
                  rightColor: status >= 4 ? true : false
              ),
            ),
          ],
        ),
        //现场复查
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(top: px(58)),
              child: procesBox(
                  text: '现场复查',
                  colorStatus: 6,
                  left: true,
                  leftColor: status >= 5 ? true : false
              ),
            ),
            Container(
              width: px(160),
              height: px(4),
              margin: EdgeInsets.only(top: px(82)),
              color: switchColor(colorStatus:5),
            ),
            Container(
              width: px(4),
              height: px(86),
              margin: EdgeInsets.only(right: px(99)),
              color: switchColor(colorStatus:5),
            ),
          ],
        ),
        //再次整改并填报
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  width: px(4),
                  height: px(84),
                  color: switchColor(colorStatus:6),
                ),
                Container(
                  width: px(4),
                  height: px(24),
                  color: switchColor(colorStatus:7),
                ),
              ],
            ),
            Container(
              width: px(160),
              height: px(4),
              margin: EdgeInsets.only(top: px(80)),
              color: switchColor(only:6),
            ),
            Container(
              margin: EdgeInsets.only(right: px(24),top: px(56)),
              child: procesBox(
                  text: '再次整改并填报',
                  only: 9,//走不到这个变色的流程,暂无可以判断的状态
                  right: true,
                  rightColor: status == 6 ? true : false
              ),
            ),
          ],
        ),
        //流程结束
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: px(4),
              height: px(92),
              margin: EdgeInsets.only(left: px(16)),
              color: switchColor(colorStatus:7),
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(left: px(16)),
              child: procesBox(
                  text: '流程结束',
                  colorStatus: 7,
                  down: true,
                  downColor: status >= 7 ? true : false
              ),
            ),
          ],
        ),
      ],
    );
  }

  ///流程状态
  Widget procesStauts(){
    return Stack(
      children: [
        Positioned(
          left: px(120),
          top: px(260),
          child: Text("不通过",style: TextStyle(fontSize: sp(22),color: switchColor(only:3)),),
        ),
        //审核通过
        Positioned(
          left: px(270),
          top: px(480),
          child: Text("通过",style: TextStyle(fontSize: sp(22),color: switchColor(colorStatus: 4),),),
        ),
        //复查未整改
        Positioned(
          left: px(440),
          top: px(700),
          child: Text("未整改",style: TextStyle(fontSize: sp(22),color: switchColor(only: 6)),),
        ),
        //整改完成
        Positioned(
          left: px(280),
          top: px(780),
          child: Text("整改完成",style: TextStyle(fontSize: sp(22),color: switchColor(colorStatus: 7),),),
        ),
      ],
    );
  }

  ///封装的盒子
  ///text:文字
  ///colorStatus,also,only：是否变色
  ///onlyTop：盒子居上距离
  Widget procesBox({required String text,int? onlyTop,
    int? colorStatus,int? also,int? only,
    bool down = false,bool right = false,bool left = false,
    bool downColor = false,bool rightColor = false,bool leftColor = false,
  }){
    return Column(
      children: [
        Visibility(
          visible: down,
          child: SizedBox(
            width: px(24),
            child: downColor ?
            Image.asset('lib/assets/icons/check/arrows-down.png'):
            Image.asset('lib/assets/icons/check/arrows-down2.png'),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Visibility(
              visible: right,
              child: Container(
                height: px(24),
                margin: EdgeInsets.only(top: px(onlyTop ?? 0)),
                child: rightColor ?
                Image.asset('lib/assets/icons/check/arrows-right.png') :
                Image.asset('lib/assets/icons/check/arrows-right2.png'),
              ),
            ),
            Container(
              height: px(52),
              width: px(166),
              margin: EdgeInsets.only(top: px(onlyTop ?? 0)),
              alignment: Alignment.center,
              child: Text(text,style: TextStyle(fontSize: sp(22),color: switchColor(
                  only:only,
                  colorStatus:colorStatus,
                  also:also
              )),),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(px(5))),
                border: Border.all(width: px(4),color: switchColor(
                    only:only,
                    colorStatus:colorStatus,
                    also:also
                )),
              ),
            ),
            Visibility(
              visible: left,
              child: SizedBox(
                height: px(24),
                child: leftColor ?
                Image.asset('lib/assets/icons/check/arrows-left.png') :
                Image.asset('lib/assets/icons/check/arrows-left2.png'),
              ),
            ),
          ],
        )
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