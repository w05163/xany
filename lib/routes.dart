// 路由定义
import 'package:flutter/material.dart';
import 'pages/home.dart';
import 'pages/login.dart';
import 'pages/index.dart';
import 'pages/weiboDetail.dart';

final routes = <String, WidgetBuilder>{
  '/': (BuildContext context) => InitPage(),
  '/login': (BuildContext context) => LoginPage(),
  '/home': (BuildContext context) => HomePage(),
  '/weiboDetail': (BuildContext context) => WeiboDetail(),
};
