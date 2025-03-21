import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:teamlead/v2/core/utils/constant/description.dart';
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
        title: const Text("ABOUT US"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Project Info
              Card(
                elevation: 5,
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text(
                        "Project Manager",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const Divider(),
                      const Text(
                        "Version: 1.0.0",
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          Description.projectDescription,
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Instructor Info
              const Divider(thickness: 2,),
              const Text(
                "Instructed By",
                style: TextStyle(
                    color: Colors.teal, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Divider(thickness: 2,),
              const Card(
                elevation: 5,
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: AssetImage("images/srk.jpg"),
                      ),
                      Text(
                        "MD. Saidur Rahman Kohinoor",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Lecturer & Advisor IEEE CS LU SBC",
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Department of CSE",
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      SocialMediaRow(
                          facebookUrl: 'https://www.facebook.com/Kohinoor11?mibextid=YMEMSu',
                          linkedinUrl: 'https://www.linkedin.com/in/sairdur-rahman-kohinoor',
                          email: 'kohinoor_cse@lus.ac.bd'),
                    ],
                  ),
                ),
              ),
              // Developer Info: Nayem Ali
              Divider(thickness: 2,),
              Text(
                "Developed By",
                style: TextStyle(
                    color: Colors.teal, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Divider(thickness: 2,),
              const DeveloperCard(
                name: "Nayem Ali",
                role: "Frontend & Backend",
                id: "2012020023",
                batch: "CSE (53)",
                image: "images/nayem.jpg",
                facebookUrl: 'https://www.facebook.com/clavicle.bones?mibextid=9R9pXO',
                linkedinUrl: 'https://www.linkedin.com/in/nayem-ali-01b39b24b/',
                email: 'nayemacademic14@gmail.com',
              ),
              // Developer Info: Irin Shorme
              const DeveloperCard(
                name: "Irin Shorme",
                role: "UI Design",
                id: "2012020039",
                batch: "CSE (53)",
                image: "images/irin.jpg",
                facebookUrl:
                    'https://www.facebook.com/profile.php?id=100015031848552&mibextid=YMEMSu',
                linkedinUrl: 'https://bd.linkedin.com/in/irin-shorme-40b29b277',
                email: 'irinshorme786@gmail.com',
              ),
              // Developer Info: MD. Mahdi Hossain Hira
              // DeveloperCard(
              //   name: "MD. Mahdi Hossain Hira",
              //   role: "Frontend",
              //   id: "2012020106",
              //   batch: "CSE 53 batch",
              //   image: "images/Hir.jpg",
              //   facebookUrl: 'https://www.facebook.com/mahdi.hira.53',
              //   linkedinUrl: '',
              //   email: 'bdmahdihira53@gmail.com',
              // ),
              const SizedBox(height: 10),
              const Divider(thickness: 2),
              const Text(
                "Powered By",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Divider(thickness: 2),
              Image.asset(
                'images/intex.png',
                width: Get.width * 0.5,
                height: Get.height * 0.07,
              ),
              const SocialMediaRow(
                facebookUrl: 'https://www.facebook.com/intexlab',
                linkedinUrl: 'https://www.linkedin.com/company/intex-lab/',
                youtubeUrl: 'https://www.youtube.com/@InteXLab/',
                websiteUrl: 'https://www.intexlab.net/home',
                email: '',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DeveloperCard extends StatelessWidget {
  final String name;
  final String role;
  final String id;
  final String batch;
  final String image;
  final String facebookUrl;
  final String linkedinUrl;
  final String email;

  const DeveloperCard({
    Key? key,
    required this.name,
    required this.role,
    required this.id,
    required this.batch,
    required this.image,
    required this.facebookUrl,
    required this.linkedinUrl,
    required this.email,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage(image),
            ),
            const SizedBox(height: 10),
            Text(
              name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              role,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            Text(
              "ID: $id",
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            Text(
              batch,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            SocialMediaRow(
              facebookUrl: facebookUrl,
              linkedinUrl: linkedinUrl,
              email: email,
            ),
          ],
        ),
      ),
    );
  }
}

class SocialMediaRow extends StatelessWidget {
  final String facebookUrl;
  final String linkedinUrl;
  final String email;
  final String? websiteUrl;
  final String? youtubeUrl;

  const SocialMediaRow({
    Key? key,
    required this.facebookUrl,
    required this.linkedinUrl,
    required this.email,
    this.websiteUrl,
    this.youtubeUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () async {
            if (!await launchUrl(Uri.parse(facebookUrl))) {
              throw 'Could not launch $facebookUrl';
            }
          },
          icon: const Icon(FontAwesomeIcons.facebook, color: Colors.blue),
        ),
        IconButton(
          onPressed: () async {
            if (!await launchUrl(Uri.parse(linkedinUrl))) {
              throw 'Could not launch $linkedinUrl';
            }
          },
          icon: const Icon(FontAwesomeIcons.linkedin, color: Colors.blueAccent),
        ),
        IconButton(
          onPressed: () async {
            final Email em = Email(
              body: 'Email body',
              subject: 'Email subject',
              recipients: [email],
              isHTML: false,
            );
            await FlutterEmailSender.send(em);
          },
          icon: const Icon(Icons.email, color: Colors.redAccent),
        ),
        if (websiteUrl != null)
          IconButton(
            onPressed: () async {
              if (!await launchUrl(Uri.parse(websiteUrl!))) {
                throw 'Could not launch $websiteUrl';
              }
            },
            icon: const Icon(FontAwesomeIcons.globe),
          ),
        if (youtubeUrl != null)
          IconButton(
            onPressed: () async {
              if (!await launchUrl(Uri.parse(youtubeUrl!))) {
                throw 'Could not launch $youtubeUrl';
              }
            },
            icon: const Icon(FontAwesomeIcons.youtube, color: Colors.red),
          ),
      ],
    );
  }
}
