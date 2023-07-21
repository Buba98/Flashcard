import 'dart:async';

import 'package:flashcard/service/local_repository_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/deck.dart';
import '../model/flashcard.dart';
import '../model/subject.dart';

abstract class SubjectEvent {}

/// LOAD

class _LoadLocal extends SubjectEvent {}

/// MODIFY

class SaveFlashcard extends SubjectEvent {
  final Flashcard flashcard;
  final Completer? completer;
  final String question;
  final String answer;

  SaveFlashcard({
    required this.flashcard,
    this.completer,
    required this.question,
    required this.answer,
  });
}

/// ADD

class AddSubject extends SubjectEvent {
  final String name;
  final IconData icon;

  AddSubject({
    required this.name,
    required this.icon,
  });
}

class AddDeck extends SubjectEvent {
  final String name;
  final IconData icon;

  AddDeck({
    required this.name,
    required this.icon,
  });
}

class AddFlashcard extends SubjectEvent {
  final String question;
  final String answer;

  AddFlashcard({
    this.question = '',
    this.answer = '',
  });
}

/// DELETE
class DeleteDeck extends SubjectEvent {
  final Deck? deck;

  DeleteDeck({
    required this.deck,
  });
}

class DeleteSubject extends SubjectEvent {
  final Subject subject;

  DeleteSubject({
    required this.subject,
  });
}

/// SELECT
class SelectSubject extends SubjectEvent {
  final Subject? subject;

  SelectSubject(this.subject);
}

class SelectDeck extends SubjectEvent {
  final Deck? deck;

  SelectDeck(this.deck);
}

class SubjectState {
  final List<Subject> subjects;
  final Subject? subject;
  final Deck? deck;

  SubjectState({
    required this.subjects,
    this.subject,
    this.deck,
  });
}

class SubjectBloc extends Bloc<SubjectEvent, SubjectState> {
  SubjectBloc() : super(SubjectState(subjects: [])) {
    on<AddDeck>(_onAddDeck);
    on<SelectSubject>(_onSelectSubject);
    on<SelectDeck>(_onSelectDeck);
    on<DeleteDeck>(_onDeleteDeck);
    on<DeleteSubject>(_onDeleteSubject);
    on<AddFlashcard>(_onAddFlashCard);
    on<SaveFlashcard>(_onSaveFlashcard);
    on<AddSubject>(_onAddSubject);
    on<_LoadLocal>(_onLoadLocal);

    add(_LoadLocal());
  }

  _onAddDeck(AddDeck event, Emitter<SubjectState> emit) async {
    if (state.subject == null) {
      return;
    }

    Deck deck = await LocalRepositoryService.addNewDeck(
      subject: state.subject!,
      name: event.name,
      icon: event.icon,
    );

    Subject subject = state.subject!..decks.add(deck);

    emit(SubjectState(
      subjects: state.subjects,
      subject: subject,
      deck: state.deck,
    ));
  }

  _onSelectSubject(SelectSubject event, Emitter<SubjectState> emit) {
    emit(SubjectState(
      subjects: state.subjects,
      subject: event.subject,
    ));
  }

  _onSelectDeck(SelectDeck event, Emitter<SubjectState> emit) {
    if (state.subject == null) {
      return;
    }

    assert(state.subject!.decks.contains(event.deck));

    emit(SubjectState(
      subject: state.subject,
      deck: event.deck,
      subjects: state.subjects,
    ));
  }

  _onDeleteDeck(DeleteDeck event, Emitter<SubjectState> emit) async {
    if (state.subject == null) {
      return;
    }

    if (event.deck != null) {
      await LocalRepositoryService.removeDeck(event.deck!, state.subject!);
    } else if (state.deck != null) {
      assert(state.subject!.decks.contains(event.deck));

      await LocalRepositoryService.removeDeck(state.deck!, state.subject!);
    }

    Subject subject = state.subject!..decks.remove(event.deck);

    emit(SubjectState(
      subject: subject,
      subjects: state.subjects,
    ));
  }

  _onDeleteSubject(DeleteSubject event, Emitter<SubjectState> emit) async {
    await LocalRepositoryService.removeSubject(event.subject);

    List<Subject> subjects = state.subjects;

    for (int i = 0; i < subjects.length; i++) {
      if (subjects[i].id == event.subject.id) {
        subjects.removeAt(i);
      }
    }

    emit(SubjectState(
      subjects: subjects,
    ));
  }

  _onAddFlashCard(AddFlashcard event, Emitter<SubjectState> emit) async {
    if (state.deck == null) {
      return;
    }

    Flashcard flashcard = await LocalRepositoryService.addNewFlashcard(
      deck: state.deck!,
      question: event.question,
      answer: event.answer,
    );

    state.deck!.flashcards.add(flashcard);

    emit(SubjectState(
      subject: state.subject,
      deck: state.deck,
      subjects: state.subjects,
    ));
  }

  _onSaveFlashcard(SaveFlashcard event, Emitter<SubjectState> emit) async {
    if (state.deck == null) {
      return;
    }

    Flashcard flashcard = Flashcard(
      id: event.flashcard.id,
      question: event.question,
      answer: event.answer,
    );

    await LocalRepositoryService.updateFlashcard(
      flashcard,
    );

    for (int i = 0; i < state.deck!.flashcards.length; i++) {
      if (state.deck!.flashcards[i].id == flashcard.id) {
        state.deck!.flashcards[i] = flashcard;
      }
    }

    event.completer?.complete();
  }

  _onLoadLocal(_LoadLocal event, Emitter<SubjectState> emit) async {
    List<Subject> subjects = await LocalRepositoryService.getSubjects();

    emit(SubjectState(
      subjects: subjects,
    ));
  }

  _onAddSubject(AddSubject event, Emitter<SubjectState> emit) async {
    Subject subject = await LocalRepositoryService.addNewSubject(
      name: event.name,
      icon: event.icon,
    );

    List<Subject> subjects = [...state.subjects, subject];

    emit(SubjectState(
      deck: state.deck,
      subject: state.subject,
      subjects: subjects,
    ));
  }
}
