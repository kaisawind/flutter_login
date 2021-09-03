import 'package:flutter/material.dart';
import 'package:login/utils/style.dart';
import 'package:login/api/user.dart';
import 'package:login/resources/sp_keys.dart';
import 'package:login/routers/routers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

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
  Color _eyeColor = Colors.grey;
  late SharedPreferences sp;
  final List _loginMethod = [
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

  @override
  void initState() {
    super.initState();
    initSp();
  }

  initSp() async {
    // 获取存储句柄
    sp = await SharedPreferences.getInstance();
    bool remember = sp.getBool(SpKeys.isRememberPassword) ?? false;
    if (remember) {
      String username = sp.getString(SpKeys.name) ?? '';
      String password = sp.getString(SpKeys.password) ?? '';
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
              padding: const EdgeInsets.symmetric(horizontal: 22.0),
              children: <Widget>[
                const SizedBox(
                  height: kToolbarHeight,
                ),
//                buildIcon(),
                buildTitle(),
                // buildTitleLine(),
                const SizedBox(height: 70.0),
                // buildEmailTextField(),
                buildUsernameTextField(),
                const SizedBox(height: 30.0),
                buildPasswordTextField(context),
                buildForgetPasswordText(context),
                const SizedBox(height: 60.0),
                buildLoginButton(context),
                const SizedBox(height: 30.0),
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
        padding: const EdgeInsets.only(top: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('没有账号？'),
            GestureDetector(
              child: const Text(
                '点击注册',
                style: TextStyle(color: Colors.green),
              ),
              onTap: () {
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
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
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
    return const Align(
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
        child: ElevatedButton(
          child: Text(
            '登录',
            style: Theme.of(context).primaryTextTheme.headline5,
          ),
          onPressed: () async {
            if (_formKey.currentState != null && _formKey.currentState!.validate()) {
              ///只有输入的内容符合要求通过才会到达此处
              _formKey.currentState!.save();
              try {
                var value = await UserAPI.login(_username, _password);
                sp.setString(SpKeys.token, value.tokenType + " " + value.accessToken);
                var user = await UserAPI.getUserInfo();
                sp.setStringList(SpKeys.roles, user.roles);
                sp.setString(SpKeys.name, user.name);
                sp.setString(SpKeys.id, user.id);
                sp.setBool(SpKeys.isRememberPassword, _isRememberPassword);
                if (_isRememberPassword) {
                  sp.setString(SpKeys.password, _password);
                } else {
                  sp.setString(SpKeys.password, '');
                }
                Navigator.of(context).pushNamedAndRemoveUntil(Routes.home, (route) => false);
              } catch (e) {
                sp.setBool(SpKeys.isRememberPassword, _isRememberPassword);
                sp.setString(SpKeys.name, _username);
                if (_isRememberPassword) {
                  sp.setString(SpKeys.password, _password);
                } else {
                  sp.setString(SpKeys.password, '');
                }
                _showDialog();
              }
            }
          },
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
                  onChanged: (bool? value) {
                    setState(() {
                      _isRememberPassword = value ?? false;
                    });
                  },
                ),
                const Text(
                  '记住密码',
                  style: TextStyle(fontSize: 14.0, color: Colors.grey),
                ),
              ],
            ),
            TextButton(
              child: const Text(
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
      onSaved: (String? value) => _password = value ?? '',
      obscureText: _isObscure,
      validator: (String? value) {
        if (value!.isEmpty) {
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
                  _eyeColor = _isObscure ? Colors.grey : Colors.green;
                });
              })),
    );
  }

  TextFormField buildUsernameTextField() {
    return TextFormField(
      controller: _uController,
      decoration: const InputDecoration(
        labelText: '用户名',
      ),
      validator: (String? value) {
        if (value!.isEmpty) {
          return '请输入用户名';
        }
        return null;
      },
      onSaved: (String? value) => _username = value ?? '',
    );
  }

  Padding buildTitleLine() {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0, top: 4.0),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Container(
          color: const Color(AppColor.gridGreen),
          width: 40.0,
          height: 2.0,
        ),
      ),
    );
  }

  Padding buildTitle() {
    return const Padding(
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
        return AlertDialog(
          title: const Text('用户名密码错误'),
          actions: <Widget>[
            TextButton(
              child: const Text('确定'),
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
