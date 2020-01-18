// 微博相关api的请求
// 由于微博api经过webview请求，所以需要先初始化
import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:xany/utils/javascriptChannel.dart';

bool _init = false;
WebViewController _webViewController;
MyJavascriptChannel _javascriptChannel;

Map<int, Completer> completerMap = Map();

void _receivedApiMessage(data) {
  final response = data['response'];
  final id = data['id'];
  final completer = completerMap[id];
  if (completer == null) return;
  completer.complete(response);
  completerMap.remove(id);
  print(json.encode(completerMap));
}

Future _webviewFetch(String url, {options}) {
  final id = Random().nextInt(10 ^ 16);
  if (options == null) options = {};
  _webViewController.evaluateJavascript('''
    fetch('$url',${json.encode(options)})
    .then(function(res){ return res.json();})
    .then(function(data){
      ${_javascriptChannel.name}.postMessage(JSON.stringify({
        type:'weiboApi',
        data: { response: data, id: $id}
      }))
    });
  ''');
  completerMap[id] = Completer();
  return completerMap[id].future;
}

void initWeiboService(
    WebViewController controller, MyJavascriptChannel javascriptChannel) {
  if (_init) return;
  _webViewController = controller;
  _javascriptChannel = javascriptChannel;
  javascriptChannel.on('weiboApi', _receivedApiMessage);
  _init = true;
}

/// 获取微博
Future getWeibo() {
  return _webviewFetch('/feed/friends');
}
