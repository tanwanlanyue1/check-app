import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scet_check/api/api.dart';
import 'package:scet_check/api/request.dart';
import 'package:scet_check/components/toast_widget.dart';
import 'package:scet_check/routers/router_animate/router_fade_route.dart';
import 'package:scet_check/utils/photoView/cached_network.dart';
import 'package:scet_check/utils/photoView/photo_view.dart';
import 'package:scet_check/utils/screen/screen.dart';
import 'package:http_parser/http_parser.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';

class UploadImage extends StatefulWidget {
  final Function? callback;
  final bool closeIcon;
  final List imgList;
  const UploadImage({Key? key,
    this.callback,
    this.closeIcon = true,
    required this.imgList,
  }) : super(key: key);
  @override
  _UploadImageState createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {

  List _imagesList = []; // 图片数组

  // 选择照片并上传
  Future<void> _uploadImages() async {
    List<Asset> resultList = <Asset>[];
    String _primaryColor = '';
    //处理图片
    try {
      resultList = await MultiImagePicker.pickImages(
        // 若_images不为空，再次打开选择界面的适合，可以显示之前选中的图片信息。
        // selectedAssets: _imagesAsset,
        // 选择图片的最大数量
          maxImages: 9,
          // 是否支持拍照
          enableCamera: true,
          cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
          materialOptions: MaterialOptions(
            // 显示所有照片，值为 false 时显示相册
            startInAllView: false,
            allViewTitle: '所有照片',
            actionBarColor: _primaryColor,
            statusBarColor: _primaryColor,
            textOnNothingSelected: '没有选择照片',
          )
      );
    } on Exception catch (e) {
      ToastWidget.showToastMsg(e.toString());
    }
    if (!mounted) return;
    if (resultList.isNotEmpty) {
      _upImg(resultList);
    }
  }

  _upImg(List<Asset> li) async {
    // 上传照片时一张一张上传
    for(int i = 0; i < li.length; i++) {
      // 获取 ByteData
      String _type =  li[i].name!.split(".")[li[i].name!.split(".").length - 1];
      ByteData byteData = await li[i].getByteData();
      List<int> imageData = byteData.buffer.asUint8List();
      MultipartFile multipartFile = MultipartFile.fromBytes(
        imageData,
        filename:li[i].name,
        contentType: MediaType("image",_type),// 文件类型
      );
      FormData formData =  FormData.fromMap({
        "file": multipartFile,
        "kind":_type
      });
      var response =  await Request().post(Api.url['uploadImg'], data: formData, downloadProgress:(val){
        ToastWidget.showToastMsg(val);
      });
      if(response['code'] == 200){
        Map data = response['data']['files'][0];
        _imagesList.add(data);
        widget.callback?.call(_imagesList);
        setState(() { });
      }else{
        ToastWidget.showToastMsg('请重试');
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _imagesList = widget.imgList;
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
            onTap: _uploadImages,
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
                url:  _imagesList[index],
                  // url:Api.baseUrlApp + '/' + _imagesList[index]['path'],
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

  Widget _createGridViewItem(Widget child, index) {
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(px(12.0)))
        ),
        child: Stack(
            children: [
              InkWell(
                child: child,
                onTap: (){
                  List _img = [];
                  for (var item in _imagesList) {
                    _img.add(Api.baseUrlApp + '/' + item['path']);
                  }
                  Navigator.of(context).push(FadeRoute(page: PhotoViewGalleryScreen(
                    images:_img,//传入图片list
                    index: index,//传入当前点击的图片的index
                    heroTag: _img[index],//传入当前点击的图片的hero tag （可选）
                  )));
                },
              ),
              if(widget.closeIcon)Positioned(
                  top: 0,
                  right: 0,
                  child: GestureDetector(
                      onTap: () {
                        setState(() {
                          // _imagesAsset.removeAt(index);
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