// 与webview通信类
import 'dart:convert';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:xany/utils/eventEmitter.dart' show EventEmitter, RemoveListener;

class MyJavascriptChannel extends JavascriptChannel {
  MyJavascriptChannel({String name})
      : super(name: name, onMessageReceived: (JavascriptMessage msg) {}) {
    this.onMessageReceived = this._onMessageReceived;
  }

  final _eventEmitter = EventEmitter();

  JavascriptMessageHandler onMessageReceived;

  _onMessageReceived(JavascriptMessage msg) {
    print('接收到webview消息' + msg.message);
    Map msgData = json.decode(msg.message);
    // 触发事件
    _eventEmitter.emit(msgData['type'], msgData['data']);
  }

  RemoveListener on(String event, void Function(dynamic) handler) {
    return _eventEmitter.on(event, handler);
  }

  void onec(String event, void Function(dynamic) handler) {
    _eventEmitter.once(event, handler);
  }
}
