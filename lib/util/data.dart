import 'dart:async';
import 'dart:io';

import 'package:circular_loader/circular_loader.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:enerren/util/api_end_point.dart';
import 'package:enerren/util/colour.dart';
import 'package:enerren/util/databases.dart';
import 'package:enerren/util/font.dart';
import 'package:enerren/util/strings.dart';
import 'package:enerren/util/mode_util.dart';
import 'package:enerren/util/text_style.dart';
import 'package:device_info_plus/device_info_plus.dart';

import 'global.dart';

class Data extends ChangeNotifier {
  String versionName = "";
  int versionCode = 0;
  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  CircularLoaderController loadingController = CircularLoaderController();
  bool sendToBackGround = true;

  AndroidDeviceInfo? androidInfo;
  IosDeviceInfo? iosInfo;

  Map<String, WidgetBuilder>? route;
  bool resizeToAvoidBottomInset = false;

  VoidCallback? onUnAuthorized;
  BuildContext get context => navigatorKey.currentContext!;
  ApiEndPoint apiEndPoint = ApiEndPoint();
  Global global = Global();
  Strings? strings;
  Colour? color;
  Font? font;
  TextStyles? textStyles = TextStyles();
  List<Permission> permission = [];
  ValueChanged<Uri?>? deepLinkingHandler;
  SharedPreferences? session;
  Databases? database;
  Function(Database?, int)? onCreateDb;
  ValueChanged<Map<String, dynamic>?>? onServiceDataReceived;
  Directory? appDirectory;
  Map<String, String> directories = {};
  Map<String, FileInit> files = {};
  DeviceInfo? deviceInfo;
  ThemeData? themeData = ThemeData();
  int lastDatabaseVersion = 0;

  Data();

  Future<void> initialize() async {
    await _initSharedPreference();
    await _initDatabse();
    await _initDeviceInfo();
    appDirectory = await getApplicationDocumentsDirectory();
    deviceInfo = await initDeviceInfo();
    initDirectories();
    iniFiles();
  }

  void commit() {
    notifyListeners();
  }

  Future<bool> _initSharedPreference() async {
    session = await SharedPreferences.getInstance();
    return true;
  }

  Future<bool> _initDeviceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      androidInfo = await deviceInfo.androidInfo;
    } else if (Platform.isIOS) {
      iosInfo = await deviceInfo.iosInfo;
    }
    return true;
  }

  Future<bool> _initDatabse() async {
    database = await Databases().initializeDb(
      onCreate: (db, version) {
        ModeUtil.debugPrint("Database information :");
        ModeUtil.debugPrint("path                 : ${db?.path}");
        ModeUtil.debugPrint("version              : $version");
        if (onCreateDb != null) {
          onCreateDb!(db, version);
        }
      },
    );
    return true;
  }

  Future<bool> reInitDatabase() async {
    database = await Databases().initializeDb(
      deleteOldDb: true,
      onCreate: (db, version) {
        ModeUtil.debugPrint("Reinit Database information :");
        ModeUtil.debugPrint("path                 : ${db?.path}");
        ModeUtil.debugPrint("version              : $version");
        if (onCreateDb != null) {
          onCreateDb!(db, version);
        }
      },
    );
    return true;
  }

  void initDirectories() {
    for (var dir in directories.values) {
      Directory filePath = Directory('${appDirectory?.path}/$dir');

      if (!filePath.existsSync()) {
        filePath.createSync(recursive: true);
      }
    }
  }

  Directory getDir(String dirKey) {
    return Directory(
        (appDirectory?.path ?? "") + "/" + (directories[dirKey] ?? ""));
  }

  void iniFiles() {
    for (var file in files.values) {
      File filePath = File(getDir(file.dirKey).path + "/" + file.name);

      if (!filePath.existsSync()) {
        filePath.createSync(recursive: true);
        filePath.writeAsStringSync(file.value);
      }
    }
  }

  File? getFile(String fileKey) {
    FileInit? _file = files[fileKey];

    if (_file == null) return null;

    return File(getDir(_file.dirKey).path + "/" + _file.name);
  }

  Future<DeviceInfo> initDeviceInfo() {
    return Future.value().then((value) {
      return DeviceInfo(
        imei: value,
        deviceId:
            Platform.isAndroid ? androidInfo?.id : iosInfo?.identifierForVendor,
        deviceModel: Platform.isAndroid
            ? ("${androidInfo?.model} ${androidInfo?.device}").toUpperCase()
            : iosInfo?.model,
      );
    });

    // return DeviceInfo(
    //   imei: await UniqueIdentifier.serial,
    //   deviceId:
    //       Platform.isAndroid ? androidInfo?.id : iosInfo?.identifierForVendor,
    //   deviceModel: Platform.isAndroid
    //       ? ("${androidInfo?.model} ${androidInfo?.device}").toUpperCase()
    //       : iosInfo?.model,
    // );
  }
}

class FileInit {
  String dirKey;
  String name;
  String value;

  FileInit({
    required this.dirKey,
    required this.name,
    required this.value,
  });
}

class DeviceInfo {
  String? imei;
  String? deviceId;
  String? deviceModel;

  DeviceInfo({
    this.imei,
    this.deviceId,
    this.deviceModel,
  });
}
