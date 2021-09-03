import 'package:dio/dio.dart';
import 'package:login/resources/sp_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthInterceptors extends InterceptorsWrapper {
  AuthInterceptors();
  @override
  onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String auth = sp.getString(SpKeys.token) ?? '';
    options.headers['authorization'] = auth;
    super.onRequest(options, handler);
  }
}
