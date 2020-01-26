// 基础model
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:xany/services/local.dart';

class BaseModel with ChangeNotifier {
  bool _local = false;
  String _localKey;
  BaseModel({bool local, String localKey}) {
    print(localKey);
    print('localKey===');
    if (local != null && local) {
      _local = local;
      _localKey = localKey;
      this._initFromLocal();
    }
  }
  bool _needNotify = false;

  /**
   * 把需要存储到本地的数据转成map
   * 需由子类自己实现
   */
  Map<String, dynamic> getLocalJson() {}

  /**
   * 从本地存储的json中初始化值
   * 子类自己实现
   */
  void setFromLocal(Map<String, dynamic> map) {}

  /**
   * 从本地初始化值
   */
  void _initFromLocal() async {
    print('从本地初始化');
    String value = await Local.getString(_localKey);
    if (value == null) return;
    Map<String, dynamic> map = json.decode(value);
    this.setFromLocal(map);
    notifyListeners();
  }

  /**
   * 保存到本地
   */
  void _saveToLocal() {
    Map<String, dynamic> map = this.getLocalJson();
    String value = json.encode(map);
    Local.setString(_localKey, value);
  }

  setState(Function fun) {
    fun();
    if (_needNotify) return;
    _needNotify = true;
    Future.microtask(() {
      notifyListeners();
      _needNotify = false;
      if (_local) this._saveToLocal();
    });
  }
}
