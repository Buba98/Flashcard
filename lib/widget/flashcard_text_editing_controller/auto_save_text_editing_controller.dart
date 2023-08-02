import 'dart:async';

import 'package:flashcard/bloc/subject_bloc.dart';

import 'flashcard_text_editing_controller.dart';

class AutoSaveTextEditingController extends FlashcardTextEditingController {
  final SubjectBloc subjectBloc;

  AutoSaveTextEditingController({
    required super.flashcard,
    required this.subjectBloc,
  }) {
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
