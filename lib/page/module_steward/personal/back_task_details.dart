import 'package:flutter/material.dart';
import 'package:scet_check/components/generalduty/down_input.dart';
import 'package:scet_check/components/generalduty/upload_image.dart';
import 'package:scet_check/page/module_steward/check/hiddenParame/components/rectify_components.dart';
import 'package:scet_check/page/module_steward/check/statisticAnaly/components/form_check.dart';
import 'package:scet_check/utils/screen/screen.dart';


///填报待办任务详情
class BackTaskDetails extends StatefulWidget {
  const BackTaskDetails({Key? key}) : super(key: key);

  @override
  _BackTaskDetailsState createState() => _BackTaskDetailsState();
}

class _BackTaskDetailsState extends State<BackTaskDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: px(750),
            height: appTopPadding(context),
            color: Color(0xff19191A),
          ),
          RectifyComponents.topBar(
              title: '待办任务',
              callBack: (){
                Navigator.pop(context);
              }
          ),
          backLog(),
        ],
      ),
    );
  }

  //待办
  Widget backLog(){
    return Container(
      margin: EdgeInsets.only(left: px(24),right: px(24),top: px(24)),
      padding: EdgeInsets.only(left: px(12)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(px(8.0))),
      ),
      child: Column(
        children: [
          FormCheck.rowItem(
            title: '企业名称:',
            child: FormCheck.inputWidget(
                hintText: '请输入企业名称',
                filled: true,
                onChanged: (val){
                  setState(() {});
                }
            ),
          ),
          FormCheck.rowItem(
            title: '所在片区:',
            child: Text('第三片区',style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),),
          ),
          FormCheck.rowItem(
            title: '待办任务:',
            alignStart: true,
            child: FormCheck.inputWidget(
                hintText: '请输入待办任务详情',
                filled: true,
                lines: 3,
                onChanged: (val){
                  setState(() {});
                }
            ),
          ),
          FormCheck.rowItem(
            title: '下发时间:',
            child: Text('2022-03-29 12:00:00',style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),),
          ),
          FormCheck.rowItem(
            title: '检查人员:',
            child: DownInput(
              value: '',
              data: [],
              hitStr: '选择人员',
              callback: (val){
                setState(() {});
              },
            )
          ),
          FormCheck.rowItem(
            title: '检查情况:',
            child: FormCheck.inputWidget(
                filled: true,
                hintText: '添加描述....',
                onChanged: (val){
                  setState(() {});
                }
            ),
          ),
          FormCheck.rowItem(
            alignStart: true,
            title: "现场照片:",
            child: UploadImage(
              imgList: [],
              closeIcon: false,
            ),
          ),
          FormCheck.rowItem(
            title: '附件上传',
            child: Text('添加附件',style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),),
          ),
          Container(
            height: px(88),
            margin: EdgeInsets.only(top: px(4)),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  child: Container(
                    width: px(240),
                    height: px(56),
                    alignment: Alignment.center,
                    child: Text(
                      '保存',
                      style: TextStyle(
                          fontSize: sp(24),
                          fontFamily: "R",
                          color: Color(0xFF323233)),
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(width: px(2),color: Color(0XffE8E8E8)),
                      borderRadius: BorderRadius.all(Radius.circular(px(28))),
                    ),
                  ),
                  onTap: (){},
                ),
                GestureDetector(
                  child: Container(
                    width: px(240),
                    height: px(56),
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(left: px(40)),
                    child: Text(
                      '提交',
                      style: TextStyle(
                          fontSize: sp(24),
                          fontFamily: "R",
                          color: Colors.white),
                    ),
                    decoration: BoxDecoration(
                      color: Color(0xff4D7FFF),
                      border: Border.all(width: px(2),color: Color(0XffE8E8E8)),
                      borderRadius: BorderRadius.all(Radius.circular(px(28))),
                    ),
                  ),
                  onTap: (){
                    Navigator.pushNamed(context, '/taskDetails');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}
