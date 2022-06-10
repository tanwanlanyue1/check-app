import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scet_check/api/api.dart';
import 'package:scet_check/api/request.dart';
import 'package:scet_check/components/generalduty/down_input.dart';
import 'package:scet_check/components/generalduty/toast_widget.dart';
import 'package:scet_check/components/generalduty/upload_image.dart';
import 'package:scet_check/components/pertinence/companyFile/components/file_system.dart';
import 'package:scet_check/model/provider/provider_home.dart';
import 'package:scet_check/page/module_steward/check/statisticAnaly/components/form_check.dart';
import 'package:scet_check/utils/screen/screen.dart';
import 'package:scet_check/utils/storage/data_storage_key.dart';
import 'package:scet_check/utils/storage/storage.dart';
import 'package:uuid/uuid.dart';

import 'components/task_compon.dart';


///发布任务详情
///arguments:{id：任务id}
class BackTaskDetails extends StatefulWidget {
  final Map? arguments;
  const BackTaskDetails({Key? key,this.arguments}) : super(key: key);

  @override
  _BackTaskDetailsState createState() => _BackTaskDetailsState();
}

class _BackTaskDetailsState extends State<BackTaskDetails> {
  List company = []; //选中的企业
  String companyName = ''; //企业名
  String fileName = ''; //企业id
  List imgDetails = []; //现场照片
  List taskFiles = []; //附件文件
  String checkName = ''; //检查人员
  String typeName = ''; //任务类型
  String taskDetail = ''; //任务详情
  String userId = ''; //用户id
  Uuid uuid = Uuid(); //uuid
  String _uuid = '';//清单id
  List typeList = [
    {'name':'现场检查','id':3},
    {'name':'表格填报','id':4},
    {'name':'其他专项','id':2},
  ];//问题类型列表
  int taskType = 3;//任务类型
  HomeModel? _homeModel; //全局的选择企业

  /// 上传文件
  /// result: 文件数组
  /// 处理上传图片返回回来的格式，将\转化为/
  void _upload() async {
    _uuid = uuid.v4();
    String url = Api.baseUrlApp + 'file/upload?savePath=任务/'+ _uuid;
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.any,
    );
    if (result != null) {
      var isUp = await FileSystem.upload(result, url);
      if(isUp?[0]!=false){
        for(var i = 0; i < (isUp?.length ?? 0);i++){
          fileName = isUp?[0]['msg']['data']['name'];
          String? fileUrl = (isUp![i]['msg']['data']['dir']+'/'+isUp[i]['msg']['data']['base']).replaceAll('\\', '/');
          taskFiles.add(fileUrl);
        }
      }
      setState(() {});
    }
  }

  /// 发布任务
  _getTask({required String companyId,List? checkUser}) async {
    Map _data = {};
      if(taskDetail.isEmpty){
        ToastWidget.showToastMsg('请输入任务内容！');
      }else if(companyId.isEmpty){
        ToastWidget.showToastMsg('请选择发布对象！');
      }else{
        _data = {
          'type': taskType,
          'taskDetail': taskDetail,
          'status': 1,
          'userId': userId,
          'companyId': companyId,
          'checkUserList': checkUser,
          'taskImages': imgDetails,
          'taskFiles': taskFiles,
        };
        var response = await Request().post(
          Api.url['addTask'],data: _data,
        );
        if(response['statusCode'] == 200) {
          ToastWidget.showToastMsg('发布成功！');
          return true;
        }else{
          ToastWidget.showToastMsg('发布失败！');
          return false;
        }
      }
  }

  @override
  void initState() {
    // TODO: implement initState
    _uuid = uuid.v4();
    userId = jsonDecode(StorageUtil().getString(StorageKey.PersonalData))['id'];
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    _homeModel = Provider.of<HomeModel>(context, listen: true);
    return Scaffold(
      body: Column(
        children: [
          TaskCompon.topTitle(
              title: '发布任务',
              left: true,
              font: 32,
              callBack: (){
                Navigator.pop(context);
              }
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.only(top: 0),
              children: [
                backLog(),
                submit(),
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
      padding: EdgeInsets.only(left: px(12),right: px(12),bottom: px(12)),
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
            title: '任务类型:',
            titleColor: Color(0XFF323232),
            child: DownInput(
              value: typeName,
              data: typeList,
              hitStr: '选择任务类型',
              callback: (val){
                typeName = val['name'];
                taskType = val['id'];
                setState(() {});
              },
            ),
          ),
          // FormCheck.rowItem(
          //   title: '任务主题:',
          //   titleColor: Color(0XFF323232),
          //   alignStart: true,
          //   child: FormCheck.inputWidget(
          //       hintText: '请输入任务主题',
          //       lines: 1,
          //       onChanged: (val){
          //         setState(() {});
          //       }
          //   ),
          // ),
          FormCheck.rowItem(
            title: '任务内容:',
            titleColor: Color(0XFF323232),
            alignStart: true,
            child: FormCheck.inputWidget(
                hintText: '请输入任务内容',
                lines: 3,
                onChanged: (val){
                  taskDetail = val;
                  setState(() {});
                }
            ),
          ),
          FormCheck.rowItem(
            title: '发布对象:',
            titleColor: Color(0XFF323232),
            child: GestureDetector(
              child: Text(companyName.isNotEmpty ? companyName : '选择企业',style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),),
              onTap: () async {
                if(company.isEmpty){
                  _homeModel?.setSelectCompany([]);
                  _homeModel?.setSelect([]);
                }
                 var res = await Navigator.pushNamed(context, '/enterprisePage',arguments: {"task":true,'name':"发布任务"});
                 if(res == true){
                   company = _homeModel?.selectCompany;
                   for(var i = 0; i < company.length; i++){
                     if(i > 0){
                       companyName = companyName + ',' + company[i]['name'];
                     }else{
                       companyName = company[i]['name'];
                     }
                   }
                   setState(() {});
                 }
              },
            ),
          ),
          FormCheck.rowItem(
            alignStart: true,
            title: "现场照片:",
            titleColor: Color(0XFF323232),
            child: UploadImage(
              imgList: imgDetails,
              closeIcon: true,
              uuid: uuid.v4(),
              url: Api.baseUrlApp + 'file/upload?savePath=任务/',
              callback: (List? data) {
                imgDetails = data ?? [];
                setState(() {});
              },
            ),
          ),
          FormCheck.rowItem(
            title: '附件:',
            titleColor: Color(0XFF323232),
            child: GestureDetector(
              child: Text(fileName.isEmpty ? "添加附件" : fileName,style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),),
              onTap: (){
                _upload();
              },
            ),
          ),
        ],
      ),
    );
  }


  ///提交按钮
  Widget submit(){
    return InkWell(
      child: Container(
        height: px(60),
        margin: EdgeInsets.only(top: px(12),left: px(24),right: px(24),bottom: px(24)),
        alignment: Alignment.center,
        child: Text('提交', style: TextStyle(
            fontSize: sp(32),
            fontFamily: "R",
            color: Colors.white),),
        decoration: BoxDecoration(
          color: Color(0xff4D7FFF),
          border: Border.all(width: px(2),color: Color(0XffE8E8E8)),
          borderRadius: BorderRadius.all(Radius.circular(px(12))),),
      ),
      onTap: () async {
        for(var i = 0; i < company.length; i++){
          var res = await _getTask(companyId: company[i]['id'],checkUser: company[i]['user']);
          if(res == true && i == company.length-1){
            Navigator.pop(context);
          }
        }
      },
    );
  }
}
