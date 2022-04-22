import 'package:flutter/material.dart';
import 'package:scet_check/page/module_steward/check/hiddenParame/components/rectify_components.dart';
import 'package:scet_check/utils/screen/screen.dart';

class HomeClassify extends StatefulWidget {
  const HomeClassify({Key? key}) : super(key: key);

  @override
  _HomeClassifyState createState() => _HomeClassifyState();
}

///首页分类
class _HomeClassifyState extends State<HomeClassify> {
 List classify = ['统计分析','待办任务','已办任务','台账记录','法律规范','通知中心','分类分级','更多'];//分类

 //选择事件
 void selectClass(int index){
   switch(index) {
     case 0: Navigator.pushNamed(context, '/checkPage'); break;
     case 1: Navigator.pushNamed(context, '/backlogTask'); break;
     case 2: Navigator.pushNamed(context, '/haveDoneTask'); break;
     case 3: Navigator.pushNamed(context, '/historyTask'); break;
     case 4: Navigator.pushNamed(context, '/'); break;
     case 5: Navigator.pushNamed(context, '/'); break;
     case 6: Navigator.pushNamed(context, '/'); break;
     case 7: Navigator.pushNamed(context, '/'); break;
     default: Navigator.pushNamed(context, '/checkPage');

   }
 }

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: px(750),
            height: appTopPadding(context),
            color: Color(0xff19191A),
          ),
          RectifyComponents.topBar(
              title: '首页',
              callBack: (){
                Navigator.pop(context);
              }
          ),
          Container(
            margin: EdgeInsets.only(bottom: px(24)),
          ),//图表
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: px(24),right: px(24)),
              child: GridView.builder(
                shrinkWrap:true,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.all(0),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: classify.length,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(width: px(2)),
                        borderRadius: BorderRadius.all(Radius.circular(px(8))),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.margin),
                          Container(
                            child: Text('${classify[index]}'),
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      selectClass(index);
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

}