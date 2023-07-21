import 'dart:async';

import 'package:flashcard/bloc/subject_bloc.dart';
import 'package:flutter/cupertino.dart';

import '../model/flashcard.dart';

class AutoSaveTextEditingController {
  final TextEditingController questionController;
  final TextEditingController answerController;
  final Flashcard flashcard;
  final SubjectBloc subjectBloc;

  AutoSaveTextEditingController({
    required this.flashcard,
    required this.subjectBloc,
  })  : questionController = TextEditingController(text: flashcard.question),
        answerController = TextEditingController(text: flashcard.answer) {
    questionController.addListener(_onEvent);
    answerController.addListener(_onEvent);
  }

  _onEvent() async {
    Completer completer = Completer();

    futureTransaction = completer;

    await currentTransaction?.future;

    if (futureTransaction == completer) {
      currentTransaction = completer;

      subjectBloc.add(SaveFlashcard(
        flashcard: flashcard,
        answer: answerController.text,
        question: questionController.text,
        completer: completer,
      ));
    }
  }

  Completer? currentTransaction;
  Completer? futureTransaction;
}
