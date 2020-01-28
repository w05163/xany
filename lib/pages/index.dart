// 应用初始化页
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:xany/utils/javascriptChannel.dart';
import 'package:xany/services/weibo.dart' as weibo;
import 'package:xany/models/baseModel.dart';
import 'package:xany/models/common.dart';

class InitPage extends StatefulWidget {
  @override
  _InitPageState createState() => _InitPageState();
}

class _InitPageState extends State<InitPage> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  final javascriptChannel = MyJavascriptChannel(name: 'coovjs');

  final icoUrl = 'https://m.weibo.cn/favicon.ico';
  final loginUrl = 'https://passport.weibo.cn/signin/login';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 监听本地初始化
    final common = Provider.of<CommonModel>(context);
    common.onceDataChange<CommonModel, bool>(
        'localInit', (CommonModel com) => com.localInit, this.localInit);
    common.onceDataChange<CommonModel, bool>(
        'login', (CommonModel com) => com.login, this.loginSuccess);
  }

  /// 本地初始化完成之后
  void localInit(Value<CommonModel, bool> v) {
    final common = Provider.of<CommonModel>(context, listen: false);
    if (common.login)
      Navigator.pushNamed(context, '/home');
    else
      _controller.future.then((c) => c.loadUrl(loginUrl));
  }

  ///登录完成
  void loginSuccess(Value<CommonModel, bool> v) {
    if (v.value) {
      Navigator.pushNamed(context, '/home');
      _controller.future.then((c) => c.loadUrl(icoUrl));
    }
  }

  bool isLoginSuccessUrl(url) {
    return url == 'https://m.weibo.cn/';
  }

  NavigationDecision navigationDelegate(NavigationRequest navigation) {
    final url = navigation.url;
    final common = Provider.of<CommonModel>(context, listen: false);
    if (this.isLoginSuccessUrl(url)) {
      common.loginSuccess();
      return NavigationDecision.prevent;
    }
    return NavigationDecision.navigate;
  }

  void onPageFinished(url) async {
    print('加载完成：$url');
  }

  @override
  Widget build(BuildContext context) {
    return WebView(
      debuggingEnabled: true,
      initialUrl: icoUrl,
      javascriptMode: JavascriptMode.unrestricted,
      javascriptChannels: <JavascriptChannel>[javascriptChannel].toSet(),
      onPageFinished: onPageFinished,
      onWebViewCreated: (WebViewController webViewController) {
        _controller.complete(webViewController);
        weibo.initWeiboService(webViewController, javascriptChannel);
      },
      navigationDelegate: navigationDelegate,
    );
  }
}
