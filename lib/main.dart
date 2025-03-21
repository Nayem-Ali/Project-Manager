import 'dart:isolate';

import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:teamlead/services/proposal_sheets_api.dart';
import 'package:teamlead/services/push_notification.dart';
import 'package:teamlead/services/result_sheet_api.dart';
import 'package:teamlead/v2/core/app/app.dart';
import 'package:teamlead/v2/core/dl/dependency_injection.dart';

// import 'package:teamlead/services/google_sheets_api.dart';
import 'View/splash_screen.dart';
import 'firebase_options.dart';

// callApi(int val) async{
//   await ProjectSheetApi.initialize();
//   await ResultSheetApi.initialize();
// }
//
Future<void> initializeCriticalServices() async {
  await Future.wait([
    ProjectSheetApi.initialize(),
    Firebase.initializeApp(
      name: "Project Manager",
      options: DefaultFirebaseOptions.currentPlatform,
    ),
  ]);
}

Future<void> initializeNonCriticalServices() async {
  await ResultSheetApi.initialize();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  /// v2 starting point
  await SetupServices().dependencies();
  runApp(const App());

  /// v1 staring point [just uncomment next 3 line to run v1 ]
  // await initializeCriticalServices();
  // initializeNonCriticalServices();
  //
  // runApp(const MyApp());
}

// void main() async {
//   DateTime start = DateTime.now();
//   print(start.second);
//   WidgetsFlutterBinding.ensureInitialized();
//
//   await ProjectSheetApi.initialize();
//   await ResultSheetApi.initialize();
//   // await Isolate.run(() => callApi());
//   // await compute(callApi, 10);
//   /// To interact with flutter engine
//
//   await Firebase.initializeApp(
//     name: "Project Manager",
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//
//   await PushNotifications.sendNotification();
//   print(DateTime.now().difference(start).inSeconds);
//   runApp(
//       const MyApp()
//     // DevicePreview(
//     //   enabled: !kReleaseMode,
//     //   builder: (context) => const MyApp(), // Wrap your app
//     // ),
//   );
// }

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return GetMaterialApp(
          // useInheritedMediaQuery: true,
          // locale: DevicePreview.locale(context),
          // builder: DevicePreview.appBuilder,
          home: const SplashScreen(),
          theme: ThemeData.light(useMaterial3: false).copyWith(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.cyan),
            textTheme: GoogleFonts.adaminaTextTheme(),
          ),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
