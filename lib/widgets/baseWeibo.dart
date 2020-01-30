// 应用首页
import 'package:flutter/material.dart';

class BaseWeibo extends StatelessWidget {
  Map data;

  BaseWeibo(this.data);

  Widget renderUser() {
    final user = data['user'];
    return Row(
      children: <Widget>[
        Text(
          '@' + user['screen_name'] + ':',
          style: TextStyle(color: Colors.blue),
          textAlign: TextAlign.left,
        )
      ],
    );
  }

  Widget renderText() {
    List text = data['text'];
    List<InlineSpan> inlineSpan = text.map((t) {
      switch (t['type']) {
        case 'text':
          return TextSpan(
            text: t['content'],
            style: TextStyle(color: Colors.black),
          );
          break;
        case 'br':
          return TextSpan(text: '');
          break;
        case 'emoji':
          return WidgetSpan(
              child: Image.network(
            t['url'],
            width: 16,
            height: 16,
            fit: BoxFit.cover,
          ));
          break;
        case 'tag':
          return TextSpan(
            text: t['content'],
            style: TextStyle(color: Colors.blue),
          );
          break;
        case 'user':
          return TextSpan(
            text: t['content'],
            style: TextStyle(color: Colors.blue),
          );
          break;
        case 'img':
          return TextSpan(
            text: '[评论图片]',
            style: TextStyle(color: Colors.blue),
          );
          break;
        case 'fullText':
          return TextSpan(
            text: t['content'],
            style: TextStyle(color: Colors.blue),
          );
          break;
        default:
      }
      return TextSpan(text: "");
    }).toList();

    return RichText(
      text: TextSpan(children: inlineSpan),
    );
  }

  renderContent() {
    final text = this.renderText();
    final children = <Widget>[text];
    if (data['pics'] != null) {
      List pics = data['pics'];
      List<List> rowPics = [];
      int l = pics.length % 3;
      for (int i = 0; i < l; i++) {
        int end = 3 * (i + 1);
        if (end >= pics.length)
          rowPics.add(pics.sublist(3 * i));
        else
          rowPics.add(pics.sublist(3 * i, end));
      }
      List<Widget> picRows = rowPics.map((row) {
        return Row(
          children: row
              .map(
                (pic) => Image.network(
                  pic['url'],
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              )
              .toList(),
        );
      }).toList();
      children.add(Column(children: picRows));
    } else if (data['page_info'] != null) {
      final info = data['page_info'];
      if (info['page_pic'] != null) {
        children.add(Image.network(
          info['page_pic']['url'],
          fit: BoxFit.cover,
        ));
      }
    }
    return Column(children: children);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: new BoxDecoration(
        color: Color.fromRGBO(238, 240, 244, 1),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[renderUser(), renderContent()],
      ),
    );
  }
}
