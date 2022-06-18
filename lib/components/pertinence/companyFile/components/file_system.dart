import 'dart:convert';
import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mime/mime.dart';
import 'package:open_file/open_file.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:scet_check/api/api.dart';
import 'package:scet_check/api/request.dart';
import 'package:scet_check/components/generalduty/loading.dart';
import 'package:scet_check/components/generalduty/toast_widget.dart';

/// 文件系统
class FileSystem{

  /// 上传文件（可多选上传） 成功为true 失败为false
  /// result: 文件数组[file,file] file_picker插件的文件选择回调
  /// url :上传地址
  /// 异步上传 上传操作完成后返回回调值[true]
  static Future<List<dynamic>?> upload(FilePickerResult result,String url) async {

    List<File> files = result.paths.map((path) => File(path.toString())).toList();

    List<dynamic> _isUp = [];// 上传成功或者失败保存的数组

    for(int i = 0; i < files.length; i++){

      String path = files[i].path;
      String filename = files[i].path.split("/").last;
      int size = files[i].lengthSync();
      String mimetype = lookupMimeType(files[i].path).toString();
      DateTime lastModified = await files[i].lastModified();

      Map data =  {
        "filename":filename,
        "lastModified":lastModified.millisecondsSinceEpoch,
        "size":size,
        "mimetype":mimetype
      };

      FormData formdata = FormData.fromMap({
        "file": await MultipartFile.fromFile(
          path, // 路径
          filename: filename, // 名称
        ),
        "stat":jsonEncode(data)
      });

      try{
        var response = await Request().upfile(
            url,
            path,
            formDatas: formdata,
            onSendProgress:(val){ToastWidget.showToastMsg(val);});
        if(response['statusCode'] == 200 || response['errCode'] == '10000') {
          ToastWidget.showToastMsg('上传成功!');
          _isUp.add({"state":true,'msg':response,'filename':filename});
        }else{
          ToastWidget.showToastMsg('上传出错了!');
          _isUp.add(false);
        }
      }catch(e){
        _isUp.add(false);
      }
    }
    if(_isUp.length == files.length){
      if(_isUp.contains(false)){
        print('有上传失败项');
        return _isUp;
      }else{
        return _isUp;
      }
    }
  }

  /// 创建下载文件
  /// 判断权限 生成文件路径
  /// data: 数据源 必须包含{'size':1234,'name':name,}
  /// url: 下载地址
  /// openFile:下载完成后是否打开
  /// isDownLoad: 是否有需要跟随下载开启的弹窗事件(选填的回调)
  /// progress: 当前的下载进度(选填的回调)
  static downLoad(BuildContext context,Map data,String url,{bool openFile = false,Function? isDownLoad,Function? progress}) async {

    if (await Permission.storage.request().isGranted) {   //判断是否授权,没有授权会发起授权

      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String appName = packageInfo.appName;
      String downloadPath = '';

      if(Platform.isAndroid)  {
        String? storagePath = (await getExternalStorageDirectory())?.path.substring(1);
        List? storagePathList = storagePath?.split('/');
        downloadPath = '/${storagePathList?[0]}/${storagePathList?[1]}/${storagePathList?[2]}/${appName}';
      }else if(Platform.isIOS) {
        downloadPath =  (await getApplicationSupportDirectory ()).path + "/${appName}";
      }

      bool dirExist = await isDirectoryExist(dirPath: downloadPath);

      try{
        if (!dirExist) {
          await createDirectory(downloadPath);
        }
        String filePath ='${downloadPath}/${data['size']}${data['name']}';

        String showFilePath = '保存路径:\n/${appName}/${data['size']}${data['name']}';

        bool fileExist = await isDirectoryExist(filePath: filePath);

        if(!fileExist) {
          isDownLoad?.call(true);
          await Request().download(
              url,
              filePath,
              downloadProgress: (val1,val2){
                double _progress = val1/int.parse(data['size']);
                progress?.call(_progress);
                if(_progress == 1.0){
                  isDownLoad?.call(false);
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(showFilePath),)
                  );
                  if(openFile){
                    OpenFile.open(filePath);
                  }
                }
              }
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(showFilePath),)
          );
          if(openFile) {
            OpenFile.open(filePath);
          }
        }
      }catch(e){
        ToastWidget.showToastMsg(e.toString());
      }
    }else{
      ToastWidget.showToastMsg('您还没有授权！将无法进行操作');
    }
  }

  ///下载文件
  static Future<String?> createFileOfPdfUrl(url) async {
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

  /// 判断 文件或者文件夹 是否存在
  /// dirPath: 文件夹路径
  /// filePath: 文件路径
  /// 只能传一个路径进行判断
  static Future<bool> isDirectoryExist({String? dirPath,String? filePath}) async {
    bool isHave = false;
    if(dirPath != null){
      print('dirPath:${dirPath}');
      final savedDir = Directory(dirPath);
      isHave =  await savedDir.exists();
    }
    if(filePath != null){
      print('filePath:${filePath}');
      File file = File(filePath);
      isHave = await file.exists();
    }
    return isHave;
  }

  /// 生成文件夹
  /// path:文件路径
  /// recursive: false，则只有路径中的最后一个目录是创建 true，则创建所有不存在的路径组件。
  /// 如果目录已经存在，则不执行任何操作。
  static Future<Directory> createDirectory(String path) async {
    Directory directory = Directory(path);
    return await directory.create(recursive: true);
  }

  /// 文件大小
  /// value:文件多少字节
  static String renderSize(value) {
    if(value is String){
      value = int.parse(value);
    }
    if (null == value || '0' == value ) {
      return '0.00B';
    }

    List<String> unitArr = []..add('B')..add('K')..add('M')..add('G');
    int index = 0;
    while (value > 1024) {
      index++;
      value = value / 1024;
    }
    String size = value.toStringAsFixed(2);
    return size + unitArr[index];
  }
}