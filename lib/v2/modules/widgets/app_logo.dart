import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        LayoutBuilder(
          builder: (ctx, constraints) {
            double aspectRatio = constraints.maxWidth / constraints.maxHeight;
            double imageSize =
                aspectRatio > 1 ? constraints.maxHeight * 0.5 : constraints.maxWidth * 0.5;
            return Image(
              height: imageSize,
              width: imageSize,
              image: const AssetImage('images/logo1.png'),
              // color: Colors.teal.shade700,
            );
          },
        ),
        Text(
          "Project Manager",
          style: Theme.of(context).textTheme.titleLarge,
        )
      ],
    );
  }
}
