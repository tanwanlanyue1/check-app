import 'package:flutter/material.dart';
import 'package:scet_check/components/form_check.dart';
import 'package:scet_check/components/generalduty/image_widget.dart';
import 'package:scet_check/utils/screen/screen.dart';

///企业整改详情
class EnterpriseReform extends StatefulWidget {
  const EnterpriseReform({Key? key}) : super(key: key);

  @override
  _EnterpriseReformState createState() => _EnterpriseReformState();
}

class _EnterpriseReformState extends State<EnterpriseReform> {
  //图片列表
  List imgDetails = ['https://img2.baidu.com/it/u=1814268193,3619863984&fm=253&fmt=auto&app=138&f=JPEG?w=632&h=500',
    'https://img0.baidu.com/it/u=857510153,4267238650&fm=253&fmt=auto&app=120&f=JPEG?w=1200&h=675',
    'https://img1.baidu.com/it/u=2374960005,3369337623&fm=253&fmt=auto&app=120&f=JPEG?w=499&h=312',
    'https://img0.baidu.com/it/u=857510153,4267238650&fm=253&fmt=auto&app=120&f=JPEG?w=1200&h=675',
  ];
  bool readOnly = true; //是否为只读

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FormCheck.dataCard(
            children: [
              FormCheck.formTitle('企业整改详情'),
              FormCheck.rowItem(
                title: "责任人",
                child: Text('陈秋好',style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),),
              ),
              Visibility(
                visible: readOnly,
                child: FormCheck.rowItem(
                  title: "整改进度",
                  child: Text('已经整改，并提交完成整改报告。',style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),),
                ),
                replacement: FormCheck.rowItem(
                  title: "整改措施",
                  child: Text('废气治理设施巡检记录不完善,当天已整改完毕',style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),),
                ),
              ),
              FormCheck.rowItem(
                  title: "整改图片",
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
      ],
    );
  }
}
