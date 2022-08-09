import 'package:flutter/material.dart';
import 'package:scet_check/utils/screen/screen.dart';


class CheckCompon {
  ///头部切换
  ///index： 下标
  ///tabBar： tab数组
  ///onTap： 回调
  static Widget tabCut({int index = 0, List? tabBar, Function? onTap, required double itemWidth}) {
    return Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(tabBar?.length ?? 0, (i) {
          return GestureDetector(
            child: Container(
              height: px(88),
              width: px(itemWidth),
              alignment: Alignment.center,
              color: Colors.transparent,
              child: Text(
                "${tabBar![i]}",
                style: TextStyle(
                  fontSize: sp(32),
                  color: index == i ? Color(0xFF3377FF) : Color(0xff969799),
                  fontFamily: index == i ? 'M' :'R',
                ),
              ),
            ),
            onTap: () {
              onTap?.call(i);
              // print('i==>${i}');
            },
          );
        }
        ));
  }
  ///背景
  ///pageIndex: 下标
  ///offestLeft: 偏移量
  ///right: 居右
  static Widget bagColor({ double offestLeft = 0, double right = 30,required double itemWidth}) {
    return Padding(
      padding: EdgeInsets.only(
        left: offestLeft,
      ),
      child: SizedBox(
        width: px(itemWidth),
        height: px(88),
        child: Container(
          width: px(24),
          height: px(25),
          child: Image.asset('lib/assets/images/home/theFirstSection.png',fit: BoxFit.fill, width: px(24), height: px(25),),
        ),
      ),
    );
  }
}