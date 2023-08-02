import 'package:flutter/cupertino.dart';

import '../../model/flashcard.dart';

class FlashcardTextEditingController {
  final TextEditingController questionController;
  final TextEditingController answerController;
  final Flashcard flashcard;

  FlashcardTextEditingController({
    required this.flashcard,
  })  : questionController = TextEditingController(text: flashcard.question),
        answerController = TextEditingController(text: flashcard.answer);
}
