import 'package:flashcard/widget/flashcard_text_editing_controller/flashcard_text_editing_controller.dart';
import 'package:flutter/material.dart';

import 'card_text_field.dart';

class AdaptableCard extends StatelessWidget {
  const AdaptableCard({
    super.key,
    required this.flashcardTextEditingController,
    this.hiddenAnswer = false,
    this.readOnly = false,
  });

  final FlashcardTextEditingController flashcardTextEditingController;
  final bool hiddenAnswer;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints boxConstraints) {
            if (boxConstraints.maxWidth > 600) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: CardTextField.question(
                      readOnly: readOnly,
                      controller:
                          flashcardTextEditingController.questionController,
                    ),
                  ),
                  if (!hiddenAnswer) ...[
                    // const VerticalDivider(),
                    Expanded(
                      child: CardTextField.answer(
                        readOnly: readOnly,
                        controller:
                            flashcardTextEditingController.answerController,
                      ),
                    ),
                  ],
                ],
              );
            } else {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CardTextField.question(
                    readOnly: readOnly,
                    controller:
                        flashcardTextEditingController.questionController,
                  ),
                  if (!hiddenAnswer) ...[
                    const Divider(),
                    CardTextField.answer(
                      readOnly: readOnly,
                      controller:
                          flashcardTextEditingController.answerController,
                    ),
                  ],
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
