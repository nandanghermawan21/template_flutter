import 'dart:async';
import 'dart:io';

import 'package:circular_loader/circular_loader.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:move_to_background/move_to_background.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:enerren/setting.dart';
import 'package:enerren/util/data.dart';
import 'package:enerren/util/mode_util.dart';
import 'package:enerren/util/system.dart';
import 'package:enerren/route.dart';
import 'package:uni_links/uni_links.dart';

Data data = Data();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initializeDateFormatting();
  HttpOverrides.global = MyHttpOverrides();
  setting();
  data.initialize().then((val) async {
    // initializeService().then((value) {
    runApp(const MyApp());
    // });
  });
}

Future<void> getPermission() async {
  for (var permition in System.data.permission) {
    await permition.request().then((value) {
      ModeUtil.debugPrint("${permition.toString()} grandted");
    }).catchError((onError) {
      ModeUtil.debugPrint(onError);
    });
  }
}

void onIosBackground() {
  WidgetsFlutterBinding.ensureInitialized();
  debugPrint('FLUTTER BACKGROUND FETCH');
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> with WidgetsBindingObserver {
  bool _initialUriIsHandled = false;

  @override
  void initState() {
    super.initState();
    if (!mounted) return;
    handleInitialDeepLink();
    handleDeeplink();
    getPermission().then((value) {});
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Stack(
        children: [
          ChangeNotifierProvider.value(
            value: System.data,
            child: Consumer<Data>(
              builder: (c, d, w) {
                return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  theme: data.themeData,
                  home: Scaffold(
                    backgroundColor: Colors.transparent,
                    body: CircularLoaderComponent(
                      controller: data.loadingController,
                      child: home(),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget home() {
    return WillPopScope(
      onWillPop: () {
        return Future.value(true);
        // return Future.value().then((value) {
        //   if (ModalRoute.of(System.data.navigatorKey.currentContext!)?.canPop ==
        //       true) {
        //     return true;
        //   } else {
        //     return false;
        //   }
        // });
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: System.data.strings!.appName,
        theme: data.themeData,
        routes: data.route ?? const <String, WidgetBuilder>{},
        initialRoute: initialRouteName,
        navigatorKey: System.data.navigatorKey,
      ),
    );
  }

  Future<void> handleInitialDeepLink() async {
    if (!_initialUriIsHandled) {
      _initialUriIsHandled = true;
      try {
        final uri = await getInitialUri();
        if (uri == null) {
          System.data.global.currentDeepLinkUri = uri;
        } else {
          System.data.global.currentDeepLinkUri = uri;
        }
        if (!mounted) return;
        if (System.data.deepLinkingHandler != null) {
          System.data.deepLinkingHandler!(uri);
        }
      } on PlatformException {
        ModeUtil.debugPrint('falied to get initial uri');
      } on FormatException catch (err) {
        if (!mounted) return;
        ModeUtil.debugPrint(err);
        System.data.global.currentDeepLinkUri = null;
      }
    }
  }

  void handleDeeplink() {
    if (!kIsWeb) {
      // It will handle app links while the app is already started - be it in
      // the foreground or in the background.
      uriLinkStream.listen(
        (uri) {
          if (!mounted) return;
          ModeUtil.debugPrint(uri?.path ?? "");
          System.data.global.currentDeepLinkUri = uri;
          if (System.data.deepLinkingHandler != null) {
            System.data.deepLinkingHandler!(uri);
          }
        },
        onError: (Object err) {
          if (!mounted) return;
        },
      );
    }
  }

  @override
  void dispose() {
    ModeUtil.debugPrint("APP Disposed");
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    ModeUtil.debugPrint("APP LifeCycle State");
    switch (state) {
      case AppLifecycleState.resumed:
        debugPrint("app state resumed");
        break;
      case AppLifecycleState.inactive:
        debugPrint("app state inactive");
        break;
      case AppLifecycleState.paused:
        debugPrint("app state paused");
        if (data.sendToBackGround == false) {
          data.sendToBackGround = true;
        } else {
          MoveToBackground.moveTaskToBack();
        }
        break;
      case AppLifecycleState.detached:
        debugPrint("app state detached");
        MoveToBackground.moveTaskToBack();
        break;
      case AppLifecycleState.hidden:
        debugPrint("not implement");
        break;
    }
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
