import 'package:flutter/cupertino.dart';
import 'package:teamlead/v2/core/utils/constant/icons_path.dart';

class UniversityLogo extends StatelessWidget {
  const UniversityLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, constraints) {
        double aspectRatio = constraints.maxWidth / constraints.maxHeight;
        double imageSize =
        aspectRatio > 1 ? constraints.maxHeight * 0.4 : constraints.maxWidth * 0.4;
        return Image(
          height: imageSize,
          width: imageSize,
          image: const AssetImage(IconsPath.universityLogo),
          // color: Colors.teal.shade700,
        );
      },
    );
  }
}
