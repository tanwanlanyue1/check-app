import 'package:flutter/material.dart';
import 'package:scet_check/utils/screen/adapter.dart';
import 'package:scet_check/utils/screen/screen.dart';

/// 文件系统的导航栏
class FileAppBars extends StatefulWidget implements PreferredSizeWidget {
  final String? title; // 标题
  final bool editor; // 是否编辑
  final Function? cancels; // 取消按钮
  final Function? selectAll; // 全选按钮
  final Function? upload; // 上传按钮
  final Function? newFolder; // 新建按钮

  FileAppBars({
    this.title,
    this.cancels,
    this.selectAll,
    this.upload,
    this.newFolder,
    this.editor = false,
  });

  @override
  _FileAppBarsState createState() => _FileAppBarsState();

  @override
  Size get preferredSize {
    return Size(Adapt.screenW(), px(Adapter.topBarHeight));
  }
}

class _FileAppBarsState extends State<FileAppBars> {

  bool all = false; // 是否为全选

  @override
  void initState() {
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return PreferredSize(
        preferredSize: Size(Adapt.screenW(), px(Adapter.topBarHeight)),
        child: AppBar(
          title: Text(
            '${widget.title}',
            style: TextStyle(fontSize: sp(25.0), color: Colors.white),
          ),
          automaticallyImplyLeading: false,
          leading: InkWell(
              child: Container(
                alignment: Alignment.center,
                child: Image.asset(
                  'lib/assets/icons/form/leading.png',
                  width: px(42),
                  height: px(42),
                ),
              ),
              onTap: () {
                Navigator.pop(context);
              }),
          actions: <Widget>[
            if (widget.editor)
              InkWell(
                  child: Container(
                    width: px(70),
                    child:Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: Image.asset(
                            'lib/assets/icons/form/${all ? 'all': 'unAll'}.png',
                            width: px(35),
                          ),
                        ),
                        Text('${all ? '反': '全'}选',style: TextStyle(fontSize: sp(20.0), color: Colors.white),)
                      ],
                    ),
                  ),
                  onTap: () async {
                    all = !all;
                    widget.selectAll?.call(all);
                    setState(() { });
                  }
              ),
            if (widget.editor)
              InkWell(
                  child: Container(
                    width: px(70),
                    child:Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: Image.asset(
                            'lib/assets/icons/form/cancels.png',
                            width: px(35),
                          ),
                        ),
                        Text('取消',style: TextStyle(fontSize: sp(20.0), color: Colors.white),)
                      ],
                    ),
                  ),
                  onTap: () async {
                    widget.cancels?.call();
                  }
              ),
            if (!widget.editor)
              InkWell(
                child: Container(
                  width: px(70),
                  child:Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: Image.asset(
                          'lib/assets/icons/form/upload.png',
                          width: px(35),
                          color: Colors.white,
                        ),
                      ),
                      Text('上传',style: TextStyle(fontSize: sp(20.0), color: Colors.white),)
                    ],
                  ),
                ),
                onTap: () async {
                  widget.upload?.call();
                }
            ),
            if (!widget.editor)
              InkWell(
                  child: Container(
                    width: px(70),
                    child:Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: Image.asset(
                            'lib/assets/icons/form/new.png',
                            width: px(35),
                            color: Colors.white,
                          ),
                        ),
                        Text('新建',style: TextStyle(fontSize: sp(20.0), color: Colors.white),)
                      ],
                    ),
                  ),
                  onTap: () async {
                    widget.newFolder?.call();
                  }
              ),
          ],
          elevation: 0,
        ));
  }
}
