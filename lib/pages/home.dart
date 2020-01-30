// 应用首页
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xany/models/home.dart';
import 'package:xany/widgets/weibo.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<HomeModel>(
        builder: (context, HomeModel home, _) => Scaffold(
            appBar: null,
            body: new ListView.builder(
              itemCount: home.weibos.length,
              itemBuilder: (context, index) {
                return Weibo(home.weibos[index]);
              },
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: home.getNextPage,
              tooltip: 'Increment Counter',
              child: const Icon(Icons.refresh),
            )));
  }
}
