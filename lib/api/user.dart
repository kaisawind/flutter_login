import 'dart:async' show Future;
import 'dart:io';
import 'package:dio/dio.dart';
import '../utils/net_utils.dart';
import '../model/token.dart';
import '../model/user.dart';
import '../api/api.dart';

class UserAPI {
  // 用户登陆
  static Future<Token> login(String username, String password) async {
    if (username.isEmpty) {
      throw new FormatException('username is null');
    }
    if (password.isEmpty) {
      throw new FormatException('password is null');
    }
    var params = {
      "username": username,
      "password": password,
    };
    var contentType = ContentType.parse("application/x-www-form-urlencoded");
    var options = new Options(contentType: contentType);
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
