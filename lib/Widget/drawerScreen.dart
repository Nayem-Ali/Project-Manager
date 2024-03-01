import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:teamlead/services/auth_services.dart';
import 'package:teamlead/services/db_service.dart';

import 'about_us.dart';


class DrawerScreen extends StatefulWidget {
  const DrawerScreen({Key? key}) : super(key: key);

  @override
  State<DrawerScreen> createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  dynamic userData = {};
  DataBaseMethods dataBaseMethods = DataBaseMethods();
  FirebaseAuth auth = FirebaseAuth.instance;
  bool themeMode = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData() async {
    userData = await dataBaseMethods.getStudent();
    print(userData);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        margin: EdgeInsets.all(10),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Image.network(
              auth.currentUser!.photoURL!,
            ),
            const SizedBox(height: 10),
            Text(
              userData['name'] ?? "",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              "ID: ${userData['id']}",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              "Section: ${userData['section']}",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              "Batch: ${userData['batch']}",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            SwitchListTile(
                title: const Text("Dark Mode"),
                value: themeMode,
                onChanged: (value) {
                  setState(() {

                    themeMode = value;
                    if (themeMode) {
                      Get.changeTheme(ThemeData.dark());
                    }
                    else {
                      Get.changeTheme(ThemeData.light().copyWith(
                        colorScheme: ColorScheme.fromSeed(seedColor: Colors.cyan),
                        // primaryColor: Colors.deepOrangeAccent,
                        //fontFamily: "Poppins",
                        textTheme: GoogleFonts.aBeeZeeTextTheme(),
                        // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                        // useMaterial3: true,
                      ));
                    }
                  });

                }),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: logOutUser,
              style: OutlinedButton.styleFrom(
                  minimumSize: Size(Get.width, 50)
              ),
              label: const Text("Logout"),
              icon: const Icon(Icons.logout),
            ),
            const Spacer(),
            OutlinedButton.icon(
              onPressed: () {
                Get.to(const AboutUs());
              },
              style: OutlinedButton.styleFrom(
                  minimumSize: Size(Get.width, 50)
              ),
              label: const Text("About Us"),
              icon: const Icon(Icons.info),
            ),
          ],
        ),
      ),
    );
  }
}
// Row(
// children: [
// Container(
// height: 60,
// width: 60,
// decoration: BoxDecoration(
// border: Border.all(color: Colors.teal, width: 2),
// // borderRadius: BorderRadius.circular(50),
// ),
// child: Image.network(
// auth.currentUser!.photoURL!,
// width: 60,
// height: 60,
// fit: BoxFit.fill,
// ),
// ),
// Container(
// padding: const EdgeInsets.symmetric(horizontal: 5),
// child: Column(
// mainAxisAlignment: MainAxisAlignment.start,
// crossAxisAlignment: CrossAxisAlignment.start,
// children: [
// SizedBox(
// width: MediaQuery.of(context).size.width * 0.6,
// child: Text(
// "${auth.currentUser!.displayName}",
// overflow: TextOverflow.clip,
// softWrap: false,
// style: const TextStyle(
// fontWeight: FontWeight.bold,
// fontSize: 20,
// ),
// ),
// ),
// Text(
// formatTime(),
// style: const TextStyle(
// fontWeight: FontWeight.bold,
// fontSize: 16,
// ),
// )
// ],
// ),
// ),
// const Spacer(),
// const IconButton(
// onPressed: logOutUser,
// icon: Icon(Icons.logout),
// )
// ],
// ),
