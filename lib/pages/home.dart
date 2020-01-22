// 应用首页
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xany/models/common.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('About Route'),
        ),
        body: Consumer<CommonModel>(
          builder: (context, CommonModel common, _) => Center(
            child: Text('Value: ${common.login.toString()}'),
          ),
        ),
        floatingActionButton: Consumer<CommonModel>(
          builder: (c, CommonModel common, _) => FloatingActionButton(
            onPressed: common.loginSuccess,
            tooltip: 'Increment Counter',
            child: const Icon(Icons.add),
          ),
        ));
  }
}
