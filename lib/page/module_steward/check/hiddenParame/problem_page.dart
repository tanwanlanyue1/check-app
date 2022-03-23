import 'package:flutter/material.dart';

import 'components/rectify_components.dart';

///隐患问题页
class ProblemPage extends StatefulWidget {
  List hiddenProblem;
  ProblemPage({Key? key,required this.hiddenProblem}) : super(key: key);

  @override
  _ProblemPageState createState() => _ProblemPageState();
}

class _ProblemPageState extends State<ProblemPage> {
  List hiddenProblem = []; //隐患问题数组

  @override
  void initState() {
    // TODO: implement initState
    hiddenProblem = widget.hiddenProblem;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant ProblemPage oldWidget) {
    // TODO: implement didUpdateWidget
    hiddenProblem = widget.hiddenProblem;
    super.didUpdateWidget(oldWidget);
  }
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.only(top: 0),
      children: [
        Column(
          children: List.generate(hiddenProblem.length, (i) => RectifyComponents.rectifyRow(
              company: hiddenProblem[i],
              i: i,
              detail: true,
              review: false,
              callBack:(){
                Navigator.pushNamed(context, '/rectificationProblem',
                    arguments: {'check':true,'problemId':hiddenProblem[i]['id']}
                );
              }
          )),
        ),
      ],
    );
  }

}
