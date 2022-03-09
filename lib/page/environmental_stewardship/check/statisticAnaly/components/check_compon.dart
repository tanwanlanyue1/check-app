import 'package:flutter/material.dart';
import 'package:scet_check/utils/screen/screen.dart';


class CheckCompon {
  ///头部切换
  ///index： 下标
  ///tabBar： tab数组
  ///onTap： 回调
  static  Widget tabCut({int index = 0, List? tabBar, Function? onTap}) {
    return SizedBox(
      height: px(84),
      child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(tabBar?.length ?? 0, (i) {
            return GestureDetector(
              child: Container(
                height: px(64),
                alignment: Alignment.centerRight,
                child: Text(
                  i == 3 ?
                  "${tabBar![i]}   " :
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
          )),
    );
  }

  ///背景
  ///pageIndex: 下标
  ///offestLeft: 偏移量
  ///right: 居右
  static Widget bagColor({required int pageIndex, double offestLeft = 0, double right = 30}) {
    return Padding(
      padding: EdgeInsets.only(
        top: px(19),
        left: px(
            pageIndex == 0 ?
            offestLeft :
            pageIndex == 3 && offestLeft > 20 ?
            offestLeft - 20 :
            offestLeft > right ?
            offestLeft - right :
            offestLeft
        ),
      ),
      child: SizedBox(
        width: pageIndex == 0 || pageIndex == 3 ? px(180) : px(206),
        height: px(74),
        child: Image.asset('lib/assets/images/home/theFirstSection.png',
          fit: offestLeft == 0 ? BoxFit.fitHeight : BoxFit.fill,
        ),
      ),
    );
  }
}