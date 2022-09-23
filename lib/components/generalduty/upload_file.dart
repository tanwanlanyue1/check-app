import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:scet_check/api/api.dart';
import 'package:scet_check/components/pertinence/companyFile/components/file_system.dart';
import 'package:scet_check/utils/screen/screen.dart';
import 'package:scet_check/utils/time/utc_tolocal.dart';
import 'package:uuid/uuid.dart';

///上传文件
///    Container(
///       color: Colors.white,
///       child: UploadFile(),
///     ),
///  url:上传地址
///  icon:文件图标
///  amend:是否开启修改
///  fileChild:传递样式
///  callback:回调函数
///  abutment:是否是对接接口上传
class UploadFile extends StatefulWidget {
  final bool icon;
  final bool abutment;
  final bool amend;
  final String url;
  final List? fileList;
  final Widget? fileChild;
  final Function? callback;
  const UploadFile({Key? key,
    this.callback,
    this.abutment = false,
    this.amend = true,
    required this.url,
    this.icon = false,
    this.fileList,
    this.fileChild
  }) : super(key: key);

  @override
  _UploadFileState createState() => _UploadFileState();
}

class _UploadFileState extends State<UploadFile> {
  Uuid uuid = Uuid(); //uuid
  String _uuid = '';//uuid
  String _url = '任务/';//上传地址
  List fileName = [];//文件名称数组
  List fileList = [];//上传文件数组
  List showFileList = [];//展示文件数组
  bool icon = false;//图标
  bool abutment = false;//是否对接的
  bool amend = false;//是否开启修改

  /// 上传文件
  /// result: 文件数组
  /// 处理上传图片返回回来的格式，将\转化为/
  void _upload() async {
    String url = Api.url['uploadImg'] + _url + utcTransition() + _uuid;
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.any,
    );
    if (result != null) {
      var isUp = await FileSystem.upload(result, url);
      if(isUp?[0]!=false){
        for(var i = 0; i < (isUp?.length ?? 0);i++){
          String? fileUrl = (isUp![i]['msg']['data']['dir']+'/'+isUp[i]['msg']['data']['base']).replaceAll('\\', '/');
          fileList.add(fileUrl);
          showFileList.add({'fileName':isUp[i]['msg']['data']['name'],"filePath":fileUrl});
        }
      }
      widget.callback?.call(fileList);
      setState(() {});
    }
  }

  /// 对接任务上传文件
  /// result: 文件数组
  void _uploadTwo() async {
    String url = Api.url['addFile'];
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.any,
    );
    if (result != null) {
      var isUp = await FileSystem.upload(result, url);
      if(isUp?[0]!=false){
        for(var i = 0; i < (isUp?.length ?? 0);i++){
          String? fileUrl = (isUp![i]['msg']['result']).replaceAll('\\', '/');
          fileList.add(fileUrl);
          showFileList.add({'fileName':isUp[i]['filename'],"filePath":fileUrl});
        }
      }
      widget.callback?.call(showFileList);
      setState(() {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    _uuid = uuid.v4();
    _url = widget.url;
    abutment = widget.abutment;
    amend = widget.amend;
    icon = widget.icon;
    if(abutment){
      showFileList = widget.fileList ?? [];
      for(var i = 0; i < showFileList.length; i++){
        fileList.add(showFileList[i]['filePath']);
      }
    }else{
      fileList = widget.fileList ?? [];
    }
    super.initState();
  }

  @override
  void didUpdateWidget(covariant UploadFile oldWidget) {
    // TODO: implement didUpdateWidget
    if(oldWidget.fileList != widget.fileList){
      _url = widget.url;
      abutment = widget.abutment;
      amend = widget.amend;
      icon = widget.icon;
      if(abutment){
        showFileList = widget.fileList ?? [];
        fileList = [];
        for(var i = 0; i < showFileList.length; i++){
          fileList.add(showFileList[i]['filePath']);
        }
      }else{
        fileList = widget.fileList ?? [];
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(fileList.isEmpty ? 1 : fileList.length, (i) => report(i)),
    );
  }

  //上传文件
  Widget report(int i){
    return Stack(
      children: [
        InkWell(
          child: Container(
            padding: EdgeInsets.only(bottom: px(24)),
            color: Colors.transparent,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Visibility(
                  visible: icon,
                  child: Container(
                    width: px(30),
                    height: px(30),
                    margin: EdgeInsets.only(right: px(8)),
                    child: Icon(Icons.file_copy,color: Colors.blue,size: 12,),
                  ),
                ),
                Expanded(
                  child: amend && showFileList.isEmpty ?
                  Text('选择附件',style: TextStyle(color: Color(0xff323233),fontSize: sp(26)),):
                  Text(showFileList.isNotEmpty ?
                  '${showFileList[i]['fileName']}' :
                  (fileList.isNotEmpty ? fileList[i] : '/'),style: TextStyle(color: Color(0xff323233),fontSize: sp(26),overflow: TextOverflow.ellipsis),),
                ),
              ],
            ),
          ),
          onTap: () async {
            //判断是否开启修改，fileList判断是否有数据，abutment调用对接的文件上传还是app的文件上传
            if(fileList.isNotEmpty){
              String? path;
              if(abutment){
                path  = await FileSystem.createFileOfPdfUrl(Api.baseUrlAppImage+fileList[i]);
              }else{
                path = await FileSystem.createFileOfPdfUrl(Api.baseUrlApp+fileList[i]);
              }
              if (path != '' && path != null) {
                OpenFile.open(path);
              }
            }else if(amend){
              if(abutment){
                _uploadTwo();
              }else{
                _upload();
              }
            }
          },
        ),
        Visibility(
          visible: amend && showFileList.isNotEmpty,
          child: Positioned(
              top: 0,
              right: 0,
              child: GestureDetector(
                  onTap: () {
                    fileList.removeAt(i);
                    showFileList.removeAt(i);
                    setState(() {});
                    if(abutment){
                      widget.callback?.call(showFileList);
                    }else{
                      widget.callback?.call(fileList);
                    }
                  },
                  child: Container(
                    color: Colors.transparent,
                    padding: EdgeInsets.only(left: px(24),right: px(24)),
                    child: Icon( Icons.close, color: Colors.redAccent, size: px(40.0),),
                  )
              )
          ),
        )
      ],
    );
  }
}
