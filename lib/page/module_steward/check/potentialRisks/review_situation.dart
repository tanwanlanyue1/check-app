import 'package:flutter/material.dart';
import 'package:scet_check/components/form_check.dart';
import 'package:scet_check/components/generalduty/image_widget.dart';
import 'package:scet_check/components/time_select.dart';
import 'package:scet_check/components/upload_image.dart';
import 'package:scet_check/utils/screen/screen.dart';

///复查情况
class ReviewSituation extends StatefulWidget {
  final Map? arguments;
  final Function? callBack;
  const ReviewSituation({Key? key,this.arguments,this.callBack}) : super(key: key);

  @override
  _ReviewSituationState createState() => _ReviewSituationState();
}

class _ReviewSituationState extends State<ReviewSituation> {
  //图片列表
  List imgDetails = ['https://img2.baidu.com/it/u=1814268193,3619863984&fm=253&fmt=auto&app=138&f=JPEG?w=632&h=500',
    'https://img0.baidu.com/it/u=857510153,4267238650&fm=253&fmt=auto&app=120&f=JPEG?w=1200&h=675',
    'https://img1.baidu.com/it/u=2374960005,3369337623&fm=253&fmt=auto&app=120&f=JPEG?w=499&h=312',
    'https://img0.baidu.com/it/u=857510153,4267238650&fm=253&fmt=auto&app=120&f=JPEG?w=1200&h=675',
  ];
  bool _readOnly = true; //是否为只读
  late GlobalKey<ScaffoldState> _scaffoldKey;//时间选择key
  int choice  = 0; //单选 1-是 0-否

  @override
  void initState() {
    // TODO: implement initState
    _readOnly = widget.arguments?['readOnly'] ?? true;
    _scaffoldKey = widget.arguments?['key'];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Visibility(
          visible: _readOnly,
          //危废清单现场复查情况
          child: FormCheck.dataCard(
              children: [
                FormCheck.formTitle('现场复查情况'),
                FormCheck.rowItem(
                  title: "复查人员",
                  child: Text('陈秋好',style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),),
                ),
                FormCheck.rowItem(
                  title: "复查时间",
                  child: Text('2021-12-03',style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),),
                ),
                FormCheck.rowItem(
                  title: "是否整改",
                  child: Text('是',style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),),
                ),
                FormCheck.rowItem(
                  title: "复查详情",
                  child: Container(
                    color: Color(0xffF5F6F7),
                    child: Text('危废台账已按种类单独整理',style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),),
                  ),
                ),
                FormCheck.rowItem(
                    alignStart: true,
                    title: "复查图片记录",
                    child: ImageWidget(
                      imageList: imgDetails,
                    )
                ),
                FormCheck.rowItem(
                  title: "其他说明",
                  child: Text('暂无',style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),),
                ),
              ]
          ),
          replacement: FormCheck.dataCard(
              children: [
                FormCheck.formTitle('现场复查情况'),
                FormCheck.rowItem(
                  title: "复查时间",
                  child: TimeSelect(
                    scaffoldKey: _scaffoldKey,
                    hintText: "请选择整改期限",
                    callBack: (time) {},
                  ),
                ),
                FormCheck.rowItem(
                  title: "复查人员",
                  child: FormCheck.inputWidget(hintText: '陈秋好'),
                ),
                FormCheck.rowItem(
                  title: "复查详情",
                  child: FormCheck.inputWidget(hintText: ''),
                ),
                FormCheck.rowItem(
                    title: "复查图片记录",
                    alignStart: true,
                    child: UploadImage(
                      imgList: imgDetails,
                      closeIcon: !_readOnly,
                      callback: (List? data) {
                        if (data != null) {
                          imgDetails = data;
                        }
                        setState(() {});
                      },
                    )
                ),
                FormCheck.rowItem(
                  title: "是否整改",
                  child: _radio(),
                ),
                FormCheck.rowItem(
                  title: "其他说明",
                  child: FormCheck.inputWidget(hintText: ''),
                ),
              ]
          ),
        ),
      ],
    );
  }

  ///单选
  Widget _radio() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          child: Radio(
            value: 0,
            groupValue: choice,
            onChanged: (int? value) {
              setState(() {
                choice = value as int;
              });
            },
          ),
          width: px(70),
        ),
        Text(
          "是",
          style: TextStyle(fontSize: sp(28)),
        ),
        SizedBox(
          child: Radio(
            value: 1,
            groupValue: choice,
            onChanged: (value) {
              setState(() {
                choice = value as int;
              });
            },
          ),
          width: px(70),
        ),
        Text(
          "否",
          style: TextStyle(fontSize: sp(28)),
        )
      ],
    );
  }
}
