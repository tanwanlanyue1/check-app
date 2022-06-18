import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:scet_check/api/api.dart';
import 'package:scet_check/api/request.dart';
import 'package:scet_check/components/generalduty/toast_widget.dart';
import 'package:scet_check/components/generalduty/upload_image.dart';
import 'package:scet_check/components/pertinence/companyFile/components/file_system.dart';
import 'package:scet_check/page/module_steward/check/statisticAnaly/components/form_check.dart';
import 'package:scet_check/page/module_steward/personal/components/task_compon.dart';
import 'package:scet_check/utils/screen/screen.dart';
import 'package:scet_check/utils/storage/data_storage_key.dart';
import 'package:scet_check/utils/storage/storage.dart';
import 'package:uuid/uuid.dart';


///对接任务详情页面
///arguments：{"backlog":true,'id':任务详情}
class AbutmentTask extends StatefulWidget {
  final Map? arguments;
  const AbutmentTask({Key? key,this.arguments}) : super(key: key);

  @override
  _AbutmentTaskState createState() => _AbutmentTaskState();
}

class _AbutmentTaskState extends State<AbutmentTask> {
  Map taskDetails = {};//任务详情
  List checkImages = [];//检查图片列表
  bool backlog = true;//完成
  String userId = ''; //用户id
  List taskFiles = [];//任务附件名称
  String fileName = '';//上传附件名称
  String filePath = '';//上传附件路径

