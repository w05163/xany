// 基础model
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:xany/services/local.dart';
import 'package:xany/utils/eventEmitter.dart';

typedef void DataChangeHandler<T, V>(Value<T, V> v);
typedef V GetValueFunction<T, V>(T target);

class Value<T, V> {
  T target;
  V _value;
  V _oldValue;
  GetValueFunction<T, V> getValue;

  Value(this.target, this.getValue) {
    this.update();
  }

  void update() {
    _oldValue = _value;
    _value = getValue(target);
  }

  ///当前值
  V get value => _value;

  ///上次的值
  V get oldValue => _oldValue;

  bool equal(val) {
    return val == _value;
  }

  bool isChanged() {
    return !this.equal(getValue(target));
  }
}

class BaseModel with ChangeNotifier {
  bool _local = false;
  bool localInit = false;
  String _localKey;

  EventEmitter _emitter = EventEmitter();
  Map<String, Value> valueMap = Map();

  BaseModel({bool local, String localKey}) {
    if (local != null && local) {
      _local = local;
      _localKey = localKey;
      this._initFromLocal();
    }
    Future.microtask(() => this.addListener(this._dataChange));
  }
  bool _needNotify = false;

  ///把需要存储到本地的数据转成map，需由子类自己实现
  Map<String, dynamic> getLocalJson() {}

  /// 从本地存储的json中初始化值，子类自己实现
  void setFromLocal(Map<String, dynamic> map) {}

  /// 从本地初始化值
  void _initFromLocal() async {
    String value = await Local.getString(_localKey);
    if (value != null) {
      Map<String, dynamic> map = json.decode(value);
      this.setFromLocal(map);
    }
    localInit = true;
    notifyListeners();
  }

  /// 保存到本地
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

  _dataChange() {
    valueMap.forEach((key, v) {
      if (v.isChanged()) {
        v.update();
        _emitter.emit(key, v);
      }
    });
  }

  /// 监听某个数据变更
  RemoveListener onDataChange<M extends BaseModel, V>(String key,
      GetValueFunction<M, V> getValue, DataChangeHandler<M, V> listener) {
    valueMap[key] = Value<M, V>(this, getValue);
    return _emitter.on<Value<M, V>>(key, listener);
  }

  RemoveListener onceDataChange<M extends BaseModel, V>(String key,
      GetValueFunction<M, V> getValue, DataChangeHandler<M, V> listener) {
    valueMap[key] = Value<M, V>(this, getValue);
    return _emitter.once<Value<M, V>>(key, listener);
  }
}
