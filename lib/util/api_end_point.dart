import 'package:enerren/util/mode_util.dart';

class ApiEndPoint {
  String baseUrl = "http://192.168.1.6/hris_suzuki_api/api/";
  String baseUrlDebug = "http://192.168.1.6/hris_suzuki_api/api/";
  String webSocketUrl = "";
  String webSocketUrlDebug = "";

  String get url {
    if (ModeUtil.debugMode == true) {
      return baseUrlDebug;
    } else {
      return baseUrl;
    }
  }

  String get wwebSocketUrl {
    if (ModeUtil.debugMode == true) {
      return webSocketUrlDebug;
    } else {
      return webSocketUrl;
    }
  }
}
