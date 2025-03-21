import 'package:flutter/material.dart';
import 'package:teamlead/v2/modules/widgets/app_logo.dart';
class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: AppLogo(),
      ),
    );
  }
}
