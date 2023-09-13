import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:enerren/recource/string_id_id.dart';
import 'package:enerren/route.dart';
import 'package:enerren/util/api_end_point.dart';
import 'package:enerren/util/data.dart';
import 'package:enerren/util/enum.dart';
import 'package:enerren/util/mode_util.dart';
import 'package:enerren/util/system.dart';
import 'package:enerren/route.dart' as route;

void setting() {
  System.data.versionName = "1.3.53";
  System.data.route = route.route;
  System.data.apiEndPoint = ApiEndPoint();
  System.data.strings = StringsIdId();
  //change end point on dev mode
  if (System.data.versionName.split(".")[1] == "1") {
    System.data.apiEndPoint.baseUrl = "https://form.bagdja.com/api/";
    System.data.apiEndPoint.baseUrlDebug = "https://form.bagdja.com/api/";
  } else {
    if (System.data.versionName.split(" ").last == "Train") {
      System.data.apiEndPoint.baseUrl = "http://172.16.1.167/survey/api/";
      System.data.apiEndPoint.baseUrlDebug = "http://172.16.1.167/survey/api/";
    }
  }
  //setting permisson [haru didefinisikan juga pada manifest dan info.pls]
  System.data.permission = [
    Permission.accessNotificationPolicy,
    Permission.location,
    Permission.camera,
  ];
  //subscribe chanel
  System.data.deepLinkingHandler = (uri) {
    ModeUtil.debugPrint(uri?.path ?? "");
    if (ModalRoute.of(System.data.context)?.settings.name == initialRouteName) {
      return;
    }
    switch (uri?.path) {
      default:
        return;
    }
  };
  System.data.lastDatabaseVersion = 1;
  System.data.directories = {
    DirKey.collection: "collection",
    DirKey.inbox: "inbox",
    DirKey.process: "process",
    DirKey.upload: "upload",
    DirKey.images: "images",
  };
  System.data.files = {
    FileKey.collection: FileInit(
      dirKey: DirKey.collection,
      name: "collection.json",
      value: "[]",
    ),
  };
}
