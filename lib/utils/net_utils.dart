import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import './interceptors.dart';

Map<String, dynamic> optHeader = {'accept-language': 'zh-cn', 'Content-Type': 'application/json'};

var dio = new Dio(BaseOptions(connectTimeout: 30000, headers: optHeader));

class NetUtils {
  static LogsInterceptors interceptors = new LogsInterceptors();
  static Future get(String url, [Map<String, dynamic> params, Options options]) async {
    var response;
    // TLS认证取消
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = _onHttpClientCreate;

    dio.interceptors.add(interceptors);
    if (params != null) {
      response = await dio.get(url, queryParameters: params);
    } else {
      response = await dio.get(url);
    }
    return response.data;
  }

  static Future post(String url, {Map<String, dynamic> data, Map<String, dynamic> queryParameters, Options options}) async {
    // TLS认证取消
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = _onHttpClientCreate;
    // Token赋值
    dio.interceptors.add(new LogsInterceptors());

    var response = await dio.post(url, data: data, queryParameters: queryParameters, options: options);
    return response.data;
  }

  static Future patch(String url, {Map<String, dynamic> data, Map<String, dynamic> queryParameters, Options options}) async {
    // TLS认证取消
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = _onHttpClientCreate;
    // Token赋值
    dio.interceptors.add(interceptors);

    var response = await dio.patch(url, data: data, queryParameters: queryParameters, options: options);
    return response.data;
  }

  static dynamic _onHttpClientCreate(HttpClient client) {
    client.badCertificateCallback = (X509Certificate cert, String host, int port) {
      return true;
    };
  }
}
