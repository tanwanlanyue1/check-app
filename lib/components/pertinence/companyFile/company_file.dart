import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:scet_check/api/request.dart';
import 'package:scet_check/components/generalduty/toast_widget.dart';
import 'package:scet_check/utils/screen/screen.dart';
import 'package:scet_check/utils/storage/storage.dart';
import 'package:scet_check/utils/time/utc_tolocal.dart';

import 'components/file_app_bars.dart';
import 'components/file_system.dart';
import 'components/progress.dart';
import 'components/show_ios_bottom_sheet.dart';

/// 企业文件
/// arguments:  {'path':path, 'title':item['name'], 'data':item};
/// path: 路径
/// title：页面标题
/// data：数据源 原列表中点击的当前项数据
class CompanyFile extends StatefulWidget {
  final Map? arguments;
  const CompanyFile({this.arguments, Key? key}) : super(key: key);

  @override
  _CompanyFileState createState() => _CompanyFileState();
}

class _CompanyFileState extends State<CompanyFile> {

  final String _baseUrl = ''; // 文件系统的路径
  final String _newUrl = ''; // 新建地址
  final String _delUrl = ''; // 删除地址
  final String _renameUrl = ''; // 重命名地址
  final String _copyUrl = ''; // 复制地址
  final String _upLoadUrl = ''; // 上传地址
  final String _downLoadUrl = ''; // 下载地址


  String _fileName = ''; // 新建文件夹名称

  final String _copyKey = 'copyFileMap'; //剪切复制待使用Map key

  final Map _copyFileMap = {
    'overwrite': false,
    'pasteFiles':[],
    'pasteMode': "copy",
    'pastePath': ""
  }; // 剪切复制待使用Map

  Map _directory = {}; // 当前文件夹全部数据

  List _file = []; // 文件列表

  List _selectFileList = []; // 当前选中数组

  bool _editor = false; // 是否编辑

  bool _isDownLoad = false; // 开启下载

  double _downLoadProgress = 0.0; // 下载进度

  @override
  void initState() {
    super.initState();
    _getFile();
  }

  /// 获取列表
  void _getFile() async {
    Map<String, dynamic> params = Map();
    params['path'] = widget.arguments?['path'] ?? '';
    params['name'] = widget.arguments?['name'] ?? '';
    var response = await Request().get(_baseUrl, data: params);
    if(response != null && mounted) {
      _selectFileList = [];
      _directory = response['data'];
      _file = response['data']['children'];
      setState(() {});
    }
  }

  /// 上传文件
  /// result: 文件数组
  void _upload(FilePickerResult result) async {

    if( widget.arguments == null){
      ToastWidget.showToastMsg('当前文件夹无法进行该操作');
      return;
    }

    String url = _baseUrl + _upLoadUrl + widget.arguments?['path'] +
        '&name='+ widget.arguments?['title']+
        '&relationId=' + widget.arguments?['data']['relationId'] +
        "&url=" + _directory['url'];

    var isUp = await FileSystem.upload(result, url);
    if(isUp != null) {
      _getFile();
    }
  }

  /// 判断权限 生成文件路径 创建下载文件
  /// data: 数据源
  /// url: 下载地址
  /// openFile:下载完成后是否打开
  void _downLoad(Map data,String url,{bool openFile = false}) async {
    FileSystem.downLoad(context, data, url,
        openFile: openFile,
        isDownLoad: (bool val){
          _isDownLoad = val;
          setState(() {});
        },
        progress: (double val){
          _downLoadProgress = val;
          setState(() {});
        }
    );
  }

  /// 新建文件夹
  /// newName:文件夹名称
  void _newFile(String newName) async {
    if( widget.arguments == null){
      ToastWidget.showToastMsg('当前文件夹无法进行该操作');
      return;
    }
    if(newName == ''){
      ToastWidget.showToastMsg('请先输入文件名');
      return;
    }
    String name = widget.arguments?['path'];

    Map<String, dynamic> params = Map();
    params['directory'] = _directory;
    params['newName'] = newName;
    params['oldName'] = '';
    params['type'] = 0;

    var response = await Request().post(_baseUrl + _newUrl + name, data: params);
    if(response['statusCode'] == 200) {
      ToastWidget.showToastMsg('新建成功');
      _getFile();
    }
  }

