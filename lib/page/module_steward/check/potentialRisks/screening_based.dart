import 'package:flutter/material.dart';
import 'package:scet_check/page/module_steward/check/hiddenParame/components/rectify_components.dart';
import 'package:scet_check/page/module_steward/law/essential_gist.dart';
import 'package:scet_check/page/module_steward/law/policy_stand.dart';
import 'package:scet_check/page/module_steward/personal/components/task_compon.dart';

///排查法律依据、排查标准
///law:法律法规/排查标准
///search：是否只看
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
      backgroundColor: Colors.white,
      body: Column(
        children: [
          TaskCompon.topTitle(
              title: law ? '请选择法律法规':'请选择排查标准',
              left: true,
              callBack: (){
                Navigator.pop(context);
              }
          ),
          Expanded(
            child: law ?
            PolicyStand(
              search: false,
            ):
            EssentialGist(
              search: widget.arguments?['search'] ?? false,
            ),
          ),
        ],
      ),
    );
  }

}
