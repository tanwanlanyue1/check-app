import 'package:flutter/material.dart';
import 'package:scet_check/utils/screen/screen.dart';

class LawComponents{

  ///搜索
  ///callBack:回调函数
  ///textEditingController:TextField控制器
 static Widget search({Function? callBack,required TextEditingController textEditingController}){
    return Container(
      height: px(56),
      margin: EdgeInsets.only(left: px(24),right: px(24)),
      decoration: BoxDecoration(
          color: Color(0xffF5F6FA),
          borderRadius: BorderRadius.circular(4)),
      child: TextField(
        autofocus: false,
        onChanged: (value) {
          callBack?.call(value);
        },
        controller: textEditingController,
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: Image.asset(
            'lib/assets/icons/other/search.png',
            color: Color(0xffC8C9CC),),
          suffixIcon: Offstage(
            offstage: textEditingController.text.isEmpty,
            child: InkWell(
              onTap: () {
                textEditingController.clear();
              },
              child: Icon(
                Icons.cancel,
                color: Colors.grey,
              ),
            ),
          ),
          hintText: '搜索',
          hintStyle: TextStyle(
              height: 0.8,
              fontSize: sp(24),
              color: Color(0xffC8C9CC),
              fontFamily: 'R',
              decorationStyle: TextDecorationStyle.dashed
          ),
        ),
      ),
    );
  }

 ///左图标一行俩个
 ///child : 左组件
 ///textChild : 右组件
 static Widget rowTwo({Widget? child,required Widget textChild}){
   return Row(
     crossAxisAlignment: CrossAxisAlignment.start,
     children: [
       Container(
         width: px(30),
         height: px(30),
         margin: EdgeInsets.only(right: px(8)),
         child: child,
       ),
       Expanded(
         child: textChild,
       )
     ],
   );
 }

}