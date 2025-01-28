import 'package:flutter/material.dart';
import 'package:get/get.dart';

class KDataValidationInfoWidget extends StatelessWidget {
  final Map<String, Map<String, String>> validationRules = {
    "Full Name": {
      "format": "2-16 letters (with optional '.'), up to 3 additional names.",
      "example": "John Doe or Dr. John A. Smith",
    },
    "Student ID": {
      "format": "10 or 16 digits.",
      "example": "2012020023 or 0182210012101198",
    },
    "Teacher Initial": {
      "format": "3-5 uppercase letters.",
      "example": "SRK or TCHRS",
    },
    "Email": {
      "format": "Valid email address format.",
      "example": "example@domain.com or cse_2012020023@lus.ac.bd",
    },
    "Phone Number": {
      "format": "Bangladeshi phone number (+88 optional).",
      "example": "+8801712345678 or 01712345678",
    },
    "CGPA": {
      "format": "1.00 to 4.00, two decimal places.",
      "example": "3.75 or 4.00",
    },
  };

  KDataValidationInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            color: Theme.of(context).focusColor.withGreen(100),
            height: 80,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox.shrink(),
                  Text(
                    'Validation Formats',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(
                      Icons.arrow_circle_down_rounded,
                      size: 35,
                    ),
                  )
                ],
              ),
            ),
          ),
          Flexible(
            child: ListView.separated(
              padding: const EdgeInsets.all(16.0),
              itemCount: validationRules.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, index) {
                final key = validationRules.keys.elementAt(index);
                final value = validationRules[key]!;
                return Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          key,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text("Format: ${value['format']}",
                            style: Theme.of(context).textTheme.bodyMedium),
                        const SizedBox(height: 4),
                        Text("Example: ${value['example']}",
                            style: Theme.of(context).textTheme.bodySmall),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
