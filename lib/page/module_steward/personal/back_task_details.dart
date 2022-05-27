import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:scet_check/api/api.dart';
import 'package:scet_check/components/generalduty/down_input.dart';
import 'package:scet_check/components/generalduty/upload_image.dart';
import 'package:scet_check/components/pertinence/companyFile/components/file_system.dart';
import 'package:scet_check/page/module_steward/check/statisticAnaly/components/form_check.dart';
import 'package:scet_check/utils/screen/screen.dart';
import 'package:scet_check/utils/storage/data_storage_key.dart';
import 'package:scet_check/utils/storage/storage.dart';

import 'components/task_compon.dart';


///填报待办任务详情
///arguments:{id：任务id}
class BackTaskDetails extends StatefulWidget {
  final Map? arguments;
  const BackTaskDetails({Key? key,this.arguments}) : super(key: key);

  @override
  _BackTaskDetailsState createState() => _BackTaskDetailsState();
}

class _BackTaskDetailsState extends State<BackTaskDetails> {
  List imgDetails = [];//任务图片列表
  String userName = ''; //用户名
  bool check = false;//是否选择
  /// 上传文件
  /// result: 文件数组
  /// 处理上传图片返回回来的格式，将\转化为/
  void _upload() async {
    String url = '';
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.any,
    );
    if (result != null) {
      var isUp = await FileSystem.upload(result, url);
      if(isUp?[0]!=false){

      }
      setState(() {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    userName= jsonDecode(StorageUtil().getString(StorageKey.PersonalData))['nickname'];
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // TaskCompon.topTitle(
          //     title: '待办任务-未处理',
          //     left: true,
          //     font: 32,
          //     callBack: (){
          //       Navigator.pop(context);
          //     }
          // ),
          Container(
            width: px(750),
            height: Adapt.padTopH(),
            color: Color(0xff19191A),
          ),
          Container(
            height: px(88),
            child: Row(
              children: [
                InkWell(
                  child: Container(
                    height: px(88),
                    width: px(55),
                    color: Colors.transparent,
                    padding: EdgeInsets.only(left: px(12)),
                    margin: EdgeInsets.only(left: px(12)),
                    child: Image.asset('lib/assets/icons/other/chevronLeft.png',),
                  ),
                  onTap: (){
                    Navigator.pop(context);
                  },
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    alignment: Alignment.center,
                    child: Text('待办任务',style: TextStyle(color: Color(0xff323233),fontSize: sp(36),fontFamily: 'M'),),
                  ),
                ),
                GestureDetector(
                  child: Container(
                      margin: EdgeInsets.only(right: px(20)),
                      child: Text('选择',style: TextStyle(color: Color(0xff323233),fontSize: sp(24)),)),
                  onTap: () async{
                    Navigator.pop(context);
                    Navigator.pop(context,'true');
                  },
                )
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.only(top: 0),
              children: [
                backLog(),
                // checkAgenda(),
                check ?
                Container(
                  margin: EdgeInsets.only(left: px(24),right: px(24)),
                  child: FormCheck.submit(
                      cancels: "保存",
                      canColors: Color(0xff4D7FFF),
                      submit: (){
                        Navigator.pushNamed(context, '/taskDetails',arguments: {'backlog':true});
                      },
                      cancel: (){
                        Navigator.pop(context);
                      }
                  ),
                ):Container(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ///待办任务信息
  Widget backLog(){
    return Container(
      margin: EdgeInsets.only(left: px(24),right: px(24),top: px(24)),
      padding: EdgeInsets.only(left: px(12),right: px(12)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(px(8.0))),
      ),
      child: Column(
        children: [
          Container(
            color: Colors.white,
            margin: EdgeInsets.only(top: px(4)),
            height: px(56),
            child: FormCheck.formTitle('任务内容'),
          ),
          FormCheck.rowItem(
            title: '企业名称:',
            titleColor: Color(0XFF323232),
            child: FormCheck.inputWidget(
                hintText: '请输入企业名称',
                onChanged: (val){
                  setState(() {});
                }
            ),
          ),
          FormCheck.rowItem(
            title: '所在片区:',
            titleColor: Color(0XFF323232),
            child: Text('第三片区',style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),),
          ),
          FormCheck.rowItem(
            title: '填报人员:',
            titleColor: Color(0XFF323232),
            child: Text(userName,style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),),
          ),
          FormCheck.rowItem(
            title: '待办任务:',
            titleColor: Color(0XFF323232),
            alignStart: true,
            child: FormCheck.inputWidget(
                hintText: '请输入待办任务详情',
                lines: 3,
                onChanged: (val){
                  setState(() {});
                }
            ),
          ),
          FormCheck.rowItem(
            title: '下发时间:',
            titleColor: Color(0XFF323232),
            child: Text('2022-03-29 12:00:00',style: TextStyle(color: Color(0xff969799),fontSize: sp(28)),),
          ),
        ],
      ),
    );
  }

  ///待办检查信息
  Widget checkAgenda(){
    return Container(
      margin: EdgeInsets.only(left: px(24),right: px(24),top: px(24)),
      padding: EdgeInsets.only(left: px(12),right: px(12)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(px(8.0))),
      ),
      child: Column(
        children: [
          Container(
            color: Colors.white,
            margin: EdgeInsets.only(top: px(4)),
            height: px(56),
            child: FormCheck.formTitle('检查信息'),
          ),
          FormCheck.rowItem(
              title: '检查人员:',
              titleColor: Color(0XFF323232),
              child: DownInput(
                value: '',
                data: [],
                hitStr: '选择人员',
                callback: (val){
                  setState(() {});
                },
              )
          ),
          Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  children: [
                    SizedBox(
                        width: px(150),
                        child: Text(
                            '检查情况',
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                                color: Color(0XFF323232),
                                fontSize: sp(28.0),
                                fontWeight: FontWeight.w500
                            )
                        )
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      child: Container(
                        width: px(150),
                        height: px(50),
                        alignment: Alignment.center,
                        padding: EdgeInsets.only(right: px(24)),
                        child: Image.asset('lib/assets/icons/my/query.png'),
                      ),
                      onTap: (){
                        Navigator.pushNamed(context, '/screeningBased',arguments: {'law':false,'search':true});
                      },
                    ),
                  ],
                ),
                Expanded(
                  child: FormCheck.inputWidget(
                      hintText: '添加描述....',
                      lines: 3,
                      onChanged: (val){
                        setState(() {});
                      }
                  ),
                )
              ]
          ),
          FormCheck.rowItem(
            alignStart: true,
            title: "现场照片:",
            titleColor: Color(0XFF323232),
            child: UploadImage(
              imgList: imgDetails,
              closeIcon: true,
              url: Api.baseUrlApp + 'file/upload?savePath=问题/',
              callback: (List? data) {
                setState(() {});
              },
            ),
          ),
          FormCheck.rowItem(
            title: '附件上传',
            titleColor: Color(0XFF323232),
            child: GestureDetector(
              child: Text('添加附件',style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),),
              onTap: (){
                _upload();
              },
            ),
          ),
        ],
      ),
    );
  }

}
