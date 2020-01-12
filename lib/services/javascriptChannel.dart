// 与webview通信类
import 'package:webview_flutter/webview_flutter.dart';
import 'package:xany/utils/eventEmitter.dart' show EventEmitter, RemoveListener;

class MyJavascriptChannel extends JavascriptChannel {
  final _eventEmitter = EventEmitter();

  MyJavascriptChannel({String name, JavascriptMessageHandler onMessageReceived})
      : super(name: name, onMessageReceived: onMessageReceived);

  RemoveListener on(String event, void Function(dynamic) handler) {
    return _eventEmitter.on(event, handler);
  }

  void onec(String event, void Function(dynamic) handler) {
    _eventEmitter.once(event, handler);
  }

  void emit(String event, [dynamic data]) {
    _eventEmitter.emit(event, data);
  }
}

final javascriptChannel = MyJavascriptChannel(
  name: 'Toaster',
  onMessageReceived: (JavascriptMessage msg) {
    print('接收到webview消息' + msg.message);
    // 触发事件
    javascriptChannel.emit('', '');
  },
);
