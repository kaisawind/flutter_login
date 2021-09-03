import 'dart:async' show Future;
import 'package:dio/dio.dart';
import 'package:login/utils/net_utils.dart';
import 'package:login/model/token.dart';
import 'package:login/model/user.dart';
import 'package:login/api/api.dart';

class UserAPI {
  // 用户登陆
  static Future<Token> login(String username, String password) async {
    if (username.isEmpty) {
      throw const FormatException('username is null');
    }
    if (password.isEmpty) {
      throw const FormatException('password is null');
    }
    var params = {
      "username": username,
      "password": password,
    };
    var options = new Options(contentType: Headers.formUrlEncodedContentType);
    var response = await NetUtils.post(Api.LOGIN, data: params, options: options);
    Token token = Token.fromJson(response);
    return token;
  }

  // 获取当前登陆用户信息
  static Future<User> getUserInfo() async {
    var response = await NetUtils.get(Api.GETUSERINFO);
    User token = User.fromJson(response);
    return token;
  }
}
