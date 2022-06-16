import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:scet_check/api/api.dart';
import 'package:scet_check/api/request.dart';
import 'package:scet_check/components/generalduty/date_range.dart';
import 'package:scet_check/components/generalduty/down_input.dart';
import 'package:scet_check/components/generalduty/time_select.dart';
import 'package:scet_check/components/generalduty/toast_widget.dart';
import 'package:scet_check/components/generalduty/upload_image.dart';
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
  List imgDetails = [];//任务图片列表
  List checkImages = [];//检查图片列表
  bool backlog = true;//待办
  String companyName = '';//企业名
  String companyId = '';//企业id
  Uuid uuid = Uuid(); //uuid
  String _uuid = ''; //uuid
  String stewardCheck = ''; //检查人
  String checkDetail = ''; //检查详情
  String userId = ''; //用户id
  List taskFiles = [];//任务附件名称
  String fileName = '';//上传附件名称
  String filePath = '';//上传附件路径
  int checkType = 2;

//requiredFlag 是否必填 （1：是，0：否）
  List allField = [];//总动态表单
  int checkRadio = -1;
  DateTime startTime = DateTime.now();//开始期限
  DateTime endTime = DateTime.now().add(Duration(days: 14));//结束时间
  List checkList = [];//多选数组
  Map data = {}; //动态表单请求
  Map fieldMap = {}; //单选选中
  String taskId = ''; //单选选中
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>(); //时间选择key
  List formId = [18,9];//动态表单id数组
  List getform = [];//缓存的动态表单

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    backlog = widget.arguments?['backlog'] ?? false;
    taskId = widget.arguments?['id'] ?? '';
    userId= jsonDecode(StorageUtil().getString(StorageKey.PersonalData))['id'];
    _getTasks();
    StorageUtil().remove('taskFrom');
    for (var item in formId) {
      _getKeeper(id: item);
    }
  }

  /// 获取任务详情
  void _getTasks() async {
    var response = await Request().get(Api.url['houseTaskById'],
      data: {
        'id':taskId,
        // 'taskId':taskId
      });
    print("response===$response");
    if(response?['errCode'] == '10000') {
      taskDetails = response['result'];
      setState(() {});
    }
  }

  /// 获取动态表单详情
  void _getKeeper({required int id}) async {
    var response = await Request().get(Api.url['housekeeper']+'?id=$id',);
    if(response['errCode'] == '10000') {
      allField.add(response['result']);
      getform = StorageUtil().getJSON('taskFrom') ?? [];
      int index = getform.indexWhere((item) => item['taskId'] == int.parse(taskId) && item['fromId'] == id);
      if(index == -1){
        saveInfo(taskId: int.parse(taskId),fromId: id);
      }
      setState(() {});
    }
  }

  /// 提交对接任务
  void _getTask({bool inventory = false}) async {
    bool empty = true;
    // for(var i = 0; i < fieldList.length; i++){
    //   if(fieldList[i]['requiredFlag']){
    //     if(data.keys.contains(fieldList[i]['fieldValue']) == false){
    //       empty = false;
    //       ToastWidget.showToastMsg('${fieldList[i]['fieldName']}不能为空！');
    //     }
    //   }
    // }
    if(empty){
      ToastWidget.showToastMsg('提交成功');
      var response = await Request().post(
        Api.url['submitTask'],data: data,
      );
      // if(response['statusCode'] == 200) {
      //   setState(() {});
      // }
    }
  }

  /// 缓存事件
  void saveInfo({required int taskId,required int fromId}) {
    getform.add({'taskId':taskId,'fromId':fromId,'data':{}});
    StorageUtil().setJSON('taskFrom', getform);
    setState(() {});
  }

  /// 缓存事件
  void getInfo() {
    getform = StorageUtil().getJSON('taskFrom') ?? [];
    setState(() {});
    print("get=========${StorageUtil().getJSON('taskFrom')}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
                backLog(),
                Column(
                  children: List.generate(allField.length, (index) => taskDynamicForm(i: index)),
                ),
                // checkAgenda(),
                revocation(),
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
            child: Text('${taskDetails['formName'] ?? '检查卫生'}',style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),),
          ),
          // imgDetails.isNotEmpty ?
          // FormCheck.rowItem(
          //   alignStart: true,
          //   title: "任务照片:",
          //   child: UploadImage(
          //     imgList: imgDetails,
          //     closeIcon: false,
          //   ),
          // ):Container(),
          FormCheck.rowItem(
            title: '下发时间:',
            child: Text('${taskDetails['createDate'] ?? '2021-12-4'}',style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),),
          ),
          FormCheck.rowItem(
            title: '负责人员:',
            child: Text('${taskDetails['managerOpName'] ?? '张三'}',style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),),
          ),
          FormCheck.rowItem(
            title: '协助人员:',
            child: Text('${taskDetails['assistOpNames'] ?? '李四'}',style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),),
          ),
          FormCheck.rowItem(
            alignStart: true,
            title: "现场照片:",
            titleColor: Color(0XFF323232),
            child: UploadImage(
              imgList: checkImages,
              abutment: true,
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
              },
            ),
          ),
          // taskFiles.isNotEmpty ?
          // FormCheck.rowItem(
          //   title: '任务附件:',
          //   child: GestureDetector(
          //     child: Text("${taskFiles[0]}",style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),),
          //     onTap: () async {
          //
          //     },
          //   ),
          // ) : Container(),
          // !backlog ? examine() : Container(),
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
              Text('${allField[i]['formName']}',style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),),
              Spacer(),
              Icon(Icons.keyboard_arrow_right)
            ],
          ),
        ),
      ),
      onTap: (){
        Navigator.pushNamed(context, '/abutmentFrom',arguments: {'allfield':allField[i]});
      },
    );
  }
  ///任务表单
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
            child: FormCheck.formTitle('任务表单'),
          ),
          // Column(
          //   children: List.generate(fieldList.length, (i) => dynamicForm(
          //       i:i,
          //       type: int.parse(fieldList[i]['fieldType'])
          //   )),
          // ),
          FormCheck.rowItem(
            alignStart: true,
            title: "现场照片:",
            titleColor: Color(0XFF323232),
            child: UploadImage(
              imgList: checkImages,
              abutment: true,
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
              },
            ),
          ),
        ],
      ),
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
          // print("data==${data}");
          getInfo();
          // _getTask();
          // Navigator.pop(context);
        },
      ),
    );
  }
}
