import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:scet_check/utils/screen/screen.dart';
import 'package:scet_check/utils/storage/data_storage_key.dart';
import 'package:scet_check/utils/storage/storage.dart';

//个人中心
class PersonalCenter extends StatefulWidget {
  const PersonalCenter({Key? key}) : super(key: key);

  @override
  _PersonalCenterState createState() => _PersonalCenterState();
}

class _PersonalCenterState extends State<PersonalCenter> {
  String userName = ''; //用户名
  String userId = ''; //用户id
  List classify = ['历史台账','待办任务','已办任务'];//分类

  @override
  void initState() {
    // TODO: implement initState
    userId= jsonDecode(StorageUtil().getString(StorageKey.PersonalData))['id'];
    userName= jsonDecode(StorageUtil().getString(StorageKey.PersonalData))['nickname'];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xffE8E8E8),
      child: Column(
        children: [
          Container(
            width: px(750),
            height: appTopPadding(context),
            color: Color(0xff19191A),
          ),
          _header(),
          Column(
            children: List.generate(classify.length, (i){
              return taskList(i);
            }),
          )
        ],
      ),
    );
  }
  ///头部
  Widget _header(){
    return Container(
      // height: px(100),
      width: double.infinity,
      margin: EdgeInsets.only(left: px(24),right: px(24),top: px(24)),
      padding: EdgeInsets.only(left: px(24),right: px(24),top: px(8),bottom: px(8)),
      color: Colors.white,
      child: Row(
        children: [
          Container(
            width: px(100),
            height: px(100),
            decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius:BorderRadius.all(Radius.circular(px(150))),
                border: Border.all(width: px(2),color: Colors.white)
            ),
            child: Image.asset('lib/assets/images/home/header.png',
              width: px(30),
              height: px(30),
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: px(25)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    userName,
                    style: TextStyle(
                        fontSize: sp(36),
                        color: Color(0XFF2E2F33),
                        fontFamily: "M"
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: px(8.0)),
                    child: Text('环保管家',style: TextStyle(fontSize: sp(22),color: Color(0XFF2E2F33))),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  ///任务列表
  ///判断跳转位置
  Widget taskList(int i){
    return Container(
      margin: EdgeInsets.only(top: px(24),left: px(20),right: px(24)),
      padding: EdgeInsets.only(left: px(16),top: px(20),bottom: px(20)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(px(8.0))),
      ),
      child: InkWell(
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(left: px(16),right: px(12)),
                  child: Text('${classify[i]}',style: TextStyle(color: Color(0xff323233),fontSize: sp(30),overflow: TextOverflow.ellipsis),),
                ),
                Spacer(),
                SizedBox(
                  width: px(140),
                  height: px(48),
                  child: Text('2022-4-21',
                    style: TextStyle(color: Color(0xff323233),fontSize: sp(24)),),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: px(20)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: px(12)),
                    child: Text('副标题',
                      style: TextStyle(color: Color(0xff323233),fontSize: sp(24)),),
                  ),
                  Spacer(),
                  Container(
                      width: px(64),
                      height: px(64),
                      margin: EdgeInsets.only(right: px(24),left: px(20)),
                      child: Image.asset('lib/assets/icons/other/right.png')
                  ),
                ],
              ),
            ),
          ],
        ),
        onTap: () {
          if (i == 0) {
            Navigator.pushNamed(context, '/historyTask');
          } else if (i == 1) {
            Navigator.pushNamed(context, '/backlogTask');
          } else {
            Navigator.pushNamed(context, '/haveDoneTask');
          }
        }
      ),
    );
  }

}
