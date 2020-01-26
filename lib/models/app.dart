// model注册
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'common.dart';
import 'home.dart';

MultiProvider registerModels(Widget child) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider<CommonModel>(
          create: (_) => CommonModel(), lazy: false),
      ChangeNotifierProvider<HomeModel>(
          create: (_) => HomeModel(), lazy: false),
    ],
    child: child,
  );
}
