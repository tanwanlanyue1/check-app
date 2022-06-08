import 'dart:convert';
import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scet_check/api/api.dart';
import 'package:scet_check/api/request.dart';
import 'package:scet_check/components/generalduty/loading.dart';
import 'package:scet_check/components/generalduty/toast_widget.dart';
import 'package:scet_check/components/generalduty/upload_image.dart';
import 'package:scet_check/components/pertinence/companyFile/components/file_system.dart';
import 'package:scet_check/page/module_steward/check/statisticAnaly/components/form_check.dart';
import 'package:scet_check/utils/screen/screen.dart';
import 'package:scet_check/utils/storage/data_storage_key.dart';
import 'package:scet_check/utils/storage/storage.dart';
import 'package:uuid/uuid.dart';

import 'components/task_compon.dart';

///任务详情页面
///arguments：{"backlog":true,'id':任务详情}待办
class TaskDetails extends StatefulWidget {
  final Map? arguments;
  const TaskDetails({Key? key,this.arguments}) : super(key: key);

  @override
  _TaskDetailsState createState() => _TaskDetailsState();
}


class _TaskDetailsState extends State<TaskDetails> {
  Map taskDetails = {};//任务详情
  List reformDetails = [];//整改详情
  List imgDetails = [];//任务图片列表
  List checkImages = [];//检查图片列表
  List checkFiles = [];//检查文件列表
  bool backlog = true;//待办
  String companyName = '';//企业名
  String companyId = '';//企业id
  Uuid uuid = Uuid(); //uuid
  String _uuid = ''; //uuid
  String taskId = ''; //任务id
  String stewardCheck = ''; //检查人
  String checkDetail = ''; //检查详情
  String userId = ''; //用户id
  List taskFiles = [];//任务附件名称
  String fileName = '';//上传附件名称
  String filePath = '';//上传附件路径
  DateTime solvedAt = DateTime.now().add(Duration(days: 7));//整改期限
  DateTime reviewedAt = DateTime.now().add(Duration(days: 14));//复查期限

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    backlog = widget.arguments?['backlog'] ?? false;
    taskId = widget.arguments?['id'] ?? '';
    userId= jsonDecode(StorageUtil().getString(StorageKey.PersonalData))['id'];
    _getTasks();
  }

  /// 签到清单
  /// id: uuid
  /// checkPersonnel: 检查人员
  /// checkType: 检查类型: 1,管家排查
  /// images: [],上传的图片
  /// longitude: 经度
  /// latitude: 纬度度
  /// userId: 用户id
  /// companyId: 公司id
  /// solvedAt: 整改期限
  /// reviewedAt: 复查期限
  void _setInventory() async {
    _uuid = uuid.v4();
    stewardCheck = TaskCompon.checkPeople(people: taskDetails['checkUserList']);
    Map<String, dynamic> _data = {
      'id':_uuid,
      'checkPersonnel': stewardCheck,
      'userId': userId,
      'companyId': companyId,
      'solvedAt': solvedAt.toString(),
      'reviewedAt': reviewedAt.toString(),
    };
    var response = await Request().post(
        Api.url['inventory'],
        data: _data
    );
    if(response['statusCode'] == 200) {
      Navigator.pushNamed(context, '/stewardCheck',arguments: {
        'uuid': _uuid,
        'company':false
      });
    }
  }

  /// 上传文件
  /// result: 文件数组
  void _upload() async {
    String url = Api.baseUrlApp + 'file/upload?savePath=任务/';
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.any,
    );
    if (result != null) {
      var isUp = await FileSystem.upload(result, url);
      if(isUp?[0]!=false){
        fileName = isUp?[0]['msg']['data']['name'];
        filePath = (isUp![0]['msg']['data']['dir']+'/'+isUp[0]['msg']['data']['base']).replaceAll('\\', '/');
      }
      setState(() {});
    }
  }

  ///下载文件
  Future<String?> createFileOfPdfUrl(url) async {
    BotToast.showCustomLoading(
        ignoreContentClick: true,
        toastBuilder: (cancelFunc) {
          return Loading();
        }
    );
    url = (Api.baseUrlApp + url).replaceAll('\\', '/');
    final filename = url.substring(url.lastIndexOf("/") + 1);
    return HttpClient().getUrl(Uri.parse(url)).then((value) async {
      var response = await value.close();
      var bytes = await consolidateHttpClientResponseBytes(response);
      String? dir;
      if(Platform.isAndroid)  {
        dir = (await getExternalStorageDirectory())?.path.toString();
      }else if(Platform.isIOS) {
        dir =  (await getApplicationSupportDirectory ()).path;
      }
      // String dir = (await getApplicationDocumentsDirectory()).path;
      File file = File('$dir/$filename');
      await file.writeAsBytes(bytes);
      BotToast.closeAllLoading();
      return file.path;
    }).catchError((err){
      return '';
    });
  }

  ///提交弹窗
  void submission() async{
    var res = await showDialog(
      context: context,//StatefulBuilder
      barrierDismissible: true,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context,state){
          return Material(
            color: Color.fromRGBO(0, 0, 0, 0.3),
            child: Center(
              child: Container(
                margin: EdgeInsets.only(left: px(24),right: px(24)),
                padding: EdgeInsets.only(top: px(12),left: px(24),right: px(24)),
                decoration:const ShapeDecoration(
                    color: Color(0xffF9F9F9),
                    shape: RoundedRectangleBorder(
                        borderRadius:  BorderRadius.all( Radius.circular(5))
                    )
                ),
                height: px(350),
                width: px(600),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text('注意',style: TextStyle(fontSize: sp(32),fontFamily: 'M',)),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: px(12)),
                      child: Text('此项任务是否需企业进行整改？',style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: px(12)),
                      child: Text('是，自动生成隐患排查清单',style: TextStyle(color: Color(0xff323233),fontSize: sp(28))),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: px(12)),
                      child: Text('否，任务结束',style: TextStyle(color: Color(0xff323233),fontSize: sp(28))),
                    ),
                    Spacer(),
                    Container(
                      height: px(88),
                      margin: EdgeInsets.only(top: px(4)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            child: Container(
                              width: px(240),
                              height: px(56),
                              alignment: Alignment.center,
                              child: Text(
                                '是',
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
                              Navigator.pop(context,true);
                            },
                          ),
                          GestureDetector(
                            child: Container(
                              width: px(240),
                              height: px(56),
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(left: px(40)),
                              child: Text(
                                '否',
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
                            onTap: (){
                              Navigator.pop(context,false);
                            },
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
      },
    );
    if(res != null){
      _getTask();
      if(res == true){
        _setInventory();
      }
      setState(() {});
    }
  }

  /// 获取任务详情
  void _getTasks() async {
    var response = await Request().get(Api.url['addTask']+'/$taskId',);
    if(response['statusCode'] == 200) {
      taskDetails = response['data'];
      if(taskDetails.isNotEmpty){
        imgDetails = taskDetails['taskImages'] ?? [];
        companyId = taskDetails['company']['id'];
        checkImages = taskDetails['checkImages'] ?? [];
        taskFiles = taskDetails['taskFiles'] ?? [];
        filePath = taskDetails['checkFiles'] != null ? taskDetails['checkFiles'][0] : "";
      }
      setState(() {});
    }
  }

  /// 发布任务
  void _getTask() async {
    if(checkDetail.isEmpty){
      ToastWidget.showToastMsg('请输入检查情况！');
    }else{
      Map _data = {
        'id':taskId,
        'status': 2,
        'checkDetail':checkDetail,
        'checkImages':checkImages,
        'checkFiles':[filePath],
      };
      var response = await Request().post(
        Api.url['addTask'],data: _data,
      );
      if(response['statusCode'] == 200) {
        backlog = false;
        setState(() {});
      }
    }
  }
  @override
  void didUpdateWidget(covariant TaskDetails oldWidget) {
    // TODO: implement didUpdateWidget
    _getTasks();
    super.didUpdateWidget(oldWidget);
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
                backLog() : Container(),
                backlog ?
                checkAgenda() :
                Container(),
                backlog ?
                revocation():
                Container(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ///头部
  Widget top(){
    return SizedBox(
      height: px(88),
      // color: Colors.white,
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
              child: Text('任务详情',style: TextStyle(color: Color(0xff323233),fontSize: sp(36),fontFamily: 'M'),),
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
            title: '企业名称:',
            child: Text('${taskDetails['company']['name']}',style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),),
          ),
          FormCheck.rowItem(
            title: '所在片区:',
            child: Text('${taskDetails['company']['district']['name']}',style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),),
          ),
          FormCheck.rowItem(
            alignStart: true,
            title: '待办任务:',
            child: Text('${taskDetails['taskDetail']}',style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),),
          ),
          imgDetails.isNotEmpty ?
          FormCheck.rowItem(
            alignStart: true,
            title: "任务照片:",
            child: UploadImage(
              imgList: imgDetails,
              closeIcon: false,
            ),
          ):Container(),
          FormCheck.rowItem(
            title: '下发时间:',
            child: Text(TaskCompon.formatTime(taskDetails['createdAt']),style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),),
          ),
          FormCheck.rowItem(
            title: '检查人员:',
            child: Text(TaskCompon.checkPeople(people: taskDetails['checkUserList']),style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),),
          ),
          taskFiles.isNotEmpty ?
          FormCheck.rowItem(
            title: '任务附件:',
            child: GestureDetector(
              child: Text("${taskFiles[0]}",style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),),
              onTap: () async {
                String? path = await createFileOfPdfUrl(taskFiles[0]);
                if (path != '' && path != null) {
                  OpenFile.open(path);
                }
              },
            ),
          ) : Container(),
          !backlog ? examine() : Container(),
        ],
      ),
    );
  }

  ///待办检查信息
  Widget checkAgenda(){
    return Container(
      margin: EdgeInsets.only(left: px(24),right: px(24),top: px(24)),
      padding: EdgeInsets.only(left: px(12),right: px(12),bottom: px(24)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(px(8.0))),
      ),
      child: Column(
        children: [
          Container(
            color: Colors.white,
            margin: EdgeInsets.only(top: px(4),bottom: px(4)),
            height: px(56),
            child: FormCheck.formTitle('检查信息'),
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
                            '检查情况:',
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
                        checkDetail = val;
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
              imgList: checkImages,
              closeIcon: true,
              uuid: uuid.v4(),
              url: Api.baseUrlApp + 'file/upload?savePath=任务/',
              callback: (List? data) {
                checkImages = data ?? [];
                setState(() {});
              },
            ),
          ),
          FormCheck.rowItem(
            title: '检查附件:',
            titleColor: Color(0XFF323232),
            child: GestureDetector(
              child: Text(fileName.isEmpty ? '添加附件' : fileName,style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),),
              onTap: (){
                _upload();
              },
            ),
          ),
        ],
      ),
    );
  }

  ///检查信息
  Widget examine(){
    return Column(
      children: [
        FormCheck.rowItem(
          title: '检查情况:',
          child: Text(taskDetails['checkDetail'] ?? checkDetail,style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),),
        ),
        FormCheck.rowItem(
          title: '现场照片:',
          child: UploadImage(
            imgList: checkImages,
            closeIcon: false,
          ),
        ),
        FormCheck.rowItem(
          title: '检查时间:',
          child: Text(TaskCompon.formatTime(taskDetails['updatedAt']),style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),),
        ),
        filePath.isNotEmpty ?
        FormCheck.rowItem(
          title: '附件:',
          child: GestureDetector(
            child: Text(filePath,style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),),
            onTap: () async{
              String? path = await createFileOfPdfUrl(filePath);
              if (path != '' && path != null) {
                OpenFile.open(path);
              }
            },
          ),
        ) : Container(),
      ],
    );
  }

  ///按钮
  Widget revocation(){
    return Container(
      height: px(88),
      margin: EdgeInsets.only(top: px(24)),
      color: Colors.white,
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
          submission();
          // Navigator.pop(context);
        },
      ),
    );
  }
}
