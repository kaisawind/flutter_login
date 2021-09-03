import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:login/views/login_page/login_page.dart';
import 'package:login/views/reset_password/reset_password.dart';
import 'package:login/widgets/404.dart';

/// 主页
var homePageHandler = Handler(
  handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
    return NotFoundWidget();
  },
);

/// 登录页面
var loginPageHandler = Handler(handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
  return const LoginPage();
});

/// Not Found 页面
var notFoundWidgetHandler = Handler(handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
  return NotFoundWidget();
});

/// 重置密码 页面
var resetPasswordHandler = Handler(handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
  return ResetPassword();
});
