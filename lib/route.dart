import 'package:flutter/material.dart';
import 'package:enerren/module/splash_screen/main.dart' as splash_screen;
import 'package:enerren/module/pending_data/main.dart' as pending_data;

String initialRouteName = RouteName.splashScreen;

class RouteName {
  static const String splashScreen = "splashScreen";
  static const String pendingData = "pendingData";
}

enum ParamName {
  user,
}

Map<String, WidgetBuilder> route = {
  RouteName.splashScreen: (BuildContext context) {
    return splash_screen.Presenter(
      onFinish: (){
        Navigator.pushNamedAndRemoveUntil(context, RouteName.pendingData, (x) => x.settings.name == "");
      },
    );
  },
  RouteName.pendingData: (BuildContext context) {
    return const pending_data.Presenter();
  },
};
