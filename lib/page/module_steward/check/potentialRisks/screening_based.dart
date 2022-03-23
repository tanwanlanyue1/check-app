import 'package:flutter/material.dart';
import 'package:scet_check/page/module_steward/law/essential_gist.dart';
import 'package:scet_check/page/module_steward/law/policy_stand.dart';
import 'package:scet_check/utils/screen/screen.dart';

///排查法律依据、排查标准
class ScreeningBased extends StatefulWidget {
  final Map? arguments;
  const ScreeningBased ({Key? key,this.arguments}) : super(key: key);

  @override
  _ScreeningBasedState createState() => _ScreeningBasedState();
}

class _ScreeningBasedState extends State<ScreeningBased > {
  bool law = true;


  @override
  void initState() {
    // TODO: implement initState
    law = widget.arguments?['law'] ?? true;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: Adapt.padTopH()),
        color: Colors.white,
        child: Column(
          children: [
            Text(law ? '请选择法律法规':'请选择排查标准', style: TextStyle(color: Color(0xff323233),
                fontSize: sp(30),fontFamily: 'M'),),
            Expanded(
              child: law ?
              PolicyStand(
                search: false,
              ):
              EssentialGist(
                search: false,
              ),
            ),
          ],
        ),
      ),
    );
  }

}
