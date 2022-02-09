import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:scet_check/utils/photoView/save_util.dart';
import 'package:scet_check/utils/screen/screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class PhotoViewGalleryScreen extends StatefulWidget {
  List images = [];//格式['','']
  int index = 0;
  String? heroTag;
  PageController? controller;

  PhotoViewGalleryScreen({Key? key,required this.images,required this.index,this.controller,this.heroTag}) : super(key: key){
    controller=PageController(initialPage: index);
  }

  @override
  _PhotoViewGalleryScreenState createState() => _PhotoViewGalleryScreenState();
}

class _PhotoViewGalleryScreenState extends State<PhotoViewGalleryScreen> {
  int currentIndex=0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentIndex=widget.index;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Positioned(
            top: 0,
            left: 0,
            bottom: 0,
            right: 0,
            child: Container(
              child: PhotoViewGallery.builder(
                scrollPhysics: const BouncingScrollPhysics(),
                builder: (BuildContext context, int index) {
                  return PhotoViewGalleryPageOptions(
                    imageProvider: CachedNetworkImageProvider(widget.images[index]),
                    // heroAttributes: (widget.heroTag?.isNotEmpty ?? false) ? PhotoViewHeroAttributes(tag: widget.heroTag!):null,
                  );
                },
                itemCount: widget.images.length,
                loadingBuilder: (context, event) => Center(
                  child: Container(
                    width: 20.0,
                    height: 20.0,
                    child: CircularProgressIndicator(
                      // value: event == null
                      //     ? 0
                      //     // : event.cumulativeBytesLoaded / event.expectedTotalBytes,
                      //     : event.cumulativeBytesLoaded / event.expectedTotalBytes,
                    ),
                  ),
                ),
                backgroundDecoration: null,
                pageController: widget.controller,
                enableRotation: true,
                onPageChanged: (index){
                  setState(() {currentIndex=index;});
                },
              )
            ),
          ),
          // 图片index显示
          Positioned(
            top: MediaQuery.of(context).padding.top+15,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: Text("${currentIndex+1}/${widget.images.length}",style: TextStyle(color: Colors.white,fontSize: 16)),
            ),
          ),
          // 右上角关闭按钮
          Positioned(
            right: 10,
            top: MediaQuery.of(context).padding.top,
            child: IconButton(
              icon: Icon(Icons.close,size: 30,color: Colors.white,),
              onPressed: (){
                Navigator.of(context).pop();
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
                    return new AlertDialog(
                      title: new Text("温馨提示",style: TextStyle(fontSize:sp(30) ),),
                      content: new Text("您当前没有开启相册权限",style: TextStyle(fontSize:sp(25)),),
                      actions: <Widget>[
                        new FlatButton(
                          onPressed: () {openAppSettings();},
                          child: new Text("去开启"),
                        ),
                        new FlatButton(
                          onPressed: () {Navigator.of(context).pop();},
                          child: new Text("取消"),
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
}