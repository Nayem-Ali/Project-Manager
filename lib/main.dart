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

// import 'package:teamlead/services/google_sheets_api.dart';
import 'View/splash_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ProjectSheetApi.initialize();
  await ResultSheetApi.initialize();

  /// To interact with flutter engine

  await Firebase.initializeApp(
    name: "Project Manager",
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await PushNotifications.sendNotification();
  runApp(
      const MyApp()
    // DevicePreview(
    //   enabled: !kReleaseMode,
    //   builder: (context) => const MyApp(), // Wrap your app
    // ),
  );
}

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
            // primaryColor: Colors.deepOrangeAccent,
            //fontFamily: "Poppins",
            textTheme: GoogleFonts.adaminaTextTheme(),
            // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            // useMaterial3: true,
          ),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
