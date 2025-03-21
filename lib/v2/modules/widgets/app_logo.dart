import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Image(
          height: 200,
          width: 200,
          image: AssetImage('images/logo1.png'),
          // color: Colors.teal.shade700,
        ),
        Text(
          "Project Manager",
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(color: Theme.of(context).colorScheme.primary),
        )
      ],
    );
  }
}
