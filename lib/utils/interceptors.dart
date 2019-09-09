import 'package:dio/dio.dart';
import 'log_utils.dart';
import 'sp_utils.dart';

class LogsInterceptors extends InterceptorsWrapper {
  LogsInterceptors() : super() {
    LogUtil.init(isDebug: LogUtil.debuggable, tag: '###net_utils###');
    LogUtil.e('LogsInterceptors construct');
  }
  @override
  onRequest(RequestOptions options) async {
    super.onRequest(options);
    SpUtil sp = await SpUtil.getInstance();
    String auth = sp.getString(SpKeys.token);
    options.headers['authorization'] = auth;
    LogUtil.v('onRequest headers：${options.headers.toString()}');
    LogUtil.e('onRequest path：${options.path}');
    if (options.data != null) {
      LogUtil.v('onRequest data：${options.data.toString()}');
    }
    if (options.queryParameters != null) {
      LogUtil.v('onRequest queryParameters：${options.queryParameters.toString()}');
    }
    return options;
  }

  @override
  onResponse(Response response) {
    // super.onResponse(response);
    LogUtil.e('onResponse redirects：${response.redirects.toString()}');
    LogUtil.e('onResponse statusCode：${response.statusCode.toString()}');
    LogUtil.e('onResponse statusMessage：${response.statusMessage.toString()}');
    return response; // continue
  }

  @override
  onError(DioError err) {
    super.onError(err);
    LogUtil.e('onError err：${err.toString()}');
    return err;
  }
}
