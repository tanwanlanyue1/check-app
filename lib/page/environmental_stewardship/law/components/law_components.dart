import 'package:flutter/material.dart';
import 'package:scet_check/utils/screen/screen.dart';

class LawComponents{

  //搜索
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

 //一行俩个
 static Widget rowTwo({Widget? child,required Widget textChild}){
   return Row(
     children: [
       Container(
         width: px(30),
         height: px(30),
         margin: EdgeInsets.only(right: px(8)),
         child: child,
       ),
       textChild
     ],
   );
 }

 //单行输入框
 static Widget uniline({Function? callBack,String? hint,required TextEditingController textEditingController}){
   return Container(
     color: Colors.white,
     padding: EdgeInsets.only(left: px(30),top: px(26),bottom: px(12)),
     child: Column(
       children: [
         LawComponents.rowTwo(
             child: Image.asset('lib/assets/icons/other/rhombus.png'),
             textChild: Text('备注',style: TextStyle(color: Color(0xff969799),fontSize: sp(26),fontFamily: 'R'),)
         ),
         Container(
           height: px(56),
           margin: EdgeInsets.only(left: px(32),right: px(24)),
           decoration: BoxDecoration(
             border: Border(bottom: BorderSide(width: px(1.0),color: Color(0X99A1A6B3))),
           ),
           child: TextField(
             autofocus: false,
             onChanged: (value) {
               callBack?.call(value);
             },
             controller: textEditingController,
             decoration: InputDecoration(
               border: InputBorder.none,
               hintText: hint,
               hintStyle: TextStyle(
                   height: 0.8,
                   fontSize: sp(24),
                   color: Color(0xffC8C9CC),
                   fontFamily: 'R',
                   decorationStyle: TextDecorationStyle.dashed
               ),
             ),
           ),
         )
       ],
     ),
   );
 }
}