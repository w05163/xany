// 应用首页
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xany/models/home.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<HomeModel>(
        builder: (context, HomeModel home, _) => Scaffold(
            appBar: AppBar(
              title: const Text('About Route'),
            ),
            body: new ListView.builder(
              itemCount: home.weibos.length,
              itemBuilder: (context, index) {
                return new ListTile(
                  title: new Text('${home.weibos[index]}'),
                );
              },
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: home.getNextPage,
              tooltip: 'Increment Counter',
              child: const Icon(Icons.add),
            )));
  }
}
