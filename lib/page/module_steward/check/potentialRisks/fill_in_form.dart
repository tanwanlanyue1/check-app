import 'package:flutter/material.dart';
import 'package:scet_check/components/generalduty/down_input.dart';
import 'package:scet_check/components/form_check.dart';
import 'package:scet_check/components/generalduty/image_widget.dart';
import 'package:scet_check/components/time_select.dart';
import 'package:scet_check/components/upload_image.dart';
import 'package:scet_check/utils/screen/screen.dart';

///排查问题填报
///arguments:{declare:申报，key：时间选择key}
///callBack:回调
class FillInForm extends StatefulWidget {
  final Map? arguments;
  final Function? callBack;
  const FillInForm({Key? key,this.arguments,this.callBack}) : super(key: key);

  @override
  _FillInFormState createState() => _FillInFormState();
}

class _FillInFormState extends State<FillInForm> {
  //图片列表
  List imgDetails = [
    'https://img2.baidu.com/it/u=1814268193,3619863984&fm=253&fmt=auto&app=138&f=JPEG?w=632&h=500',
    'https://img0.baidu.com/it/u=857510153,4267238650&fm=253&fmt=auto&app=120&f=JPEG?w=1200&h=675',
    'https://img1.baidu.com/it/u=2374960005,3369337623&fm=253&fmt=auto&app=120&f=JPEG?w=499&h=312',
    'https://img0.baidu.com/it/u=857510153,4267238650&fm=253&fmt=auto&app=120&f=JPEG?w=1200&h=675',
  ];

  bool declare  = false; //申报
  late GlobalKey<ScaffoldState> _scaffoldKey;//时间选择key

  @override
  void initState() {
    // TODO: implement initState
    declare = widget.arguments?['declare'] ?? true;
    _scaffoldKey = widget.arguments?['key'];
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return FormCheck.dataCard(
        children: [
          FormCheck.formTitle('问题详情'),
          Visibility(
            visible: declare,
            child: FormCheck.rowItem(
              title: "问题序号",
              child: Text('10', style: TextStyle(
                  color: Color(0xff969799),
                  fontSize: sp(28),
                  fontFamily: 'Roboto-Condensed'),),
            ),
          ),
          FormCheck.rowItem(
              title: "排查时间",
              child: !declare ?
              Text('2021-12-06', style: TextStyle(
                  color: Color(0xff969799),
                  fontSize: sp(28),
                  fontFamily: 'Roboto-Condensed'),) :
              TimeSelect(
                scaffoldKey: _scaffoldKey,
                hintText: "请选择排查时间",
                callBack: (time) {},
              )
          ),
          FormCheck.rowItem(
            title: "排查人员",
            child: !declare ?
            Text('陈秋好', style: TextStyle(color: Color(0xff969799),
                fontSize: sp(28),
                fontFamily: 'Roboto-Condensed'),) :
            DownInput(
              value: '陈秋好',
              data: [{'name': '陈秋好'}, {"name": "张三"}],
              more: true,
            ),
          ),
          FormCheck.rowItem(
            title: "问题类型",
            child: DownInput(
              value: '废气',
              data: [{'name': '废气'}, {"name": "废物"}],
              readOnly: !declare,
            ),
          ),
          FormCheck.rowItem(
            title: "问题详情",
            child: Container(
              color: Color(0xffF5F6F7),
              child: !declare ? Text('危废台账已按种类单独整理', style: TextStyle(
                  color: Color(0xff323233), fontSize: sp(28)),)
                  : FormCheck.inputWidget(),
            ),
          ),
          FormCheck.rowItem(
              alignStart: true,
              title: "问题照片",
              child: !declare ?
              ImageWidget(
                imageList: imgDetails,
              ):
              UploadImage(
                imgList: imgDetails,
                closeIcon: !declare,
                callback: (List? data) {
                  if (data != null) {
                    imgDetails = data;
                  }
                  setState(() {});
                },
              )
          ),
          FormCheck.rowItem(
            title: "法规依据",
            child: DownInput(
              value: '中华人民共和国环境影响',
              readOnly: !declare,
              data: const[
                {'name': '中华人民共和国环境影响'},
                {"name": "废物中华人民共和国环境影响"}
              ],
            ),
          ),
          FormCheck.rowItem(
            title: "整改期限",
            child: !declare ?
            Text('2021-12-10', style: TextStyle(
                color: Color(0xff969799),
                fontSize: sp(28),
                fontFamily: 'Roboto-Condensed'),) :
            TimeSelect(
              scaffoldKey: _scaffoldKey,
              hintText: "请选择整改期限",
              callBack: (time) {},
            ),
          ),
          FormCheck.rowItem(
            title: "填报人员",
            child: !declare ?
            Text('陈秋好', style: TextStyle(color: Color(0xff969799),
                fontSize: sp(28),
                fontFamily: 'Roboto-Condensed'),) :
            FormCheck.inputWidget(hintText: '填报人员'),
          ),
          Visibility(
            visible: declare,
            child: FormCheck.submit(),
          )
        ]
    );
  }

}
