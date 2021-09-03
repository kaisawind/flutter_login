import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import 'package:login/routers/routers.dart';
import 'package:login/routers/application.dart';
import 'package:login/utils/net_utils.dart';
import 'package:login/utils/style.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  _MyAppState() {
    super.initState();

    // init router
    final router = FluroRouter();
    Routes.configureRoutes(router);
    Application.router = router;
    // init net
    NetUtils.initNetUtils();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'title',
      onGenerateRoute: Application.router!.generator,
      theme: ThemeData(
        primarySwatch: AppColor.elGreen,
      ),
    );
  }
}
