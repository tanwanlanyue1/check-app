import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
      // imageBuilder: (context, imageProvider) => Container(
      //   decoration: BoxDecoration(
      //     image: DecorationImage(
      //         image: imageProvider,
      //         fit: BoxFit.cover,
      //         colorFilter:
      //         ColorFilter.mode(Colors.red, BlendMode.colorBurn)),
      //   ),
      // ),
      placeholder: (context, url) => CircularProgressIndicator(),
      errorWidget: (context, url, error) => Icon(Icons.error),
      fit: widget.fits,
    );
  }

}
