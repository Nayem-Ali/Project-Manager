import 'package:flutter/material.dart';
import 'package:get/get.dart';

buttonStyle() => ElevatedButton.styleFrom(
      minimumSize: Size(Get.width * 0.7, Get.height * 0.07),
      textStyle: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: Get.textScaleFactor * 18,
      ),
    );
