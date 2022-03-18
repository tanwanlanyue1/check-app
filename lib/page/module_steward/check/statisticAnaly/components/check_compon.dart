import 'package:flutter/material.dart';
import 'package:scet_check/utils/screen/screen.dart';


class CheckCompon {
  ///头部切换
  ///index： 下标
  ///tabBar： tab数组
  ///onTap： 回调
  static  Widget tabCut({int index = 0, List? tabBar, Function? onTap}) {
    return Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(tabBar?.length ?? 0, (i) {
          return GestureDetector(
            child: Container(
              height: px(64),
              width: px(206),
              alignment: Alignment.center,
              child: Text(
                "${tabBar![i]}",
                style: TextStyle(
                  fontSize: sp(28),
                  color: index == i ? Color(0xff84A7FF) : Color(0xff969799),
                  fontFamily: 'R',
                  fontWeight: index == i ? FontWeight.bold : FontWeight.w100,
                ),
              ),
            ),
            onTap: () {
              onTap?.call(i);
            },
          );
        }
        ));
  }

  ///背景
  ///pageIndex: 下标
  ///offestLeft: 偏移量
  ///right: 居右
  static Widget bagColor({required int pageIndex, double offestLeft = 0, double right = 30}) {
    return Padding(
      padding: EdgeInsets.only(
        top: px(19),
        left: offestLeft,
      ),
      child: SizedBox(
        width: px(206),
        height: px(74),
        child: Image.asset('lib/assets/images/home/theFirstSection.png',),
      ),
    );
  }
}