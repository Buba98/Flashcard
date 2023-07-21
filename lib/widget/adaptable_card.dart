import 'package:flutter/material.dart';

class AdaptableCard extends StatelessWidget {
  const AdaptableCard(
      {super.key,
      required this.questionController,
      required this.answerController});

  final TextEditingController questionController;
  final TextEditingController answerController;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return constraints.maxWidth > 600
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: CardTextField.question(
                          controller: questionController,
                        ),
                      ),
                      const VerticalDivider(),
                      Expanded(
                        child: CardTextField.answer(
                          controller: answerController,
                        ),
                      ),
                    ],
                  )
                : Column(
                    children: [
                      CardTextField.question(
                        controller: questionController,
                      ),
                      const Divider(),
                      CardTextField.answer(
                        controller: answerController,
                      ),
                    ],
                  );
          },
        ),
      ),
    );
  }
}

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
