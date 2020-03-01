// 应用首页
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xany/models/home.dart';
import 'package:xany/widgets/weibo.dart';

class HomePage extends StatelessWidget {
  toDetail(BuildContext context, int index) {
    Navigator.pushNamed(context, '/weiboDetail', arguments: {'index': index});
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeModel>(
      builder: (context, HomeModel home, _) => Scaffold(
        appBar: null,
        body: Container(
          decoration: BoxDecoration(
            color: Color.fromRGBO(231, 231, 231, 1),
          ),
          child: ListView.builder(
            itemCount: home.weibos.length,
            itemBuilder: (context, index) {
              Map weibo = home.weibos[index];
              return InkWell(
                onTap: () => toDetail(context, index),
                child: Hero(tag: weibo['id'], child: Weibo(weibo)),
              );
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: home.getNextPage,
          tooltip: 'Increment Counter',
          child: const Icon(Icons.refresh),
        ),
      ),
    );
  }
}
