// 应用首页
// 处理微博登录初始化等工作
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:xany/utils/javascriptChannel.dart';
import 'package:xany/services/weibo.dart' as weibo;

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  final javascriptChannel = MyJavascriptChannel(name: 'coovjs');
  WebViewController webviewController;

  final icoUrl = 'https://m.weibo.cn/favicon.ico';

  void loadIco() async {
    Navigator.pushNamed(context, '/home');
    await Future.delayed(Duration(milliseconds: 10));
    webviewController.loadUrl(icoUrl);
  }

  void onPageFinished(url) async {
    print(url);
  }

  NavigationDecision navigationDelegate(NavigationRequest navigation) {
    final url = navigation.url;
    if (url.indexOf('favicon.ico') == -1) {
      loadIco();
      return NavigationDecision.prevent;
    }
    return NavigationDecision.navigate;
  }

  @override
  Widget build(BuildContext context) {
    return WebView(
      debuggingEnabled: true,
      initialUrl: 'https://passport.weibo.cn/signin/login',
      javascriptMode: JavascriptMode.unrestricted,
      javascriptChannels: <JavascriptChannel>[javascriptChannel].toSet(),
      onPageFinished: onPageFinished,
      onWebViewCreated: (WebViewController webViewController) {
        _controller.complete(webViewController);
        webviewController = webViewController;
        weibo.initWeiboService(webViewController, javascriptChannel);
      },
      navigationDelegate: navigationDelegate,
    );
  }
}
