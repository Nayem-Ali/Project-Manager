import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GridItem extends StatelessWidget {
  const GridItem({
    super.key,
    required this.gridImage,
    required this.gridText,
    required this.onTap,
  });

  final String gridImage;
  final String gridText;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        color: Colors.teal.shade50,
        elevation: 4,
        child: Container(
          margin: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      gridImage,
                      height: Get.height * 0.2,
                      width: Get.width * 0.4,
                    ),
                  ),
                ),
                Text(
                  gridText,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
