// 基础model
import 'package:flutter/material.dart';

class BaseModel with ChangeNotifier {
  bool _needNotify = false;

  setState(Function fun) {
    fun();
    if (_needNotify) return;
    _needNotify = true;
    Future.microtask(() {
      notifyListeners();
      _needNotify = false;
    });
  }
}
