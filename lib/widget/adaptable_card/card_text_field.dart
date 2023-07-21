import 'package:flutter/material.dart';

class CardTextField extends StatelessWidget {
  const CardTextField(
      {super.key, required this.title, required this.controller});

  const CardTextField.answer({Key? key, required this.controller})
      : title = 'Answer',
        super(key: key);

  const CardTextField.question({Key? key, required this.controller})
      : title = 'Question',
        super(key: key);

  final String title;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title[0],
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 16.0),
        Expanded(
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration.collapsed(
                  hintText: title,
                ),
                controller: controller,
                keyboardType: TextInputType.multiline,
                maxLines: null,
              ),
            ],
          ),
        ),
      ],
    );
  }
}