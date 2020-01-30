// 微博相关api的请求
// 由于微博api经过webview请求，所以需要先初始化
import 'dart:async';
import 'dart:convert';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:xany/utils/javascriptChannel.dart';

WebViewController _webViewController;
MyJavascriptChannel _javascriptChannel;

int _id = 100;
Map<int, Completer> _completerMap = {0: Completer()};

int getId() {
  return _id++;
}

void _receivedApiMessage(data) {
  final response = data['response'];
  final id = data['id'];
  final completer = _completerMap[id];
  if (completer == null) return;
  completer.complete(response);
  _completerMap.remove(id);
  print(json.encode(_completerMap));
}

Future _webviewFetch(String url, {options}) {
  final id = getId();
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
  _completerMap[id] = Completer();
  return _completerMap[id].future;
}

Future _coovCall(String name, {Map data}) async {
  await _completerMap[0].future; // 等待init成功
  final id = getId();
  if (data == null) data = {};
  _webViewController.evaluateJavascript('''
    window.coov.postData($id, window.coov.$name(${json.encode(data)}));
  ''');
  _completerMap[id] = Completer();
  return _completerMap[id].future;
}

void appendJS(String url) {
  _webViewController.evaluateJavascript('''
  var s = document.createElement('script');
  s.src = '$url';
  document.body.appendChild(s);
  ''');
}

Future initWeiboService(
    WebViewController controller, MyJavascriptChannel javascriptChannel) {
  _webViewController = controller;
  _javascriptChannel = javascriptChannel;
  javascriptChannel.on('weiboApi', _receivedApiMessage);
  appendJS('https://weibo-1252458005.cos.ap-guangzhou.myqcloud.com/weibo.js');
  return _completerMap[0].future;
}

void resetInit() {
  _completerMap[0] = Completer();
}

/// 获取微博
Future getWeibo({Map data}) {
  return _coovCall('getWeibos', data: data);
}
