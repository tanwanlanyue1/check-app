import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scet_check/api/api.dart';
import 'package:scet_check/api/request.dart';
import 'package:scet_check/components/toast_widget.dart';
import 'package:scet_check/page/module_login/components/login_components.dart';
import 'package:scet_check/utils/logOut/log_out.dart';
import 'package:scet_check/utils/screen/screen.dart';
import 'package:scet_check/utils/storage/data_storage_key.dart';
import 'package:scet_check/utils/storage/storage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _userName = ''; // 账号
  String _password = ''; // 密码
  int _popTrue = 1; //记录返回次数 为3就是退出app


  //登录
  void _postLogin(String userName, String passWord) async {
    if (userName.isEmpty) {
      ToastWidget.showToastMsg('请输入您的登录账号！');
    } else if (passWord.isEmpty) {
      ToastWidget.showToastMsg('请输入您的登录密码！');
    } else if (userName.isNotEmpty && passWord.isNotEmpty) {
      Map<String, String> _data = {
        'account': userName,
        'password': passWord,
      };
      var response = await Request().post(Api.url['login'], data: _data);
      if (response['code'] == 200) {
        saveInfo(response['data']['token'], _data['name'], _data['password'], response['data']['user']);
          switch(response['data']){
            case 1 :
              Navigator.pushNamedAndRemoveUntil(context,'/steward', (Route route)=>false);//删除所有，只留下steward
              // Navigator.of(context).pushAndRemoveUntil(CustomRoute(steward()), (router) => router == null);break;
              break;
          }
      } else if (response['code'] == 500) {
        if (response['status'] == null) {
          ToastWidget.showToastMsg('用户名或密码错误！');
        } else {
          ToastWidget.showToastMsg('${response['status']}！');
        }
      }
    }
  }

  //  缓存token
  void saveInfo(token, userName, passWord, Map personalData) {
    StorageUtil().setString(StorageKey.Token, token.toString());
    StorageUtil().setJSON(StorageKey.PersonalData, personalData);
    StorageUtil().setString('userName', userName.toString());
    StorageUtil().setString('password', passWord.toString());
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: LogOut.onWillPop,
        child: Scaffold(
            body: GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: ListView(
                children: [
                  SizedBox(
                    height: Adapt.screenH(),
                    child: Stack(
                      children: [
                        _bottomLogos(),
                        _topLogos(),
                        _loginInput()
                      ],
                    ),
                  )
                ],
              ),
            ),
        )
    );
  }

  //顶部背景logo
  Widget _topLogos() {
    return Positioned(
      child: Container(
        height: px(829),
        width: double.infinity,
        margin: EdgeInsets.only(left: px(32),right: px(32),top: px(52)),
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('lib/assets/images/login/loginBg.png'),
            ),
        ),
        child: Column(
          children: [
            Container(
              width: px(160),
              height: px(160),
              margin: EdgeInsets.only(top: px(130)),
              child: Image.asset('lib/assets/images/login/logo.png',),
            )
          ],
        ),
      ),
    );
  }

  //登录框
  Widget _loginInput() {
    return Container(
        width: double.infinity,
        margin: EdgeInsets.only(top: px(438)),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(px(46),),
            topRight: Radius.circular(px(46),),
          ),
        ),
        child: Column(
          children: [
            LoginComponents.loginInput(
                icon: 'lib/assets/icons/login/people.png',
                hitStr: '请输入账号',
                onChange: (val) {
                  _userName = val;
                  setState(() {});
                }),
            LoginComponents.loginInput(
                icon: 'lib/assets/icons/login/password.png',
                hitStr: '请输入密码',
                isPassWord: true,
                onChange: (val) {
                  _password = val;
                  setState(() {});
                }),
            LoginComponents.loginBtn(
              onTap: () {
                Navigator.pushNamed(context, '/steward');
                // _postLogin(_userName, _password);
              },
            )
          ],
        ));
  }
  //底部背景logo
  Widget _bottomLogos() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: px(860),
        width: Adapt.screenW(),
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('lib/assets/images/login/bgImage.png'),
                fit: BoxFit.fill)
        ),
      ),
    );
  }
}
