import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import '../views/login_page/login_page.dart';
import '../views/reset_password/reset_password.dart';
import '../widgets/404.dart';

/// 主页
var homePageHandler = new Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    return NotFoundWidget();
  },
);

/// 登录页面
var loginPageHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return LoginPage();
});

/// Not Found 页面
var notFoundWidgetHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return NotFoundWidget();
});

/// 重置密码 页面
var resetPasswordHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return ResetPassword();
    });
