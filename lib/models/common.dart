// 应用的公共数据
import 'baseModel.dart';

class CommonModel extends BaseModel {
  CommonModel() : super(local: true, localKey: 'commonModel') {}
  bool localInit = false;
  bool login = false;

  Map<String, dynamic> getLocalJson() {
    Map<String, dynamic> map = new Map();
    map['login'] = login;
    return map;
  }

  void setFromLocal(Map<String, dynamic> map) {
    login = map['login'];
    localInit = true;
  }

  void loginSuccess() {
    setState(() {
      login = !login;
    });
  }
}