  /// 删除文件夹
  void _deleteFile() async {
    if(_selectFileList.isEmpty){
      ToastWidget.showToastMsg('请先选择文件');
      return;
    }
    ToastWidget.showDialog(
      msg: '是否确认删除选中项',
      ok: () async {
        String name = widget.arguments?['path'];
        List params = [];
        for(int i = 0; i < _selectFileList.length; i++){
          Map data = _selectFileList[i];
          Map _item = {
            'id': data['id'],
            'path': data['path'],
            'type': data['type'],
          };
          params.add(_item);
        }
        var response = await Request().delete(_baseUrl + _delUrl + name, data: params);
        if(response['statusCode'] == 200) {
          ToastWidget.showToastMsg('删除成功');
          _getFile();
        }
      }
    );
  }

  /// 重命名
  /// oldData:准备重命名的数据源
  /// newName:新名称
  void _renameFile(Map oldData,String newName) async {
    if(newName == ''){
      ToastWidget.showToastMsg('请先输入文件名');
      return;
    }
    String name = widget.arguments?['path'];

    Map<String, dynamic> params = Map();

    params['directory'] = _directory;
    params['id'] = oldData['id'];
    params['newName'] = newName;
    params['oldName'] = oldData['name'];
    params['type'] = oldData['type'];
    params['path'] = oldData['path'];

    var response = await Request().post(_baseUrl + _renameUrl + name, data: params);
    if(response['statusCode'] == 200) {
      ToastWidget.showToastMsg('重命名成功');
      _getFile();
    }
  }

  ///复制 / 剪切文件
  ///pasteMode: 类型 copy / cut
  void _copyFile({String pasteMode = "copy"}){
    if(_selectFileList.isEmpty) {
      ToastWidget.showToastMsg("请先选择文件");
      return;
    }
    _copyFileMap['pasteMode'] = pasteMode;
    _copyFileMap['pasteFiles'] = _selectFileList;
    StorageUtil().setJSON(_copyKey,_copyFileMap);
    _closeEditor(editor: false);
  }

  /// 复制/剪切以后的粘贴文件方法
  void _cutCopyFile( ) async {
    String name = widget.arguments?['path'];

    Map<String, dynamic> params = StorageUtil().getJSON(_copyKey);
    params['pastePath'] = name;

    var response = await Request().post(_baseUrl + _copyUrl + name, data: params);
    if(response['statusCode'] == 200) {
      ToastWidget.showToastMsg('粘贴成功');
      StorageUtil().setJSON(_copyKey,null);
      _getFile();
    }
  }

  ///  文件类型
  ///  type: 0 文件夹 1 文件
  ///  data: 数据源
  Map _types(int type,Map data) {
    Map _types = {
      'icon':'lib/assets/icons/form/other.png',
      'typename':'其他文件',
    };
    if(type == 0) {
      _types['icon'] = 'lib/assets/icons/form/folder.png';
      _types['typename'] = '文件夹';
    }
    if(type == 1) {
      if(data['mimetype'] == 'application/pdf' ){
          _types['icon'] = 'lib/assets/icons/form/pdf.png';
          _types['typename'] ='pdf';
      }
      if(data['mimetype'] == 'application/msword' ){
        _types['icon'] = 'lib/assets/icons/form/word.png';
        _types['typename'] = 'word';
      }
      if(data['mimetype'] == 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' || data['mimetype'].contains('excel')){
        _types['icon'] = 'lib/assets/icons/form/xls.png';
        _types['typename'] = '表格';
      }
      if(data['mimetype'] == 'text/plain' ){
        _types['icon'] = 'lib/assets/icons/form/txt.png';
        _types['typename'] = 'txt';
      }
      if(data['mimetype'] == 'image/jpeg' || data['mimetype'].contains('image')){
        _types['icon'] = 'lib/assets/icons/form/image.png';
        _types['typename']='图片';
      }
      if(data['mimetype'] == 'audio/mpeg,' || data['mimetype'].contains('audio')){
        _types['icon'] = 'lib/assets/icons/form/mp3.png';
        _types['typename']='音频';
      }
    }
    return _types;
  }

  /// 开启/关闭编辑状态
  /// editor:是否为编辑
  void _closeEditor({bool editor = false}) {
    _editor = editor;
    _selectFileList = [];
    setState(() {});
  }

  ///点击某一项数据
  /// index: 下标
  /// isSelect: 是否选中
  /// isShowToast: 是否显示吐司
  void _selectFiles({required int index,bool? isSelect,bool isShowToast = false}) {
    if(_file[index]['id'] == null) {
      if(isShowToast == true){
        ToastWidget.showToastMsg('该文件无任何操作！');
      }
      return;
    }
    if(isSelect != null){
      _file[index]['select'] = isSelect;
    }else{
      if(_file[index]['select'] == null) {
        _file[index]['select'] = true;
      } else {
        _file[index]['select'] = !_file[index]['select'];
      }
    }
    _addSelectFile(_file[index],_file[index]['select']);
  }

