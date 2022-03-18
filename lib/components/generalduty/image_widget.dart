import 'package:flutter/material.dart';
import 'package:scet_check/api/api.dart';
import 'package:scet_check/routers/router_animate/router_fade_route.dart';
import 'package:scet_check/utils/photoView/cached_network.dart';
import 'package:scet_check/utils/photoView/photo_view.dart';

///画廊
///imageList:图片列表
class ImageWidget extends StatelessWidget {
  final List imageList;
  ImageWidget({required this.imageList});

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
      itemCount: imageList.length,
      itemBuilder: (BuildContext context, int index) {
        return InkWell(
          child: CachedNetwork(
            url: Api.baseUrlApp + imageList[index],
            fits: BoxFit.cover,
          ),
          onTap: () {
            List _img = [];
            for (var item in imageList) {
              _img.add(Api.baseUrlApp + item);
            }
            Navigator.of(context).push(
              FadeRoute(
                page: PhotoViewGalleryScreen(
                  images: _img,
                  index: index,
                  heroTag: imageList[index],
                )
              )
            );
          },
        );
      },
    );
  }
}