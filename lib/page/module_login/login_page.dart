import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scet_check/api/api.dart';
import 'package:scet_check/api/request.dart';
import 'package:scet_check/components/toast_widget.dart';
import 'package:scet_check/page/module_login/components/login_components.dart';
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
  int _PopTrue = 1; //记录返回次数 为3就是退出app

  int _versions = 0; //单选
  //监听返回
  Future<bool> _onWillPop() {
    _PopTrue = _PopTrue + 1;
    ToastWidget.showToastMsg('再按一次退出');
    if (_PopTrue == 3) {
      pop();
    }
    return Future.delayed(Duration(seconds: 2), () {
      _PopTrue = 1;
      setState(() {});
      return false;
    });
  }

  static Future<void> pop() async {
    await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
  }

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
        onWillPop: _onWillPop,
        child: Scaffold(
            backgroundColor: Colors.white,
            body: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: SingleChildScrollView(
                child: Stack(
                  children: [_topLogos(), _loginInput()],
                ),
              ),
            )));
  }

  ///顶部背景logo
  Widget _topLogos() {
    return Container(
      height: px(518),
      padding: EdgeInsets.only(left: px(60)),
      alignment: Alignment.bottomLeft,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('lib/assets/images/login/bgImage.png'),
              fit: BoxFit.fill)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Image.asset(
            'lib/assets/images/login/logos.png',
            width: px(120),
            height: px(121),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: px(23),
              bottom: px(124),
            ),
            child: Text(
              '隐患排查与整改服务APP',
              style: TextStyle(
                  fontSize: sp(30), fontFamily: "M", color: Color(0xFFFFFFFF)),
            ),
          )
        ],
      ),
    );
  }

  ///登录框
  Widget _loginInput() {
    return Positioned(
      child: Container(
          width: double.infinity,
          margin: EdgeInsets.only(top: px(438)),
          padding: EdgeInsets.only(top: px(200)),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(
                px(46),
              ),
              topRight: Radius.circular(
                px(46),
              ),
            ),
            color: Colors.white,
          ),
          child: Column(
            children: [
              // _type(),
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
                  Navigator.pushNamed(context, '/');
                  // _postLogin(_userName, _password);
                },
              )
            ],
          )),
    );
  }
  //单选择
  Widget _radio() {
    return Container(
      margin: EdgeInsets.only(left: px(120)),
      child: Row(
        children: [
          Text(
            '请选择:',
            style: TextStyle(fontSize: sp(30), color: Color(0xFFA8ABB3)),
          ),
          SizedBox(
            child: Radio(
              value: 0,
              groupValue: _versions,
              onChanged: (value) {
                setState(() {
                  _versions = value as int;
                });
              },
            ),
            width: px(70),
          ),
          Text(
            "1",
            style: TextStyle(fontSize: sp(28)),
          ),
          SizedBox(
            child: Radio(
              value: 1,
              groupValue: _versions,
              onChanged: (value) {
                setState(() {
                  _versions = value as int;
                });
              },
            ),
            width: px(70),
          ),
          Text(
            "2",
            style: TextStyle(fontSize: sp(28)),
          )
        ],
      ),
    );
  }
}
