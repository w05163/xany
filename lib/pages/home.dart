// 应用首页
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:xany/services/javascriptChannel.dart';
import 'package:xany/services/weibo.dart' as weibo;

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return WebView(
      debuggingEnabled: true,
      initialUrl: 'https://passport.weibo.cn/signin/login',
      javascriptMode: JavascriptMode.unrestricted,
      javascriptChannels: <JavascriptChannel>[javascriptChannel].toSet(),
      onPageFinished: (url) {
        _controller.future.then(weibo.initWeiboService);
      },
      onWebViewCreated: (WebViewController webViewController) {
        _controller.complete(webViewController);
      },
    );
  }
}
