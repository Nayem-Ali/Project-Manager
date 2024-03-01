import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:teamlead/services/proposal_sheets_api.dart';
import 'package:teamlead/services/result_sheet_api.dart';

// import 'package:teamlead/services/google_sheets_api.dart';
import 'View/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ProjectSheetApi.initialize();
  await ResultSheetApi.initialize();

  /// To interact with flutter engine
  await Firebase.initializeApp(
    name: "Project Manager",
    options: const FirebaseOptions(
      apiKey: "AIzaSyCLypnwO7g0n084BEWLOdhyNajNbOJxTRU",
      projectId: "project-manager-4cea3",
      messagingSenderId: "933388745290",
      appId: "1:933388745290:web:22a36345fe86cfefbb04b3",
      authDomain: "project-manager-4cea3.firebaseapp.com",
    ),
  );
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
        textTheme: GoogleFonts.aBeeZeeTextTheme(),
        // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        // useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
