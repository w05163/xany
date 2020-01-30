// 微博主页model
import 'baseModel.dart';
import 'package:xany/services/weibo.dart' as weibo;

class HomeModel extends BaseModel {
  List weibos = [];

  void getNextPage() async {
    final data = await weibo.getWeibo();
    // print(data);
    //获取微博
    setState(() {
      weibos.addAll(data['data']['statuses']);
    });
  }
}
