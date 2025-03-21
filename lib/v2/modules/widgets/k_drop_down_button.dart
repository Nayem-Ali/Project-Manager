import 'package:flutter/material.dart';
import 'package:get/get.dart';

class KDropDownButton extends StatefulWidget {
  const KDropDownButton({
    super.key,
    required this.controller,
    required this.items,
    required this.initialSelection,
  });

  final TextEditingController controller;
  final List<String> items;
  final String initialSelection;

  @override
  State<KDropDownButton> createState() => _KDropDownButtonState();
}

class _KDropDownButtonState extends State<KDropDownButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 2.0),
      child: DropdownButtonFormField(
        value: widget.initialSelection,
        items: widget.items
            .map((item) => DropdownMenuItem(
                  value: item,
                  child: Text(item),
                ))
            .toList(),
        onChanged: (value) {
          widget.controller.text = value!;
        },
        decoration: const InputDecoration(border: OutlineInputBorder()),
      ),
    );
  }
}