  ///选中或取消某项
  /// data: 数据源
  ///isAll: 是否为全选
  void _addSelectFile(Map data,bool isAll){
    int indexWhere = _selectFileList.indexWhere((item) => item['id'] == data['id']);
    if(indexWhere == -1) {
      _selectFileList.add(data);
    } else {
      if(isAll == false) {
        _selectFileList.removeAt(indexWhere);
      }
    }
  }

  ///监听返回
  ///如果为下载时 则返回为关闭下载加载框
  Future<bool> _onWillPop() async{
    if(_isDownLoad) {
      _isDownLoad = false;
      setState(() { });
      return await false;
    }else{
      Navigator.pop(context);
      return await false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar:FileAppBars(
          title: widget.arguments?['title'] ?? '一企一档',
          editor: _editor,
          cancels: (){
            _closeEditor(editor: !_editor);
            for(int i = 0; i < _file.length; i++){
              _selectFiles(index: i, isSelect: false);
            }
            setState(() {});
          },
          selectAll: (bool val){
            for(int i = 0; i < _file.length; i++){
              _selectFiles(index: i, isSelect: val);
            }
            setState(() {});
          },
          upload: () async {
            FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true);
            if (result != null) {
              _upload(result);
            }
          },
          newFolder:(){
            _fileName = '';
            ToastWidget.showInputDialog(
                context,
                msg: '新建文件夹',
                hintText: '请输入文件夹名称',
                onChange: (val) {
                  _fileName = val;
                },
                ok:() {
                  _newFile(_fileName);
                }
            );
          },
        ),
        body: Stack(
          children: [
            ListView.builder(
              padding: EdgeInsets.only(bottom: px(_editor ? 90: 0)),
              itemCount: _file.length,
              itemBuilder: (context,index){
                Map item = _file[index];
                return Row(
                  children: [
                    Expanded(
                      child: Container(
                        constraints: BoxConstraints(minHeight:  px(105),),
                        margin: EdgeInsets.symmetric(vertical: px(10), horizontal: px(15),),
                        child: Material(
                          child: Ink(
                              decoration:  BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(px(10.0)),
                              ),
                              child: InkResponse(
                                borderRadius: BorderRadius.all(Radius.circular(px(10.0))),
                                highlightShape: BoxShape.circle,
                                radius: px(600),
                                splashColor: Colors.black12,
                                containedInkWell: false,
                                onTap: () async {
                                  int type = item['type'];
                                  String path = item['path'];
                                  // 如果当前为选择就关闭打开方法
                                  if(_editor){
                                    _selectFiles(index: index,isShowToast: true);
                                    setState(() {});
                                  }else{
                                    if(type == 0) {
                                      Map arguments = {'path':path, 'title':item['name'], 'data':item};
                                      Navigator.pushNamed(context, '/companyFile',arguments:arguments ).then((value){
                                        _getFile();
                                      });
                                    }
                                    if(type == 1) {
                                      String url = _baseUrl + _downLoadUrl + item['id'];
                                      int? index = await showActionSheets(
                                          context: context,
                                          title: '请选择一种操作方式',
                                          titleColor: Colors.blue,
                                          item: ['下载并查看','仅下载文件']
                                      );
                                      if(index != null && index > 0 ) {
                                        _downLoad(item, url , openFile: index == 1 ? true : false);
                                      }
                                     }
                                  }
                                },
                                onLongPress: () {
                                  _closeEditor(editor: true);
                                  _selectFiles(index: index, isSelect: true, isShowToast: true);
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: px(10),),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        child: Image.asset(_types(item['type'],item)['icon'], height: px(90),width: px(90),fit: BoxFit.fill,),
                                      ),
                                      Expanded(
                                        child: Container(
                                          constraints: BoxConstraints(minHeight:  px(70),),
                                          margin: EdgeInsets.symmetric(vertical: px(0), horizontal: px(10),),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(item['name'],style: TextStyle(fontSize: sp(22),fontWeight: FontWeight.w600),),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(utcToLocal(item['mtime']),style: TextStyle(fontSize: sp(24),color: Colors.grey),),
                                                  Text(FileSystem.renderSize(item['size']),style: TextStyle(fontSize: sp(24),color: Colors.grey),),
                                                  Text(_types(item['type'],item)['typename'],style: TextStyle(fontSize: sp(24),color: Colors.grey),)
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                          ),
                        ),

                      ),
                    ),
                    Visibility(
                      child: Padding(
                        padding: EdgeInsets.only(right: px(20)),
                        child: InkWell(
                          onTap: () {
                            _selectFiles(index: index,isShowToast: true);
                            setState(() {});
                          },
                          child: _file[index]['select'] == true ?
                          Image.asset('lib/assets/icons/bottom-bar/select.png',width: px(40),):
                          Image.asset('lib/assets/icons/bottom-bar/unselect.png',width: px(40),),
                        ),
                      ),
                      visible: _editor,
                    ),
                  ],
                );
              },
            ),

            /// 文件的编辑操作
            Visibility(
              visible:_editor ,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: px(90),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                        top: BorderSide(width: px(1),color: const Color(0xfff6f6f6))
                    ),
                  ),
                  child: Row(
                    children: [
                      _iconButon(
                          icon:'lib/assets/icons/form/shear.png',
                          name: '剪切',
                          onTap: (){
                            _copyFile(pasteMode: 'cut');
                          }
                      ),
                      _iconButon(
                          icon:'lib/assets/icons/form/copy.png',
                          name: '复制',
                          onTap: (){
                            _copyFile(pasteMode: 'copy');
                          }
                      ),
                      _iconButon(
                          icon:'lib/assets/icons/form/rename.png',
                          name: '重命名',
                          onTap: () {
                            _fileName = '';
                            if( _selectFileList.isEmpty || _selectFileList.length > 1){
                              ToastWidget.showToastMsg('请选中一项重命名!');
                              return;
                            }
                            ToastWidget.showInputDialog(
                                context,
                                msg: '文件重命名',
                                hintText: _selectFileList[0]['name'],
                                onChange: (val) {
                                  _fileName = val;
                                },
                                ok: () {
                                  _renameFile(_selectFileList[0], _fileName);
                                }
                            );
                          }
                      ),
                      _iconButon(
                          icon:'lib/assets/icons/form/del.png',
                          name: '删除',
                          onTap: (){
                            _deleteFile();
                          }
                      ),
                    ],
                  ),
                ),
              ),
            ),

