import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scet_check/api/api.dart';
import 'package:scet_check/api/request.dart';
import 'package:scet_check/components/generalduty/image_widget.dart';
import 'package:scet_check/model/provider/provider_details.dart';
import 'package:scet_check/page/module_steward/check/hiddenParame/components/rectify_components.dart';
import 'package:scet_check/utils/screen/screen.dart';
import 'package:scet_check/utils/storage/storage.dart';

import 'components/law_components.dart';

///排查要点详情
///arguments:{'id':详情id}
class EssentialDetails extends StatefulWidget {
  final Map? arguments;
  const EssentialDetails ({Key? key,this.arguments}) : super(key: key);

  @override
  _EssentialDetailsState createState() => _EssentialDetailsState();
}

class _EssentialDetailsState extends State<EssentialDetails> {
  TextEditingController textEditingController = TextEditingController();
  List subTitle = ['排查要点','标准规范','排查依据','违法依据'];//副标题
  Map gistDetails = {};//要点详情
  List imageDatile = [];//示例图片
  late ProviderDetaild _providerDetaild;

  /// 获取排查详情
  void _getBasis() async {
    var response = await Request().get(Api.url['basis']+'/${widget.arguments?['id']}',
    );
    if(response['statusCode'] == 200 && response['data'] != null) {
      gistDetails = response['data'];
      imageDatile = response['data']['images'] ?? [];
      setState(() {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    _getBasis();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    _providerDetaild = Provider.of<ProviderDetaild>(context, listen: true);
    return Scaffold(
      body: Column(
        children: [
          RectifyComponents.appBarBac(),
          top(),
          Expanded(
            child: ListView(
              padding: EdgeInsets.only(top: px(4)),
              children: [
                checkFrom(
                  title: '排查要点',
                  data: gistDetails['name'] ?? '',
                ),
                checkFrom(
                  title: '标准规范',
                  data: gistDetails['specification'] ?? '',
                ),
                checkFrom(
                  title: '排查依据',
                  data: gistDetails['checkBasis'] ?? '',
                ),
                checkFrom(
                  title: '违法依据',
                  data: gistDetails['illegalBasis'] ?? '',
                ),
                checkFrom(
                  title: '备注',
                  data: gistDetails['remark'] ?? '',
                ),
                example(),
              ],
            ),
          )
        ],
      ),
    );
  }

  ///头部
  Widget top(){
    return Container(
      color: Colors.white,
      height: px(88),
      child: Row(
        children: [
          InkWell(
            child: Container(
              height: px(40),
              width: px(41),
              margin: EdgeInsets.only(left: px(20)),
              child: Image.asset('lib/assets/icons/other/chevronLeft.png',fit: BoxFit.fill,),
            ),
            onTap: (){
              Navigator.pop(context);
            },
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Text("排查要点详情",style: TextStyle(color: Color(0xff323233),fontSize: sp(32),fontFamily: 'M'),),
            ),
          ),
          widget.arguments?['gist'] ?
          InkWell(
            child: Container(
                width: px(80),
                height: px(50),
                margin: EdgeInsets.only(right: px(20)),
                alignment: Alignment.center,
                child: Text('提交',style: TextStyle(fontSize: sp(24)),)
            ),
            onTap: (){
              StorageUtil().setJSON('gist',gistDetails);
              Navigator.of(context).popUntil(ModalRoute.withName('/fillInForm'));
            },
          ) : Container(),
        ],
      ),
    );
  }
  ///排查表单
  Widget checkFrom({String? title,String data = ''}){
    return Container(
      padding: EdgeInsets.only(left: px(30),top: px(26),bottom: px(12)),
      color: Colors.white,
      child: Column(
        children: [
          LawComponents.rowTwo(
            child: Image.asset('lib/assets/icons/other/rhombus.png'),
              textChild: Text('$title',style: TextStyle(color: Color(0xff969799),fontSize: sp(26),fontFamily: 'R'),)
          ),
          Container(
            padding: EdgeInsets.only(top: px(5),bottom: px(20)),
            margin: EdgeInsets.only(left: px(32),right: px(24),),
            alignment: Alignment.centerLeft,
            child: Text(data,style: TextStyle(color: Color(0xff323233),fontSize: sp(26),fontFamily: 'R'),),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(width: px(1.0),color: Color(0X99A1A6B3))),
            ),
          )
        ],
      ),
    );
  }


  ///示例
  Widget example(){
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(left: px(30),top: px(26),bottom: px(24)),
      margin: EdgeInsets.only(bottom: px(24)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LawComponents.rowTwo(
              child: Image.asset('lib/assets/icons/other/rhombus.png'),
              textChild: Text('示例图片',style: TextStyle(color: Color(0xff969799),fontSize: sp(26),fontFamily: 'R'),)
          ),
          // Container(
          //   margin: EdgeInsets.only(left: px(32),top: px(20),bottom: px(20)),
          //   child: Text('名称:示例名称',style: TextStyle(color: Color(0xff969799),fontSize: sp(26),fontFamily: 'R'),),
          // ),
          Visibility(
            visible: imageDatile.isNotEmpty,
            child: ImageWidget(
              imageList: imageDatile,
            ),
          )
        ],
      ),
    );
  }
}
