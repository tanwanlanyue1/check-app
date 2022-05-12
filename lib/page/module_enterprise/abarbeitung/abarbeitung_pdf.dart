import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:scet_check/api/api.dart';
import 'package:scet_check/api/request.dart';
import 'package:scet_check/components/generalduty/toast_widget.dart';
import 'package:scet_check/components/pertinence/companyFile/components/file_system.dart';
import 'package:scet_check/utils/screen/screen.dart';
import 'package:uuid/uuid.dart';

///上传整改报告
///url:上传路径
///uuid:uuid
/// inventoryId : 清单id
/// callback 回调方法
/// uploading ：是否允许上传
class AbarbeitungPdf extends StatefulWidget {
  final Function? callback;
  final String? url;
  final String? inventoryId;
  final bool uploading;
  final String? title;
  const AbarbeitungPdf({Key? key,
    this.callback,
    this.url,
    this.inventoryId,
    this.uploading = false,
    this.title,
  }) : super(key: key);
  @override

  @override
  _AbarbeitungPdfState createState() => _AbarbeitungPdfState();
}

class _AbarbeitungPdfState extends State<AbarbeitungPdf> {

  final List<dynamic> _imagesList = []; // 图片数组
  String _url = Api.url['uploadImg'];//url
  String _uuid = '';//uuid
  String inventoryId = '';//uuid
  String nameReports = '';//报告名称
  Uuid uuid = Uuid();//uuid

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
    if (result != null) {
      var isUp = await FileSystem.upload(result, url);
      if(widget.title == null){
        _setProblem(isUp?[0]['msg']);
        if(isUp?[0]!=false){
          widget.callback?.call(_imagesList);
        }
      }else{
        String filePath = (isUp![0]['msg']['data']['dir']+'/'+isUp[0]['msg']['data']['base']).replaceAll('\\', '/');
        nameReports = result.names[0]!;
        widget.callback?.call({'filePath':filePath,'name':nameReports});
      }
      setState(() {});
    }
  }

  /// 清单报告 填报post，
  /// id:uuid
  /// name:清单报告名称
  /// file:文件
  /// inventoryId:清单ID
  void _setProblem(Map? res) async {
    String filePath = (res?['data']['dir']+'/'+res?['data']['base']).replaceAll('\\', '/');
      Map _data = {
        'id': _uuid,
        'name': res?['data']['name'],
        'file': filePath,
        'inventoryId': inventoryId,
      };
      var response = await Request().post(
        Api.url['inventoryReport'],data: _data,
      );
      if(response['statusCode'] == 200) {
        widget.callback?.call(true);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    inventoryId = widget.inventoryId ?? '';
    _url = widget.url ?? Api.url['uploadImg'];
    _uuid = uuid.v4();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant AbarbeitungPdf oldWidget) {
    // TODO: implement didUpdateWidget
    inventoryId = widget.inventoryId ?? '';
    _url = widget.url ?? Api.url['uploadImg'];
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async{
        if(widget.uploading){
          _upload();
        }else{
          ToastWidget.showToastMsg('有问题未通过审核，请等待');
        }
      },
      child: widget.title == null ?
      Container(
        color: Colors.transparent,
        margin: EdgeInsets.only(right: px(24)),
        padding: EdgeInsets.only(left: px(24),right: px(24),top: px(5),bottom: px(5)),
        child: Text(widget.title ?? '上传PDF',style: TextStyle(fontSize: sp(28)),),
      ) :
      GestureDetector(
        child: Container(
          width: px(200),
          height: px(56),
          alignment: Alignment.center,
          margin: EdgeInsets.only(left: px(20)),
          child: Text(
            widget.title!,
            style: TextStyle(
                fontSize: sp(24),
                fontFamily: "R",
                color: Color(0xFF323233)),
          ),
          decoration: BoxDecoration(
            border: Border.all(width: px(2),color: Color(0XffE8E8E8)),
            borderRadius: BorderRadius.all(Radius.circular(px(28))),
          ),
        ),
        onTap: (){
          _upload();
        },
      ),
    );
  }

}