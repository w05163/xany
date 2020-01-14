// 微博相关api的请求
// 由于微博api经过webview请求，所以需要先初始化

import 'package:webview_flutter/webview_flutter.dart';
import 'package:xany/utils/javascriptChannel.dart';

bool _init = false;
WebViewController _webViewController;
MyJavascriptChannel _javascriptChannel;

void _receivedApiMessage(data) {
  print('data' + data);
}

void initWeiboService(
    WebViewController controller, MyJavascriptChannel javascriptChannel) {
  if (_init) return;
  _webViewController = controller;
  _javascriptChannel = javascriptChannel;
  javascriptChannel.on('weiboApi', _receivedApiMessage);
  _init = true;
}
