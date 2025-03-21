import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:teamlead/v2/core/utils/constant/icons_path.dart';

class UniversityLogo extends StatelessWidget {
  const UniversityLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Image(
      height: 150,
      width: 150,
      image: const AssetImage(IconsPath.universityLogoIcon),
      // color: Colors.teal.shade700,
    );
  }
}
