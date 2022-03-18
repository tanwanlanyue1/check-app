import 'package:flutter/material.dart';
import 'package:scet_check/utils/screen/screen.dart';
import 'package:scet_check/components/generalduty/down_input.dart';

///筛选下拉组件
///position: 出現的位置
///callback: 回调
class DropDownMenuRoute extends PopupRoute {
  final Rect position;
  int selectIndex;
  final callback;
  DropDownMenuRoute({
    required this.position,
    this.callback,
    this.selectIndex = 0,
  });

  @override
  // TODO: implement barrierColor
  Color? get barrierColor => null;

  @override
  // TODO: implement barrierDismissible
  bool get barrierDismissible => true;

  @override
  // TODO: implement barrierLabel
  String? get barrierLabel => null;
  List inventory = ['隐患排查清单','隐患排查问题列表'];

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    // TODO: implement buildPage
    return Builder(
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context,state){
            return CustomSingleChildLayout(
              delegate: DropDownMenuRouteLayout(
                  position: position,
                  menuHeight: Adapt.screenH()
              ),
              child: SizeTransition(
                  sizeFactor: Tween<double>(begin: 0.0, end: 1.0).animate(animation),
                  child: Material(
                    child: Container(
                      width: Adapt.screenW(),
                      height: px(550),
                      color: Color.fromRGBO(50, 50, 51, 0.0),
                      padding: EdgeInsets.only(top: px(18),left: px(8)),
                      child: Column(
                        children: [
                          Wrap(
                            children: List.generate(inventory.length, (i) {
                              return GestureDetector(
                                child: Container(
                                  margin: EdgeInsets.only(left: px(24),top: px(12)),
                                  height: px(48),
                                  width: px(240),
                                  color: Color(selectIndex == i ? 0xffEDF2FC : 0xffF0F1F5),
                                  alignment: Alignment.center,
                                  child: Text(inventory[i],style: TextStyle(color: Color(selectIndex == i ? 0xff4D7FFF : 0xff323233),fontSize: sp(24)),),
                                ),
                                onTap: (){
                                  selectIndex = i;
                                  state(() {});
                                },
                              );
                            }),
                          ),
                          Spacer(),
                          Row(
                            children: [
                              Expanded(
                                child: InkWell(
                                  child: Container(
                                    alignment: Alignment.center,
                                    color: Color(0xffE6EAF5),
                                    height: px(56),
                                    padding: EdgeInsets.only(left: px(49),right: px(49)),
                                    child: Text('取消',style: TextStyle(color: Color(0xff4D7FFF),fontSize: sp(24)),),
                                  ),
                                  onTap: (){
                                    Navigator.pop(context);
                                  },
                                ),
                              ),
                              Expanded(
                                child: InkWell(
                                  child: Container(
                                    color: Color(0xff4D7FFF),
                                    height: px(56),
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.only(left: px(49),right: px(49)),
                                    child: Text('确定',style: TextStyle(color: Colors.white,fontSize: sp(24)),),
                                  ),
                                  onTap: (){
                                    callback(selectIndex);
                                    Navigator.pop(context);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
              ),
            );
          });
        }
    );
  }

  @override
  // TODO: implement transitionDuration
  Duration get transitionDuration => Duration(milliseconds: 300);
}