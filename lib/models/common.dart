// 应用的公共数据
import 'baseModel.dart';

class CommonModel extends BaseModel {
  bool login = false;

  void loginSuccess() {
    setState(() {
      login = !login;
    });
  }
}
