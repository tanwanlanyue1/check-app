import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

///缓存图片
///url: 图片地址
///fits: 是否充满
class CachedNetwork extends StatefulWidget {
  final String? url;
  final BoxFit? fits;
  const CachedNetwork({Key? key,this.url,this.fits}) : super(key: key);

  @override
  _CachedNetworkState createState() => _CachedNetworkState();
}

class _CachedNetworkState extends State<CachedNetwork> {
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: '${widget.url}',
      placeholder: (context, url) => CircularProgressIndicator(),
      errorWidget: (context, url, error) => Icon(Icons.error),
      fit: widget.fits,
    );
  }

}
