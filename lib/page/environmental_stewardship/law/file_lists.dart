import 'package:flutter/material.dart';
import 'package:scet_check/page/environmental_stewardship/check/hiddenParame/components/rectify_components.dart';
import 'package:scet_check/utils/screen/screen.dart';

//文件列表
class FileLists extends StatefulWidget {
  final Map? arguments;
  const FileLists({Key? key,this.arguments}) : super(key: key);

  @override
  _FileListsState createState() => _FileListsState();
}

class _FileListsState extends State<FileLists> {
  List standardFile  = [{'title':"中华人们共和国大气污染防治法","subTitle":"中华人民共和国主席令第三十一号"},
    {'title':"中华人们共和国大气污染防治法","subTitle":"中华人民共和国主席令第三十一号"}];
  String title = '国家';

  void hierarchySelect(int? type) {
    switch(type) {
      case 0: title = '国家标准文件';break;
      case 1: title = '地方标准文件';break;
      case 2: title = '行业标准文件';break;
      case 3: title = '通知文件';break;
      case 4: title = '其他文件';break;
      default: title = '国家标准文件';
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    hierarchySelect(widget.arguments?['type']);
    standardFile = widget.arguments?['file'];
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.only(top: 0),
        children: [
          RectifyComponents.topBar(
            title: title,
            callBack: (){
              Navigator.pop(context);
            }
          ),
          rectifyRow(),
        ],
      ),
    );
  }

  //文件列表
  Widget rectifyRow({Function? callBack}){
    return Column(
      children: List.generate(standardFile.length, (i) => Container(
        margin: EdgeInsets.only(top: px(4)),
        padding: EdgeInsets.only(left: px(32),top: px(24),bottom: px(24),right: px(20)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(px(4.0))),
        ),
        child: InkWell(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: px(34),
                    width: px(34),
                    margin: EdgeInsets.only(top: px(5)),
                    alignment: Alignment.center,
                    child: Text('${i+1}',style: TextStyle(color: Colors.white,fontSize: sp(22)),),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(px(20))),
                          gradient: LinearGradient(      //渐变位置
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight, //左下
                              stops: const [0.0, 1.0],         //[渐变起始点, 渐变结束点]
                              //渐变颜色[始点颜色, 结束颜色]
                              colors: const [Color.fromRGBO(128, 163, 255, 0.7), Color.fromRGBO(77, 127, 255, 0.9)]
                          ),
                      ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(left: px(16),right: px(16)),
                      child: Text('${standardFile[i]["name"]}',style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),),
                    ),
                  ),
                  SizedBox(
                    width: px(40),
                    height: px(40),
                    child: Image.asset('lib/assets/icons/other/right.png'),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(left: px(50),right: px(80)),
                child: Text('${standardFile[i]["documentNumber"]}',style: TextStyle(color: Color(0xff969799),fontSize: sp(24)),),
              ),
            ],
          ),
          onTap: (){
            callBack?.call();
          },
        ),
      )),
    );
  }
}
