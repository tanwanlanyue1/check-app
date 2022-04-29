import 'package:flutter/material.dart';
import 'package:scet_check/page/module_steward/check/hiddenParame/components/rectify_components.dart';
import 'package:scet_check/utils/screen/screen.dart';


///通知详情
class MessageDetailsPage extends StatefulWidget {
  const MessageDetailsPage({Key? key}) : super(key: key);

  @override
  _MessageDetailsPageState createState() => _MessageDetailsPageState();
}

class _MessageDetailsPageState extends State<MessageDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          RectifyComponents.appBarBac(),
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
                    child: Text("关于推送任务的通知",style: TextStyle(color: Color(0xff323233),fontSize: sp(32),
                      fontFamily: 'M',),maxLines: 1,overflow: TextOverflow.ellipsis,),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

}
