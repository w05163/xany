// 路由定义
import 'package:flutter/material.dart';
import 'pages/home.dart';

final routes = <String, WidgetBuilder>{
  '/': (BuildContext context) => MyHomePage(),
  '/about': (BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Route'),
      ),
    );
  }
};
