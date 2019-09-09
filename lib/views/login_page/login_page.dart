import 'package:flutter/material.dart';
import '../../utils/style.dart';
import '../../api/user.dart';
import '../../utils/sp_utils.dart';
import '../../resources/sp_keys.dart';
import '../../routers/routers.dart';
import '../../utils/log_utils.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _uController = TextEditingController();
  final _pController = TextEditingController();
  String _username = '';
  String _password = '';
  bool _isObscure = true;
  bool _isRememberPassword = false;
  Color _eyeColor;
  SpUtil sp;
  List _loginMethod = [
    // {
    //   "title": "facebook",
    //   "icon": GroovinMaterialIcons.facebook,
    // },
    // {
    //   "title": "google",
    //   "icon": GroovinMaterialIcons.google,
    // },
    // {
    //   "title": "twitter",
    //   "icon": GroovinMaterialIcons.twitter,
    // },
  ];

  _LoginPageState() {
    LogUtil.init(isDebug: LogUtil.debuggable, tag: "###LoginPage###");
  }

  @override
  void initState() {
    super.initState();
    initSp();
  }

  initSp() async {
    // 获取存储句柄
    sp = await SpUtil.getInstance();
    bool remember = sp.getBool(SpKeys.isRememberPassword) ?? false;
    LogUtil.e('is remember password: $remember');
    if (remember) {
      String username = sp.getString(SpKeys.name);
      LogUtil.e('username: $username');
      String password = sp.getString(SpKeys.password);
      LogUtil.e('password: $password');
      setState(() {
        _username = username;
        _uController.text = username;
        _password = password;
        _pController.text = password;
        _isRememberPassword = remember;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _uController.dispose();
    _pController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Form(
            key: _formKey,
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 22.0),
              children: <Widget>[
                SizedBox(
                  height: kToolbarHeight,
                ),
                buildTitle(),
                buildTitleLine(),
                SizedBox(height: 70.0),
                // buildEmailTextField(),
                buildUsernameTextField(),
                SizedBox(height: 30.0),
                buildPasswordTextField(context),
                buildForgetPasswordText(context),
                SizedBox(height: 60.0),
                buildLoginButton(context),
                SizedBox(height: 30.0),
                // buildOtherLoginText(),
                // buildOtherMethod(context),
                // buildRegisterText(context),
              ],
            )));
  }

  Align buildRegisterText(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: EdgeInsets.only(top: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('没有账号？'),
            GestureDetector(
              child: Text(
                '点击注册',
                style: TextStyle(color: Colors.green),
              ),
              onTap: () {
                print('去注册');
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  ButtonBar buildOtherMethod(BuildContext context) {
    return ButtonBar(
      alignment: MainAxisAlignment.center,
      children: _loginMethod
          .map((item) => Builder(
                builder: (context) {
                  return IconButton(
                      icon: Icon(item['icon'], color: Theme.of(context).iconTheme.color),
                      onPressed: () {
                        Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text("${item['title']}登录"),
                          action: SnackBarAction(
                            label: "取消",
                            onPressed: () {},
                          ),
                        ));
                      });
                },
              ))
          .toList(),
    );
  }

  Align buildOtherLoginText() {
    return Align(
        alignment: Alignment.center,
        child: Text(
          '其他账号登录',
          style: TextStyle(color: Colors.grey, fontSize: 14.0),
        ));
  }

  Align buildLoginButton(BuildContext context) {
    return Align(
      child: SizedBox(
        height: 45.0,
        width: 270.0,
        child: RaisedButton(
          child: Text(
            '登录',
            style: Theme.of(context).primaryTextTheme.headline,
          ),
          onPressed: () async {
            if (_formKey.currentState.validate()) {
              ///只有输入的内容符合要求通过才会到达此处
              _formKey.currentState.save();
              try {
                var value = await UserAPI.login(_username, _password);
                sp.putString(SpKeys.token, value.tokenType + " " + value.accessToken);
                var user = await UserAPI.getUserInfo();
                sp.putStringList(SpKeys.roles, user.roles);
                sp.putString(SpKeys.name, user.name);
                sp.putString(SpKeys.id, user.id);
                sp.putBool(SpKeys.isRememberPassword, _isRememberPassword);
                if (_isRememberPassword) {
                  sp.putString(SpKeys.password, _password);
                } else {
                  sp.putString(SpKeys.password, '');
                }
                Navigator.of(context).pushNamedAndRemoveUntil(Routes.home, (route) => route == null);
              } catch (e) {
                sp.putBool(SpKeys.isRememberPassword, _isRememberPassword);
                sp.putString(SpKeys.name, _username);
                if (_isRememberPassword) {
                  sp.putString(SpKeys.password, _password);
                } else {
                  sp.putString(SpKeys.password, '');
                }
                _showDialog();
              }
            } else {
              print('validate false');
            }
          },
          shape: StadiumBorder(side: BorderSide()),
        ),
      ),
    );
  }

  Padding buildForgetPasswordText(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Align(
        alignment: Alignment.centerRight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                Checkbox(
                  value: _isRememberPassword,
                  onChanged: (bool value) {
                    setState(() {
                      _isRememberPassword = value;
                    });
                  },
                ),
                Text(
                  '记住密码',
                  style: TextStyle(fontSize: 14.0, color: Colors.grey),
                ),
              ],
            ),
            FlatButton(
              child: Text(
                '忘记密码？',
                style: TextStyle(fontSize: 14.0, color: Colors.grey),
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(Routes.resetPassword);
              },
            ),
          ],
        ),
      ),
    );
  }

  TextFormField buildPasswordTextField(BuildContext context) {
    return TextFormField(
      controller: _pController,
      onSaved: (String value) => _password = value,
      obscureText: _isObscure,
      validator: (String value) {
        if (value.isEmpty) {
          return '请输入密码';
        }
        return null;
      },
      decoration: InputDecoration(
          labelText: '密码',
          suffixIcon: IconButton(
              icon: Icon(
                Icons.remove_red_eye,
                color: _eyeColor,
              ),
              onPressed: () {
                setState(() {
                  _isObscure = !_isObscure;
                  _eyeColor = _isObscure ? Colors.grey : Theme.of(context).iconTheme.color;
                });
              })),
    );
  }

  TextFormField buildUsernameTextField() {
    return TextFormField(
      controller: _uController,
      decoration: InputDecoration(
        labelText: '用户名',
      ),
      validator: (String value) {
        if (value.isEmpty) {
          return '请输入用户名';
        }
        return null;
      },
      onSaved: (String value) => _username = value,
    );
  }

  Padding buildTitleLine() {
    return Padding(
      padding: EdgeInsets.only(left: 12.0, top: 4.0),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Container(
          color: Color(AppColor.gridGreen),
          width: 40.0,
          height: 2.0,
        ),
      ),
    );
  }

  Padding buildTitle() {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(
        '登录',
        style: TextStyle(
          fontSize: 42.0,
          color: Color(AppColor.gridGreen),
        ),
      ),
    );
  }

  void _showDialog() {
    showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text('用户名密码错误'),
          actions: <Widget>[
            new FlatButton(
              child: new Text('确定'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );

  }
}
