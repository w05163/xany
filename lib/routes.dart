// 路由定义
import 'package:flutter/material.dart';
import 'pages/home.dart';
import 'pages/login.dart';

final routes = <String, WidgetBuilder>{
  '/': (BuildContext context) => LoginPage(),
  '/home': (BuildContext context) => HomePage(),
};