            /// 剪贴或复制之后的粘贴事件
            Visibility(
              visible:StorageUtil().getJSON(_copyKey) != null && StorageUtil().getJSON(_copyKey).length > 0,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: px(90),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                        top: BorderSide(width: px(1),color: const Color(0xfff6f6f6))
                    ),
                  ),
                  child: Row(
                    children: [
                      _iconButon(
                          icon:'lib/assets/icons/form/new.png',
                          name: '新建',
                          onTap: (){
                            _fileName = '';
                            ToastWidget.showInputDialog(
                                context,
                                msg: '新建文件夹',
                                hintText: '请输入文件夹名称',
                                onChange: (val){
                                  _fileName = val;
                                },
                                ok: (){
                                  _newFile(_fileName);
                                }
                            );
                          }
                      ),
                      _iconButon(
                          icon:'lib/assets/icons/form/paste.png',
                          name: '粘贴',
                          onTap: (){
                            _cutCopyFile();
                          }
                      ),
                      _iconButon(
                          icon: 'lib/assets/icons/form/cancels.png',
                          name: '取消',
                          onTap: (){
                            StorageUtil().setJSON(_copyKey,null);
                            setState(() { });
                          }
                      ),
                    ],
                  ),
                ),
              ),
            ),

            /// 下载的进度显示界面
            Visibility(
              visible: _isDownLoad,
              child: GestureDetector(
                child: Container(
                  width:Adapt.screenW(),
                  height: Adapt.screenH(),
                  child: Material(
                    color: Color.fromRGBO(0, 0, 0, 0.7),
                    child: Center(
                      child: CircleProgressWidget(
                          progress: Progress(
                              backgroundColor: Color(0xfff6f6f6),
                              value:_downLoadProgress,
                              radius: 100,
                              completeText: "下载完成",
                              color: Theme.of(context).primaryColor,
                              strokeWidth: 4,
                              style: TextStyle(color: Colors.white,fontSize: sp(30),fontWeight: FontWeight.bold)
                          )
                      ),
                    ),
                  ),
                )
            ),)
          ],
        ),
      ),
    );
  }

  /// 底部点击的图标按钮
  /// icon: 图标路径
  /// name：点击事件标题
  /// onTap: 点击事件的回调
 Widget _iconButon({required String icon,required String name,Function? onTap}){
    return Expanded(
        child: InkWell(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(icon,width: px(40),color: Colors.grey,),
              Text(name,style: TextStyle(fontSize: sp(20)),)
            ],
          ),
          onTap: (){
            onTap?.call();
          },
        )
    );
  }
}
