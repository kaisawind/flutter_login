class Api {
  static const String BASE_URL = 'https://192.168.1.118:30443/kaisawind/api/v1';

  /// oauth 权限认证
  static const String TOKEN = BASE_URL + '/oauth/token'; //权限认证

  // user 用户管理
  static const String LOGIN = BASE_URL + '/login'; //用户登陆
  static const String GETUSERINFO = BASE_URL + '/user';
}
