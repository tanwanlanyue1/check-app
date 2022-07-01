import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scet_check/api/api.dart';
import 'package:scet_check/components/generalduty/editor_image.dart';
import 'package:scet_check/components/pertinence/companyFile/components/file_system.dart';
import 'package:scet_check/utils/photoView/save_util.dart';
import 'package:scet_check/utils/screen/screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:image_editor_dove/image_editor.dart';
import 'package:uuid/uuid.dart';

// ignore: must_be_immutable
///画廊
///images: 图片数组
///index: 图片下标
///heroTag: 图片标签
///controller: 控制器
///alter: 编辑
class PhotoViewGalleryScreen extends StatefulWidget {
  List images = [];//格式['','']
  int index = 0;
  String? heroTag;
  bool alter;
  PageController? controller;

  PhotoViewGalleryScreen({Key? key,required this.images,required this.index,this.controller,this.heroTag,this.alter = false}) : super(key: key){
    controller=PageController(initialPage: index);
  }

  @override
  _PhotoViewGalleryScreenState createState() => _PhotoViewGalleryScreenState();
}

class _PhotoViewGalleryScreenState extends State<PhotoViewGalleryScreen> {
  int currentIndex = 0;//下标
  File? _image; //编辑的图片地址
  bool alter = true; //是否可以编辑
  Uuid uuid = Uuid();//uuid

  //获取图片
  void getImage() async {
    // 保存照片
    String? imgurl = await FileSystem.createFileOfPdfUrl(widget.images[widget.index]);

    ///编辑图标ui
    ImageEditor.uiDelegate = EditorImage();
    if(imgurl != null){
      final File origin = File(imgurl.substring(imgurl.indexOf('/')));
      toImageEditor(origin);
    }
  }

  //给图片做编辑
  Future<void> toImageEditor(File origin) async {
    return Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ImageEditorExtend(
      // return ImageEditor(
        originImage: origin,
      );
    })).then((result) async{
      if (result is EditorImageResult) {
        _image = result.newFile;
        var _url = widget.images[widget.index].split("/").last;
        String url  =  widget.images[widget.index].substring(0,widget.images[widget.index].length - _url.length-1);
        var isUp = await FileSystem.upload(
            null,Api.url['uploadImg'] + url.substring(url.indexOf('uploads/')+8),
          filePath: [_image!]
        );
        if(isUp?[0]!=false){
          for(var i = 0; i < (isUp?.length ?? 0);i++){
            String? imgUrl = isUp![i]['msg']['data']['dir']+'/'+isUp[i]['msg']['data']['base'];
            Navigator.pop(context,imgUrl);
          }
        }
        setState(() {});
      }
    }).catchError((er) {
      debugPrint(er);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentIndex=widget.index;
    alter = widget.alter;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBars(),
      body: Stack(
        children: <Widget>[
          Positioned(
            top: 0,
            left: 0,
            bottom: 0,
            right: 0,
            child: PhotoViewGallery.builder(
              scrollPhysics: const BouncingScrollPhysics(),
              builder: (BuildContext context, int index) {
                return PhotoViewGalleryPageOptions(
                  imageProvider:CachedNetworkImageProvider(widget.images[index])
                //   // heroAttributes: (widget.heroTag?.isNotEmpty ?? false) ? PhotoViewHeroAttributes(tag: widget.heroTag!):null,
                );
              },
              itemCount: widget.images.length,
              loadingBuilder: (context, event) => Center(
                child: SizedBox(
                  width: 20.0,
                  height: 20.0,
                  child: CircularProgressIndicator(),
                ),
              ),
              backgroundDecoration: null,
              pageController: widget.controller,
              enableRotation: true,
              onPageChanged: (index){
                setState(() {currentIndex=index;});
              },
            ),
          ),
          // 右下角下载按钮
          Positioned(
            right: 20,
            bottom: MediaQuery.of(context).padding.bottom+20,
            child: IconButton(
              icon: Icon(Icons.file_download,size: 30,color: Colors.white,),
              onPressed: ()async{
                var status = await Permission.photos.status;
                if (status.isDenied) {
                  showDialog(context: context,builder: (context){
                    return AlertDialog(
                      title: Text("温馨提示",style: TextStyle(fontSize:sp(30) ),),
                      content: Text("您当前没有开启相册权限",style: TextStyle(fontSize:sp(25)),),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {openAppSettings();},
                          child: Text("去开启"),
                        ),
                        TextButton(
                          onPressed: () {Navigator.of(context).pop();},
                          child: Text("取消"),
                        ),
                      ],
                    );
                  });
                  return;
                }
                // 保存照片
                SaveUtil.saveImage(widget.images[widget.index]);
              },
            ),
          ),
        ],
      ),
    );
  }
  ///AppBar
  ///name标题
  PreferredSizeWidget appBars(){
    return AppBar(
      backgroundColor: Color(0xff19191A),
      title: Text("${currentIndex+1}/${widget.images.length}",style: TextStyle(color: Colors.white,fontSize: 16)),
      leading: InkWell(
        child: Container(
          height: px(40),
          width: px(41),
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.only(left: px(20)),
          child: Image.asset('lib/assets/icons/other/chevronLeft.png',color: Colors.white,),
        ),
        onTap: ()async{
          Navigator.pop(context);
        },
      ),
      actions: [
        Visibility(
          visible: alter,
          child: GestureDetector(
            child: Container(
              margin: EdgeInsets.only(right: px(20)),
              height: px(50),
              width: px(51),
              alignment: Alignment.centerRight,
              child: Image.asset(
                'lib/assets/icons/form/alter.png',
                fit: BoxFit.fill,
                color: Colors.white,
              ),
            ),
            onTap: (){
              getImage();
            },
          ),
        ),
      ],
      centerTitle: true,
    );
  }
  ///头部
  Widget topBar(){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          child: Container(
            height: px(40),
            width: px(41),
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(left: px(20)),
            child: Image.asset('lib/assets/icons/other/chevronLeft.png',fit: BoxFit.fill,color: Colors.white,),
          ),
          onTap: ()async{
            Navigator.pop(context);
          },
        ),
        Expanded(
          child: Center(
            child: Text("${currentIndex+1}/${widget.images.length}",style: TextStyle(color: Colors.white,fontSize: 16)),
          ),
        ),//review
        Visibility(
          visible: alter,
          child: GestureDetector(
            child: Container(
              margin: EdgeInsets.only(right: px(20)),
              height: px(50),
              width: px(51),
              alignment: Alignment.centerRight,
              child: Image.asset(
                'lib/assets/icons/form/alter.png',
                fit: BoxFit.fill,
                color: Colors.white,
              ),
            ),
            onTap: (){
              getImage();
            },
          ),
        ),
      ],
    );
  }
}