  List imgDetails = [];//任务图片列表
  String taskId = ''; //任务id
  List formDynamic = [];//动态表单id数组
  List getform = [];//缓存的动态表单

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    backlog = widget.arguments?['backlog'] ?? false;
    taskId = widget.arguments?['id'] ?? '';
    _getTasks();
  }

  /// 获取任务详情
  void _getTasks() async {
    var response = await Request().get(Api.url['houseTaskById'],
      data: {
        'taskId':taskId,
      });
    if(response?['errCode'] == '10000') {
      taskDetails = response['result'];
      List imgList = taskDetails['imgList'] ?? [];
      List fileList = taskDetails['fileList'] ?? [];
      for(var i = 0; i < imgList.length; i++){
        checkImages.add(imgList[i]['filePath']);
      }
      fileName = fileList.isNotEmpty ? fileList[0]['fileName'] : '';
      filePath = fileList.isNotEmpty ? fileList[0]['filePath'] : '';
      formDynamic = taskDetails['formList'];
      setState(() {});
    }
  }

  /// 对接任务上传文件
  /// result: 文件数组
  void _uploadTwo() async {
    String url = Api.url['addFile'];
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.any,
    );
    if (result != null) {
      var isUp = await FileSystem.upload(result, url);
      if(isUp?[0]!=false){
        taskFiles = [];
        fileName = isUp?[0]['filename'];
        filePath = (isUp![0]['msg']['result']).replaceAll('\\', '/');
        taskFiles.add(
          {
            'filePath':filePath,
            'filename':fileName
          }
        );
      }
      setState(() {});
    }
  }

  /// 提交对接任务
  void _getTask() async {
    List imgList = [];
    for(var i = 0; i < checkImages.length; i++){
      imgList.add({'filePath':checkImages[i]});
    }
    if(imgList.isEmpty){
      ToastWidget.showToastMsg('图片不能为空');
    }else if(taskFiles.isEmpty){
      ToastWidget.showToastMsg('文件不能为空');
    }else{
      var response = await Request().post(
        Api.url['submitTask'],
        data: {
          'id':taskId,
          'fileList':taskFiles,
          'imgList':imgList,
        },
      );
      if(response['errCode'] == '10000') {
        ToastWidget.showToastMsg('提交成功');
        Navigator.pop(context);
        setState(() {});
      }
    }
  }

  /// 缓存事件
  void saveInfo({required int taskId,required int fromId}) {
    getform.add({'taskId':taskId,'fromId':fromId,'data':{}});
    StorageUtil().setJSON('taskFrom', getform);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TaskCompon.topTitle(
              title: '任务详情',
              left: true,
              callBack: (){
                Navigator.pop(context);
              }
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.only(top: 0),
              children: [
                taskDetails.isNotEmpty ?
                backLog() :
                Container(),
                Column(
                  children: List.generate(formDynamic.length, (index) => taskDynamicForm(i: index)),
                ),
                !backlog ?
                revocation() :
                Container(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ///任务详情
  Widget backLog(){
    return Container(
      margin: EdgeInsets.only(left: px(24),right: px(24),top: px(24)),
      padding: EdgeInsets.only(left: px(24),right: px(24),bottom: px(24)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(px(8.0))),
      ),
      child: Column(
        children: [
          Container(
            color: Colors.white,
            margin: EdgeInsets.only(top: px(12)),
            height: px(56),
            child: FormCheck.formTitle('任务详情'),
          ),
          FormCheck.rowItem(
            title: '任务名称:',
            child: Text('${taskDetails['taskItem']}',style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),),
          ),
          FormCheck.rowItem(
            title: '开始时间:',
            child: Text(DateTime.fromMillisecondsSinceEpoch(taskDetails['startDate']).toString().substring(0,19),
              style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),),
          ),
          FormCheck.rowItem(
            title: '负责人员:',
            child: Text('${taskDetails['managerOpName']}',style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),),
          ),
          FormCheck.rowItem(
            title: '协助人员:',
            child: Text('${taskDetails['assistOpNames'] ?? '李四'}',style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),),
          ),
          FormCheck.rowItem(
            alignStart: true,
            title: "现场照片:",
            child: UploadImage(
              imgList: checkImages,
              abutment: true,
              closeIcon: !backlog,
              callback: (List? data) {
                checkImages = data ?? [];
                setState(() {});
              },
            ),
          ),
          FormCheck.rowItem(
            title: '任务附件:',
            child: GestureDetector(
              child: Text((fileName.isEmpty && !backlog) ? '添加附件' : fileName,style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),),
              onTap: () async {
                if(backlog) {
                  if(fileName.isNotEmpty){
                    String? path = await FileSystem.createFileOfPdfUrl(Api.baseUrlAppImage+filePath);
                    if (path != '' && path != null) {
                      OpenFile.open(path);
                    }
                  }
                }else{
                  _uploadTwo();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  ///任务动态表单
  Widget taskDynamicForm({required int i}){
    return InkWell(
      child: Container(
        margin: EdgeInsets.only(left: px(24),right: px(24),top: px(24)),
        padding: EdgeInsets.only(left: px(12),right: px(12),bottom: px(12)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(px(8.0))),
        ),
        child: FormCheck.rowItem(
          title: '关联表单:',
          child: Row(
            children: [
              Text('${formDynamic[i]['formName']}',style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),),
              Spacer(),
              Icon(Icons.keyboard_arrow_right)
            ],
          ),
        ),
      ),
      onTap: (){
        Navigator.pushNamed(context, '/abutmentFrom',arguments: {'allfield':formDynamic[i],'taskId':taskId,});
      },
    );
  }

  ///按钮
  Widget revocation(){
    return Container(
      height: px(88),
      margin: EdgeInsets.only(top: px(24)),
      color: Colors.transparent,
      alignment: Alignment.center,
      child: GestureDetector(
        child: Container(
          width: px(240),
          height: px(56),
          alignment: Alignment.center,
          margin: EdgeInsets.only(left: px(40)),
          child: Text(
            '提交',
            style: TextStyle(
                fontSize: sp(24),
                fontFamily: "M",
                color: Color(0xff4D7FFF)),
          ),
          decoration: BoxDecoration(
            border: Border.all(width: px(2),color: Color(0xff4D7FFF)),
            borderRadius: BorderRadius.all(Radius.circular(px(28))),
          ),
        ),
        onTap: () {
          _getTask();
        },
      ),
    );
  }
}
