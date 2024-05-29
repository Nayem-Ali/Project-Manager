import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({Key? key}) : super(key: key);

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("About"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Divider(),
              const Text(
                "Project Manager",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const Divider(),
              const Text(
                "Version: 1.0.0",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Project Manager is used for managing task related with project management. Here"
                  " student can submit project proposal and request for team forming if unable"
                  " to make team for project or thesis. Teacher can assign supervisor to each "
                  "team and evaluate project throughout this app. ",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.justify,
                ),
              ),
              const Divider(),
              const Text(
                "Instructed by",
                style: TextStyle(color: Colors.teal, fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const Divider(),
              const CircleAvatar(
                radius: 90,
                backgroundImage: AssetImage("images/srk.jpg"),
              ),

              const Text(
                "MD. Saidur Rahman Kohinoor",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Text(
                "Lecturer & Advisor IEEE CS LU SBC",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              const Text(
                "Department of CSE",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              Center(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () async {
                        final Uri url = Uri.parse(
                            'https://www.facebook.com/Kohinoor11?mibextid=YMEMSu'); // or add your URL here
                        if (!await launchUrl(url)) {
                        } else {
                          throw 'Could not launch $url';
                        }
                      },
                      icon: const Icon(
                        FontAwesomeIcons.facebook,
                        color: Colors.blue,
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        final Uri url = Uri.parse(
                            'https://www.linkedin.com/search/results/all/?keywords=Sairdur%20Rahman%20Kohinoor&origin=GLOBAL_SEARCH_HEADER&sid=gce'); // or add your URL here
                        if (!await launchUrl(url)) {
                        } else {
                          throw 'Could not launch $url';
                        }
                      },
                      icon: const Icon(
                        FontAwesomeIcons.linkedin,
                        color: Colors.blueAccent,
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        final Email emails = Email(
                          body: 'Email body',
                          subject: 'Email subject',
                          recipients: ["kohinoor_cse@lus.ac.bd"],
                          // bcc: ['bcc@example.com'],
                          // attachmentPaths: ['/path/to/attachment.zip'],
                          isHTML: false,
                        );

                        await FlutterEmailSender.send(emails);
                      },
                      icon: const Icon(
                        Icons.email,
                        color: Colors.redAccent,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(),
              const Text(
                "Developers",
                style: TextStyle(color: Colors.teal, fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const Divider(),
              // Container(
              //   height: 160,
              //   width: 160,
              //   decoration: BoxDecoration(
              //     border: Border.all(color: Colors.teal, width: 2),
              //     // borderRadius: BorderRadius.circular(50),
              //   ),
              //   child: const Image(
              //       image: , width: 50, height: 50, fit: BoxFit.fill),
              // ),
              const CircleAvatar(
                backgroundImage: AssetImage("images/nayem.jpg"),
                radius: 90,
              ),
              const Text(
                "Nayem Ali",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Text(
                "ID: 2012020023",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              const Text(
                "CSE 53 batch",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              Center(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () async {
                        final Uri url = Uri.parse(
                            'https://www.facebook.com/clavicle.bones?mibextid=9R9pXO'); // or add your URL here
                        if (!await launchUrl(url)) {
                        } else {
                          throw 'Could not launch $url';
                        }
                      },
                      icon: const Icon(
                        FontAwesomeIcons.facebook,
                        color: Colors.blue,
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        final Uri url = Uri.parse(
                            'https://www.linkedin.com/in/nayem-ali-01b39b24b/'); // or add your URL here
                        if (!await launchUrl(url)) {
                        } else {
                          throw 'Could not launch $url';
                        }
                      },
                      icon: const Icon(
                        FontAwesomeIcons.linkedin,
                        color: Colors.blueAccent,
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        final Email emails = Email(
                          body: 'Email body',
                          subject: 'Email subject',
                          recipients: ["nayemacademic14@gmail.com"],
                          // bcc: ['bcc@example.com'],
                          // attachmentPaths: ['/path/to/attachment.zip'],
                          isHTML: false,
                        );

                        await FlutterEmailSender.send(emails);
                      },
                      icon: const Icon(
                        Icons.email,
                        color: Colors.redAccent,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              const CircleAvatar(
                backgroundImage: AssetImage("images/irin.jpg"),
                radius: 90,
              ),
              // Container(
              //   height: 160,
              //   width: 160,
              //   decoration: BoxDecoration(
              //     border: Border.all(color: Colors.teal, width: 2),
              //     // borderRadius: BorderRadius.circular(50),
              //   ),
              //   child: const Image(
              //     image: AssetImage("images/irin.jpg"),
              //     width: 50,
              //     height: 50,
              //     fit: BoxFit.fill,
              //   ),
              // ),
              const Text(
                "Irin Shorme",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Text(
                "ID: 2012020039",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              const Text(
                "CSE 53 batch",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              Center(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () async {
                        final Uri url = Uri.parse(
                            'https://www.facebook.com/profile.php?id=100015031848552&mibextid=YMEMSu'); // or add your URL here
                        if (!await launchUrl(url)) {
                        } else {
                          throw 'Could not launch $url';
                        }
                      },
                      icon: const Icon(
                        FontAwesomeIcons.facebook,
                        color: Colors.blue,
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        final Uri url = Uri.parse(
                            'https://bd.linkedin.com/in/irin-shorme-40b29b277'); // or add your URL here
                        if (!await launchUrl(url)) {
                        } else {
                          throw 'Could not launch $url';
                        }
                      },
                      icon: const Icon(
                        FontAwesomeIcons.linkedin,
                        color: Colors.blueAccent,
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        final Email emails = Email(
                          body: 'Email body',
                          subject: 'Email subject',
                          recipients: ["irinshorme786@gmail.com"],
                          // bcc: ['bcc@example.com'],
                          // attachmentPaths: ['/path/to/attachment.zip'],
                          isHTML: false,
                        );

                        await FlutterEmailSender.send(emails);
                      },
                      icon: const Icon(
                        Icons.email,
                        color: Colors.redAccent,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              const CircleAvatar(
                backgroundImage: AssetImage("images/Hir.jpg"),
                radius: 90,
              ),
              const Text(
                "MD. Mahdi Hossain Hira",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Text(
                "ID: 2012020106",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              const Text(
                "CSE 53 batch",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              Center(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () async {
                        final Uri url = Uri.parse(
                            'https://www.facebook.com/mahdi.hira.53'); // or add your URL here
                        if (!await launchUrl(url)) {
                        } else {
                          throw 'Could not launch $url';
                        }
                      },
                      icon: const Icon(
                        FontAwesomeIcons.facebook,
                        color: Colors.blue,
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        // final Uri url =
                        // Uri.parse(''); // or add your URL here
                        // if (!await launchUrl(url)) {
                        // } else {
                        //   throw 'Could not launch $url';
                        // }
                      },
                      icon: const Icon(
                        FontAwesomeIcons.linkedin,
                        color: Colors.blueAccent,
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        final Email emails = Email(
                          body: 'Email body',
                          subject: 'Email subject',
                          recipients: ["bdmahdihira53@gmail.com"],
                          // bcc: ['bcc@example.com'],
                          // attachmentPaths: ['/path/to/attachment.zip'],
                          isHTML: false,
                        );

                        await FlutterEmailSender.send(emails);
                      },
                      icon: const Icon(
                        Icons.email,
                        color: Colors.redAccent,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              const Divider(thickness: 2),
              Text(
                "Powered By",
                style: TextStyle(
                  fontSize: Get.textScaleFactor * 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Divider(thickness: 2),
              Image.asset(
                'images/intex.png',
                width: Get.width * 0.5,
                height: Get.height * 0.07,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () async {
                      final Uri url =
                          Uri.parse('https://www.intexlab.net/home'); // or add your URL here
                      if (!await launchUrl(url)) {
                      } else {
                        throw 'Could not launch $url';
                      }
                    },
                    icon: const Icon(
                      FontAwesomeIcons.globe,
                    ),
                  ),
                  IconButton(
                      onPressed: () async {
                        final Uri url =
                            Uri.parse('https://www.facebook.com/intexlab'); // or add your URL here
                        if (!await launchUrl(url)) {
                        } else {
                          throw 'Could not launch $url';
                        }
                      },
                      icon: const Icon(
                        FontAwesomeIcons.facebook,
                        color: Colors.blue,
                      )),
                  IconButton(
                    onPressed: () async {
                      final Uri url = Uri.parse(
                          'https://www.linkedin.com/company/intex-lab/'); // or add your URL here
                      if (!await launchUrl(url)) {
                      } else {
                        throw 'Could not launch $url';
                      }
                    },
                    icon: const Icon(
                      FontAwesomeIcons.linkedin,
                      color: Colors.blueAccent,
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      final Uri url =
                          Uri.parse('https://www.youtube.com/@InteXLab/'); // or add your URL here
                      if (!await launchUrl(url)) {
                      } else {
                        throw 'Could not launch $url';
                      }
                    },
                    icon: const Icon(
                      FontAwesomeIcons.youtube,
                      color: Colors.red,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
