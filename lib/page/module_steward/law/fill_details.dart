import 'package:flutter/material.dart';
import 'package:scet_check/page/module_steward/check/hiddenParame/components/rectify_components.dart';
import 'package:scet_check/utils/screen/screen.dart';
import 'package:scet_check/utils/storage/storage.dart';

///文件详情
///  law:true//展示提交
class FillDetails extends StatefulWidget {
  final Map? arguments;
  const FillDetails({Key? key,this.arguments}) : super(key: key);

  @override
  _FillDetailsState createState() => _FillDetailsState();
}

class _FillDetailsState extends State<FillDetails> {
  @override
  Widget build(BuildContext context) {
    print(widget.arguments);
    return Scaffold(
      appBar: RectifyComponents.appBarTop(),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            height: px(88),
            child: Row(
              children: [
                InkWell(
                  child: Container(
                    height: px(40),
                    width: px(41),
                    margin: EdgeInsets.only(left: px(20)),
                    child: Image.asset('lib/assets/icons/other/chevronLeft.png',fit: BoxFit.fill,)
                  ),
                  onTap: (){
                    Navigator.pop(context);
                  },
                ),
                Expanded(
                  flex: 1,
                  child: Center(
                    child: Text("${widget.arguments?['law']['title']}",style: TextStyle(color: Color(0xff323233),fontSize: sp(32),
                        fontFamily: 'M',),maxLines: 1,overflow: TextOverflow.ellipsis,),
                  ),
                ),
                InkWell(
                  child: Container(
                    padding: EdgeInsets.only(right: px(20),left: px(20)),
                    color: Colors.transparent,
                    child: Text('提交',style: TextStyle(fontSize: sp(24)),),
                  ),
                  onTap: (){
                    StorageUtil().setJSON('law',widget.arguments?['law']);
                    Navigator.of(context).popUntil(ModalRoute.withName('/fillInForm'));
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
