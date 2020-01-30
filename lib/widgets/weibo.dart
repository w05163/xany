// 应用首页
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xany/models/home.dart';
import 'package:xany/widgets/baseWeibo.dart';

class Weibo extends BaseWeibo {
  Weibo(data) : super(data);

  Widget renderUser() {
    final user = data['user'];
    return Row(
      children: <Widget>[
        ClipOval(
            child: Image.network(
          user['avatar_hd'],
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        )),
        Text(user['screen_name'])
      ],
    );
  }

  Widget renderContent() {
    final children = <Widget>[super.renderContent()];
    if (data['retweeted_status'] != null)
      children.add(BaseWeibo(data['retweeted_status']));
    return Column(mainAxisSize: MainAxisSize.min, children: children);
  }

  Widget renderFooter() {
    return ButtonBar(
      children: <Widget>[
        FlatButton(
          child: Text('转发' + data['reposts_count'].toString()),
          onPressed: () {/* ... */},
        ),
        FlatButton(
          child: Text('评论' + data['comments_count'].toString()),
          onPressed: () {/* ... */},
        ),
        FlatButton(
          child: Text('点赞' + data['attitudes_count'].toString()),
          onPressed: () {/* ... */},
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[renderUser(), renderContent(), renderFooter()]),
    );
  }
}
