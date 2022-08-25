import 'package:flutter/material.dart';
import 'package:scet_check/api/api.dart';
import 'package:scet_check/api/request.dart';
import 'package:scet_check/components/generalduty/toast_widget.dart';
import 'package:scet_check/page/module_steward/check/statisticAnaly/components/form_check.dart';
import 'package:scet_check/utils/screen/screen.dart';
import 'package:scet_check/utils/storage/data_storage_key.dart';
import 'package:scet_check/utils/storage/storage.dart';

import 'components/task_compon.dart';

///修改密码
class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  String passWord = "";//原密码
  String newPassWord = "";//新密码
  String affirmPassWord = "";//确认新密码
  final String _regExp= r"^[ZA-ZZa-z0-9_]+$"; //校验数字和字母

  /// 修改密码
  void _modifyPassword() async {
    if (passWord.isEmpty) {
      ToastWidget.showToastMsg('请输入原密码！');
    } else if (newPassWord.isEmpty) {
      ToastWidget.showToastMsg('请输入新密码！');
    } else if (affirmPassWord.isEmpty) {
      ToastWidget.showToastMsg('请输入确认密码！');
    } else if (newPassWord != affirmPassWord) {
      ToastWidget.showToastMsg('俩次密码输入不一致！');
    }else if (newPassWord.length < 6 || newPassWord.length > 20 || RegExp(_regExp).firstMatch(newPassWord) == null) {
      ToastWidget.showToastMsg('密码长度应为6-20位字母、数字组合！');
    }else{
      Map<String,dynamic> _data = {
        'oldPassword':passWord,
        'password':newPassWord,
        'rePassword':affirmPassWord,
      };
      var response = await Request().post(
          Api.url['modifyPassword'],data: _data
      );
      if(response['errCode'] == '10000') {
        if(StorageUtil().getString(StorageKey.password).length != 0){
          StorageUtil().setString(StorageKey.password, newPassWord.toString());
        }
        ToastWidget.showToastMsg('修改成功');
        Navigator.pop(context);
        synchronization();
      }else{
        ToastWidget.showToastMsg('${response['errDesc']}');
      }
    }
  }

  /// 修改密码后同步用户数据
  void synchronization() {
     Request().get(Api.url['synchronize']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TaskCompon.topTitle(
              title: '修改密码',
              home: true,
              callBack: (){
                  Navigator.pop(context);
              }
          ),
          change(),
          Spacer(),
          Container(
            margin: EdgeInsets.only(left: px(24),right: px(24),bottom: px(4)),
            child: FormCheck.submit(
                submits: '确认修改',
                submit: (){
                  _modifyPassword();
                },
                cancel: (){
                  Navigator.pop(context);
                }
            ),
          ),
        ],
      ),
    );
  }

  ///修改密码表单
  Widget change(){
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(left: px(24),right: px(24),top: px(24)),
      padding: EdgeInsets.only(left: px(24),right: px(24),top: px(24)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FormCheck.rowItem(
            title: "输入原密码",
            child: FormCheck.inputWidget(
                hintText: '请输入原密码',
                isPassWord: true,
                onChanged: (val){
                  passWord = val;
                }
            ),
          ),
          FormCheck.rowItem(
            title: "输入新密码",
            child: FormCheck.inputWidget(
                hintText: '请输入新密码',
                isPassWord: true,
                onChanged: (val){
                  newPassWord = val;
                }
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: px(150)),
            child: Text('密码长度应为6-20位字母、数字组合!',style: TextStyle(color: Colors.grey,fontSize: sp(18)),),
          ),
          FormCheck.rowItem(
            title: "确认新密码",
            child: FormCheck.inputWidget(
                hintText: '请确认新密码',
                isPassWord: true,
                onChanged: (val){
                  affirmPassWord = val;
                }
            ),
          ),
        ],
      ),
    );
  }
}
