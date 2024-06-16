import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class NoticeView extends StatelessWidget {
  NoticeView({Key? key}) : super(key: key);
  Map<String, dynamic> notification = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Announcement"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                notification['subject'],
                style: textStyle(16),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10.h),
              Text(
                notification['body'],
                style: textStyle(13),
                textAlign: TextAlign.justify,
              ),
              if(notification['link'] != "")
              InkWell(
                onTap: () async {
                  Uri url = Uri.parse(notification['link']);
                  if (!await launchUrl(url)) {
                    Get.showSnackbar(
                      const GetSnackBar(
                        message: "Link is broken or something went wrong",
                        duration: Duration(seconds: 3),
                        backgroundColor: Colors.redAccent,
                      ),
                    );
                  } else {

                  }
                },
                child: Text(
                  notification['link'],
                  style: GoogleFonts.adamina(fontSize: 13.h, color: Colors.indigoAccent),
                  textAlign: TextAlign.justify,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

textStyle(double fontSize) => GoogleFonts.adamina(fontSize: fontSize.h);
