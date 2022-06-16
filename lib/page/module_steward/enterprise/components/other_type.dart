import 'package:flutter/material.dart';
import 'package:scet_check/utils/screen/screen.dart';

/// 其他信息
class OtherType extends StatefulWidget {
  const OtherType({Key? key}) : super(key: key);

  @override
  _OtherTypeState createState() => _OtherTypeState();
}

class _OtherTypeState extends State<OtherType> {
  final List _typeList = [
    {"name":"环保扩展信息", "path":'',},
    {"name":"产品信息", "path":'',},
    {"name":"原辅材料信息", "path":'',},
    {"name":"生产设施信息", "path":'',},
    {"name":"排污许可信息", "path":'',},
    {"name":"危险废物信息", "path":'',},
    {"name":"一般固废信息", "path":'',},
    {"name":"建设项目信息", "path":'',},
    {"name":"在线监测信息", "path":'',},
    {"name":"问题信息管理", "path":'',},
    {"name":"非道路机械信息", "path":'',},
    {"name":"污染源信息", "path":'',},
    {"name":"废气排放信息", "path":'',},
    {"name":"废水排放信息", "path":'',},
    {"name":"噪声排放信息", "path":'',},
    {"name":"生产工艺信息", "path":'',},
    {"name":"风险装置信息", "path":'',},
    {"name":"风险物资信息", "path":'',},
    {"name":"LDAR检测数据信息", "path":'',},
    {"name":"辐射安全许可信息", "path":'',},
    {"name":"应急信息管理", "path":'',},
    {"name":"应急预案管理", "path":'',},
    {"name":"应急专家信息", "path":'',},
    {"name":"应急物资信息", "path":'',},
  ];
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        shrinkWrap: true,
        itemCount: _typeList.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 2,
        ),
        padding: EdgeInsets.all(5.0),
        itemBuilder: (_, index){
          String color = '0xff4D7C${index.toRadixString(16)}F';
          Map item = _typeList[index];
          return InkWell(
          child: Container(
            color: Color(int.parse(color)),
            alignment: Alignment.center,
            child: Text('${item['name']}',style: TextStyle(
              color: Colors.white
            ),),
          ),
        );
        });
  }
}
