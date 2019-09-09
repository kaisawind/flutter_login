import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import 'routers/routers.dart';
import 'routers/application.dart';
import 'utils/style.dart';
import 'utils/log_utils.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  _MyAppState() {
    final router = new Router();
    Routes.configureRoutes(router);
    Application.router = router;
    LogUtil.init(isDebug: true, tag: "###login###");
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'title',
      theme: ThemeData(
        primaryColor: AppColor.colorGreen,
        buttonColor: AppColor.colorGreen,
      ),
      onGenerateRoute: Application.router.generator,
    );
  }
}
