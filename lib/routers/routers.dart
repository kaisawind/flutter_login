import 'package:fluro/fluro.dart';
import 'package:login/routers/router_handler.dart';

class Routes {
  static String root = "/";
  static String home = "/home";
  static String login = '/login';
  static String resetPassword = '/password/reset';

  static void configureRoutes(FluroRouter router) {
    router.notFoundHandler = notFoundWidgetHandler;
    router.define(root, handler: loginPageHandler);
    router.define(home, handler: homePageHandler);
    router.define(login, handler: loginPageHandler);
    router.define(resetPassword, handler: resetPasswordHandler);
  }
}
