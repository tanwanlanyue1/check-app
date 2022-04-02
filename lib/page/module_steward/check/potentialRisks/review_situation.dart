import 'package:flutter/material.dart';
import 'package:scet_check/page/module_steward/check/statisticAnaly/components/form_check.dart';
import 'package:scet_check/components/generalduty/image_widget.dart';
import 'package:scet_check/utils/screen/screen.dart';
import 'package:scet_check/utils/time/utc_tolocal.dart';

///复查情况
///arguments = {'problemId':问题id,'solutionList':复查数据,}
class ReviewSituation extends StatefulWidget {
  final Map? arguments;
  final Function? callBack;
  const ReviewSituation({Key? key,this.arguments,this.callBack}) : super(key: key);

  @override
  _ReviewSituationState createState() => _ReviewSituationState();
}

class _ReviewSituationState extends State<ReviewSituation> {
  List reviewList = [];//现场复查数据


  @override
  void initState() {
    // TODO: implement initState
    reviewList = widget.arguments?['reviewList'] ?? [];
    super.initState();
  }
  @override
    void didUpdateWidget(covariant ReviewSituation oldWidget) {
      // TODO: implement didUpdateWidget
    if(widget.arguments != oldWidget.arguments){
      reviewList = widget.arguments?['reviewList'] ?? [];
    }
    super.didUpdateWidget(oldWidget);
    }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.white,
          padding: EdgeInsets.only(left: px(24)),
          margin: EdgeInsets.only(top: px(4)),
          height: px(56),
          child: FormCheck.formTitle('现场复查情况'),
        ),
        Column(
          children: List.generate(reviewList.length, (i) => reviewDetile(i)),
        )
      ],
    );
  }

  ///复查情况
  Widget reviewDetile(int i){
    return FormCheck.dataCard(
        top: false,
        children: [
          FormCheck.rowItem(
            title: "复查人员",
            child: Text(reviewList[i]['reviewPerson'],style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),),
          ),
          FormCheck.rowItem(
            title: "复查时间",
            child: Text(formatTime(reviewList[i]['createdAt']),style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),),
          ),
          FormCheck.rowItem(
            title: "是否整改",
            child: Text(reviewList[i]['isSolved'] ? '是':'否',style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),),
          ),
          FormCheck.rowItem(
            title: "复查详情",
            child: Text(reviewList[i]['detail'],style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),),
          ),
          FormCheck.rowItem(
              alignStart: true,
              title: "复查图片记录",
              child: ImageWidget(
                imageList: reviewList[i]['images'],
              )
          ),
          FormCheck.rowItem(
            title: "其他说明",
            child: Text(reviewList[i]['remark'],style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),),
          ),
        ]
    );
  }
  ///日期转换
  String formatTime(time) {
    return utcToLocal(time.toString()).substring(0,10);
  }
}
