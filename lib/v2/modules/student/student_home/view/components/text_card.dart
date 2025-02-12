import 'package:flutter/material.dart';
class TextCard extends StatelessWidget {
  const TextCard({super.key, required this.text, required this.color});
  final String text;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(Icons.info, color: color),
        title: Text(
          text,
          textAlign: TextAlign.justify,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      )
    );
  }
}
