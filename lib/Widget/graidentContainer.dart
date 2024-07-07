import 'package:flutter/material.dart';

customContainer(Widget widget) {
  return Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Colors.green.shade100,
          Colors.teal.shade200,
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    child: widget,
  );
}
