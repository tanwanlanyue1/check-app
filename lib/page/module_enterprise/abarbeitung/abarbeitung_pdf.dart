import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:scet_check/api/api.dart';
import 'package:scet_check/components/pertinence/companyFile/components/file_system.dart';
import 'package:scet_check/utils/screen/screen.dart';

///上传整改报告
///url:上传路径
///uuid:uuid
class AbarbeitungPdf extends StatefulWidget {
  final Function? callback;
  final String? uuid;
  final String? url;
  const AbarbeitungPdf({Key? key,
    this.callback,
    this.uuid,
    this.url,
  }) : super(key: key);
  @override

  @override
  _AbarbeitungPdfState createState() => _AbarbeitungPdfState();
}

class _AbarbeitungPdfState extends State<AbarbeitungPdf> {

  List<dynamic> _imagesList = []; // 图片数组
  String _uuid = '';//uuid
  String _url = Api.url['uploadImg'];//url

  /// 上传pdf文件
  /// result: 文件数组
  /// 处理上传图片返回回来的格式，将\转化为/
  void _upload() async {
    String url = _url + _uuid;
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    print('url>>>>>>>>$url');
    if (result != null) {
      var isUp = await FileSystem.upload(result, url);
      print('url>>>>>>>>$url');
      print('>>>>>>>>$isUp');
      if(isUp?[0]!=false){

        widget.callback?.call(_imagesList);
      }
      setState(() {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    _uuid = widget.uuid ?? '';
    _url = widget.url ?? Api.url['uploadImg'];
    super.initState();
  }

  @override
  void didUpdateWidget(covariant AbarbeitungPdf oldWidget) {
    // TODO: implement didUpdateWidget
    _uuid = widget.uuid ?? '';
    _url = widget.url ?? Api.url['uploadImg'];
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async{
        _upload();
      },
      child: Container(
        width: px(169),
        height: px(169),
        color: Color(0XFFF5F6FA),
        child: Image.asset('lib/assets/icons/form/camera.png'),
      ),
    );
  }

}
