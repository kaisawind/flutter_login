import 'package:dio/dio.dart';
import 'package:login/utils/interceptors.dart';

Map<String, dynamic> optHeader = {'accept-language': 'zh-cn'};

class NetUtils {
  static Dio dio = Dio(BaseOptions(connectTimeout: 30000, headers: optHeader));

  static AuthInterceptors interceptors = AuthInterceptors();

  static void initNetUtils() {
    // TLS认证取消
    // if (kIsWeb) {
    //   (dio.httpClientAdapter as BrowserHttpClientAdapter).withCredentials = false;
    // } else {
    //   (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (HttpClient client) {
    //     client.badCertificateCallback = (X509Certificate cert, String host, int port) {
    //       return true;
    //     };
    //   };
    // }
    dio.interceptors.add(interceptors);
  }

  static Future get(String url,
      {Map<String, dynamic>? params, Options? options}) async {
    Response response;
    if (params != null) {
      response = await dio.get(url, queryParameters: params);
    } else {
      response = await dio.get(url);
    }
    return response.data;
  }

  static Future post(String url,
      {Map<String, dynamic>? data,
      Map<String, dynamic>? queryParameters,
      Options? options}) async {
    var response = await dio.post(url,
        data: data, queryParameters: queryParameters, options: options);
    return response.data;
  }

  static Future patch(String url,
      {Map<String, dynamic>? data,
      Map<String, dynamic>? queryParameters,
      Options? options}) async {
    var response = await dio.patch(url,
        data: data, queryParameters: queryParameters, options: options);
    return response.data;
  }

  static Future delete(String url,
      {Map<String, dynamic>? params, Options? options}) async {
    Response response;
    if (params != null) {
      response = await dio.delete(url, queryParameters: params);
    } else {
      response = await dio.delete(url);
    }
    return response;
  }
}
