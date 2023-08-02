import 'package:flutter/material.dart';

class CardTextField extends StatelessWidget {
  const CardTextField.answer({
    Key? key,
    required this.controller,
    required this.readOnly,
  })  : title = 'Answer',
        super(key: key);

  const CardTextField.question({
    Key? key,
    required this.controller,
    required this.readOnly,
  })  : title = 'Question',
        super(key: key);

  final String title;
  final TextEditingController controller;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title[0],
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          readOnly: readOnly,
          decoration: InputDecoration.collapsed(
            hintText: title,
          ),
          controller: controller,
          keyboardType: TextInputType.multiline,
          maxLines: null,
        ),
      ],
    );
  }
}
