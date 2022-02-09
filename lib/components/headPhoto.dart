import 'package:flutter/material.dart';
import 'package:scet_check/utils/screen/screen.dart';
//圆角头像
class HeadPhoto extends StatefulWidget {
  final String img;
  final double width;

  HeadPhoto({
    this.width = 120.0,// 默认宽高 120 * 120
    this.img = 'https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=855439901,3130950228&fm=26&gp=0.jpg'
  });

  @override
  _HeadPhotoState createState() => _HeadPhotoState();
}

class _HeadPhotoState extends State<HeadPhoto> {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: px(widget.width),
        height: px(widget.width),
        padding: EdgeInsets.all(px(4)),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular((px(widget.width / 2)),),
            image: DecorationImage(fit: BoxFit.fill, image: AssetImage('lib/assets/icons/my/circle.png'))),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(px(widget.width / 2)),
          child:Image.network(widget.img,fit: BoxFit.cover,)
        ),
    );
  }
}
