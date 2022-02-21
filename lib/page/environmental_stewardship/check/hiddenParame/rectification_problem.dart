import 'package:flutter/material.dart';
import 'package:scet_check/components/down_input.dart';
import 'package:scet_check/components/form_check.dart';
import 'package:scet_check/components/toast_widget.dart';
import 'package:scet_check/utils/screen/screen.dart';

class RectificationProblem extends StatefulWidget {
  const RectificationProblem({Key? key}) : super(key: key);

  @override
  _RectificationProblemState createState() => _RectificationProblemState();
}

//企业台账详情

class _RectificationProblemState extends State<RectificationProblem> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          topBar(),
          Container(
            color: Colors.white,
            child: FormCheck.tabText(title: "01",str: '废气治理设施巡检记录不完善'),
          ),
          FormCheck.rowItem(
            title: "表单标题",
            alignStart: true,
            child: Container(
              height: px(170),
              color: Colors.brown,
              child: Text("asd"),
            )
          ),
          FormCheck.selectWidget(
            hintText: '提示',
            items: [{'name':'selectWidget','value':'452'},{'name':'名字','value':'42'},{'name':'选项','value':'1452'}],
            value: '名字'
          ),
          FormCheck.dataCard(
            children: [
              DownInput(
                data: [{'name':'123','id':1},{'name':'asd'}],
                callback: (val){
                  ToastWidget.showDialog(
                    msg: '是否选择这一项？+ $val',
                  );
                },
                currentData:{'name':'asd'},
                value: '123',
              ),
            ]
          ),
          // Padding(
          //   padding: EdgeInsets.symmetric(vertical: 8.0),
          //   child: Row(
          //     children: [
          //       SizedBox(
          //         height: 24.0,
          //         child: ElevatedButton(
          //             style: ButtonStyle(
          //                 backgroundColor: MaterialStateProperty.all<Color>(Color(0XFF2288F4)),
          //             ),
          //           onPressed: () async{
          //             position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
          //                 // .then((value){});
          //             print('纬度===${position!.latitude}');
          //             print('经度===${position!.longitude}');
          //             setState(() {});
          //           },
          //           child: Text(
          //             '获取定位',
          //             style: TextStyle(
          //                 color: Colors.white,
          //             ),
          //           ),
          //         ),
          //       ),
          //       Text('纬度:${position?.latitude},经度:${position?.longitude}')
          //     ],
          //   ),
          // ),
          // Container(
          //   width: px(300),
          //   height: px(120),
          //   color: Colors.teal,
          //   alignment: Alignment.center,
          //   child:DialogPages.succeedDialogBtn(
          //     str: '弹窗',
          //     bgColor: Color(0xFF8F98B3),
          //     onTap: () {
          //       DialogPages.dialog(context);
          //     },
          //   ),
          // ),
          // DateRange(
          //   start: start,
          //   end: end,
          //   callBack: (val){
          //     start = val[0];
          //     end = val[1];
          //     setState(() {});
          //   },
          // ),
        ],
      ),
    );
  }

  //头部
  Widget topBar(){
    return Container(
      color: Colors.white,
      height: px(88),
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
            },
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Text("标题",style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),),
            ),
          ),
          Container(
            width: px(40),
            height: px(41),
            margin: EdgeInsets.only(right: px(20)),
            color: Colors.transparent,
          ),
        ],
      ),
    );
  }

}
