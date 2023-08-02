import 'package:flashcard/model/flashcard.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/deck.dart';
import '../model/subject.dart';

class PlayEvent {}

class Play extends PlayEvent {}

class Answer extends PlayEvent {
  final bool correct;

  Answer({
    required this.correct,
  });
}

class PlayState {
  final Stopwatch stopwatch;

  PlayState({
    required this.stopwatch,
  });
}

abstract class Initialized extends PlayState {
  final List<(bool?, Flashcard)> flashcards;

  Initialized({
    required this.flashcards,
    required super.stopwatch,
  });
}

class Playing extends Initialized {
  final Flashcard nextFlashcard;
  final int index;

  Playing({
    required this.nextFlashcard,
    required super.flashcards,
    required this.index,
    required super.stopwatch,
  });
}

class Finished extends Initialized {
  Finished({
    required super.flashcards,
    required super.stopwatch,
  });
}

class PlayBloc extends Bloc<PlayEvent, PlayState> {
  final Subject subject;
  final Deck deck;

  PlayBloc({required this.subject, required this.deck})
      : super(PlayState(stopwatch: Stopwatch())) {
    on<Play>(_onPlay);
    on<Answer>(_onAnswer);
  }

  void _onPlay(Play event, Emitter<PlayState> emit) {
    List<(bool?, Flashcard)> flashcards = ([...deck.flashcards]..shuffle())
        .map((flashcard) => (null, flashcard))
        .toList();

    int index = 0;

    final Flashcard nextFlashcard = flashcards[index].$2;

    emit(Playing(
      nextFlashcard: nextFlashcard,
      stopwatch: state.stopwatch..start(),
      flashcards: flashcards,
      index: index,
    ));
  }

  void _onAnswer(Answer event, Emitter<PlayState> emit) {
    assert(state is Playing);

    int index = (state as Playing).index;

    final List<(bool?, Flashcard)> flashcards = [];

    for (int i = 0; i < (state as Playing).flashcards.length; i++) {
      if (i == index) {
        flashcards.add((event.correct, (state as Playing).flashcards[i].$2));
      } else {
        flashcards.add((state as Playing).flashcards[i]);
      }
    }

    if (index == flashcards.length - 1) {
      emit(Finished(
        flashcards: flashcards,
        stopwatch: state.stopwatch..stop(),
      ));
      return;
    } else {
      index++;

      emit(Playing(
        nextFlashcard: flashcards[index].$2,
        stopwatch: state.stopwatch,
        flashcards: flashcards,
        index: index,
      ));
    }
  }
}
