import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  double? figureSize;
  double? fontSize;

  Logo({Key? key, required this.figureSize, required this.fontSize})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image(
          image: const AssetImage('images/project2.png'),
          width: figureSize,
          height: figureSize,
          color: Colors.teal.shade700,
        ),
        Text(
          "Project\nManager",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: fontSize,
            color: Colors.teal.shade700,
            letterSpacing: 2,
          ),
          textAlign: TextAlign.center,
        ),
         const SizedBox(height: 5),
      ],
    );
  }
}
