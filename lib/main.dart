import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:teamlead/services/proposal_sheets_api.dart';
import 'package:teamlead/services/result_sheet_api.dart';

// import 'package:teamlead/services/google_sheets_api.dart';
import 'View/splash_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ProjectSheetApi.initialize();
  await ResultSheetApi.initialize();

  /// To interact with flutter engine
  try{
    await Firebase.initializeApp(
      // name: "Project Manager",
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } on FirebaseException catch(e){
    print(e.message);
  }
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
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
  }
}
