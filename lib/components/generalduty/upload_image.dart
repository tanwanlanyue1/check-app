import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mime/mime.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:scet_check/api/api.dart';
import 'package:scet_check/api/request.dart';
import 'package:scet_check/components/pertinence/companyFile/components/file_system.dart';
import 'package:scet_check/routers/router_animate/router_fade_route.dart';
import 'package:scet_check/utils/photoView/cached_network.dart';
import 'package:scet_check/utils/photoView/photo_view.dart';
import 'package:scet_check/utils/screen/screen.dart';
import 'package:scet_check/utils/time/utc_tolocal.dart';
import 'package:uuid/uuid.dart';

///上传图片
///callback:回调
///closeIcon:是否开启修改
///imgList:数据
///uuid:uuid
///url:上传图片路径
///abutment:是否是对接接口上传
class UploadImage extends StatefulWidget {
  final Function? callback;
  final bool closeIcon;
  final bool abutment;
  final List imgList;
  final String? uuid;
  final String? url;
  const UploadImage({Key? key,
    this.callback,
    this.closeIcon = true,
    this.abutment = false,
    this.uuid,
    this.url,
    required this.imgList,
  }) : super(key: key);
  @override
  _UploadImageState createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {

  List<dynamic> _imagesList = []; // 图片数组
  String _uuid = '';//uuid
  String _url = Api.url['uploadImg']+'清单/';//url
  bool abutment = false;//是否是对接接口上传

  /// 上传图片文件
  /// result: 文件数组
  /// 处理上传图片返回回来的格式，将\转化为/
  void _upload() async {
    String url = _url + utcTransition() +_uuid;
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.image,
    );
    if (result != null) {
      var isUp = await FileSystem.upload(result, url);
      if(isUp?[0]!=false){
        for(var i = 0; i < (isUp?.length ?? 0);i++){
          String? imgUrl = isUp![i]['msg']['data']['dir']+'/'+isUp[i]['msg']['data']['base'];
          _imagesList.add(
            imgUrl?.replaceAll('\\', '/'),
          );
        }
        widget.callback?.call(_imagesList);
      }
      setState(() {});
    }
  }

  /// 对接任务上传文件
  /// result: 文件数组
  /// 处理上传图片返回回来的格式，将\转化为/
  void _uploadTwo() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.image,
    );
    if (result != null) {
      List<File> files = result.paths.map((path) => File(path.toString())).toList();
      for(int i = 0; i < files.length; i++){
        String path = files[i].path;
        String filename = files[i].path.split("/").last;

        FormData formdata = FormData.fromMap({
          "file": await MultipartFile.fromFile(
            path, // 路径
            filename: filename, // 名称
          ),
        });
        var response = await Request().post(Api.url['addFile'],
          data:formdata
        );
        if(response['success'] == true){
          _imagesList.add(response['result']);
        }
      }
        widget.callback?.call(_imagesList);
      setState(() {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    _imagesList = widget.imgList;
    _url = widget.url ?? _url;
    _uuid = widget.uuid ?? '';
    abutment = widget.abutment;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant UploadImage oldWidget) {
    // TODO: implement didUpdateWidget
    _imagesList = widget.imgList;
    _url = widget.url ?? _url;
    _uuid = widget.uuid ?? '';
    abutment = widget.abutment;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap:true,
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.all(0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
      ),
      itemCount: widget.closeIcon ? _imagesList.length + 1 : _imagesList.length,
      itemBuilder: (BuildContext context, int index) {
        if(index == _imagesList.length && widget.closeIcon) {
          return GestureDetector(
            onTap: () async{
              if (await Permission.camera.request().isGranted) {
                if (await Permission.photos.request().isGranted) {
                  if(abutment){
                    _uploadTwo();
                  }else{
                    _upload();
                  }
                }
              }
            },
            child: Container(
              width: px(169),
              height: px(169),
              color: Color(0XFFF5F6FA),
              child: Image.asset('lib/assets/icons/form/camera.png'),
            ),
          );
        }
        if(_imagesList.isNotEmpty) {
          return _createGridViewItem(
            SizedBox(
              width: 300, height: 300,
              child: CachedNetwork(
                url:abutment ?
                Api.baseUrlAppImage + _imagesList[index] :
                Api.baseUrlApp + _imagesList[index],
                  fits: BoxFit.cover,
              ),
            ),
            index
        );
        }
        return Container();
      },
    );
  }
  ///创建GridView
  ///child：子组件
  ///index：下标
  Widget _createGridViewItem(Widget child, index) {
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(px(12.0)))
        ),
        child: Stack(
            children: [
              InkWell(
                child: child,
                onTap: () async {
                  List _img = [];
                  for (var item in _imagesList) {
                    abutment ?
                    _img.add(Api.baseUrlAppImage + item):
                    _img.add(Api.baseUrlApp + item);
                  }
                  var res = await Navigator.of(context).push(FadeRoute(page: PhotoViewGalleryScreen(
                    images:_img,//传入图片list
                    index: index,//传入当前点击的图片的index
                    heroTag: _img[index],//传入当前点击的图片的hero tag （可选）
                    alter:widget.closeIcon,
                  )));
                  if(res != null){
                    _imagesList.add(res);
                    widget.callback?.call(_imagesList);
                    setState(() {});
                  }
                },
              ),
              if(widget.closeIcon)Positioned(
                  top: 0,
                  right: 0,
                  child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _imagesList.removeAt(index);
                          widget.callback?.call(_imagesList);
                        });
                      },
                      child: Icon( Icons.close, color: Colors.redAccent, size: px(40.0),)
                  )
              )
            ]
        )
    );
  }

}