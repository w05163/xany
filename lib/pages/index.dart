// 应用初始化页
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xany/models/baseModel.dart';
import 'package:xany/models/common.dart';

class InitPage extends StatelessWidget {
  CommonModel _common;
  BuildContext _context;

  void localInit(Value<CommonModel, bool> v) {
    if (v.value) {
      if (_common.login)
        Navigator.pushNamed(_context, '/home');
      else
        Navigator.pushNamed(_context, '/login');
    }
  }

  init(CommonModel common) {
    _common = common;
    common.onceDataChange<CommonModel, bool>(
        'localInit', (CommonModel com) => com.localInit, this.localInit);
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    final common = Provider.of<CommonModel>(context);
    this.init(common);
    return FloatingActionButton(
      onPressed: common.loginSuccess,
      tooltip: 'Increment Counter',
      child: const Icon(Icons.add),
    );
  }
}
