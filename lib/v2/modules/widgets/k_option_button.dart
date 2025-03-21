import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teamlead/v2/core/utils/logger/logger.dart';

class OptionButton extends StatelessWidget {
  const OptionButton(
      {super.key, required this.onPressed, required this.optionName, required this.doesFocus});

  final String optionName;
  final Function() onPressed;
  final bool doesFocus;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(right: 4.0),
        child: OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            backgroundColor: doesFocus
                ? Theme.of(context).focusColor.withGreen(255)
                : Colors.transparent,
          ),
          child: Text(optionName),
        ),
      ),
    );
  }
}
