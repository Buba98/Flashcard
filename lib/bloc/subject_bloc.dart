import 'dart:async';
import 'dart:math';

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
  final String? question;
  final String? answer;
  final int? index;

  SaveFlashcard({
    required this.flashcard,
    this.completer,
    required this.question,
    required this.answer,
    this.index,
  });
}

class ReorderFlashcard extends SubjectEvent {
  final int newIndex;
  final int oldIndex;

  ReorderFlashcard({
    required this.newIndex,
    required this.oldIndex,
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
  final int index;

  AddFlashcard({
    this.question = '',
    this.answer = '',
    required this.index,
  });
}

/// DELETE

class DeleteFlashcard extends SubjectEvent {
  final int index;

  DeleteFlashcard({
    required this.index,
  });
}

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

class DeleteAllSubjects extends SubjectEvent {}

/// SELECT
class SelectSubject extends SubjectEvent {
  final Subject? subject;

  SelectSubject(this.subject);
}

class SelectDeck extends SubjectEvent {
  final Deck? deck;
  final bool visualize;

  SelectDeck(this.deck, {this.visualize = false});
}

class SubjectState {
  final List<Subject> subjects;
  final Subject? subject;
  final Deck? deck;
  final bool? visualize;

  SubjectState({
    required this.subjects,
    this.subject,
    this.deck,
    this.visualize
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
    on<DeleteAllSubjects>(_onDeleteAllSubject);
    on<ReorderFlashcard>(_onReorderFlashcard);
    on<DeleteFlashcard>(_onDeleteFlashcard);

    add(_LoadLocal());
  }

  _onAddDeck(AddDeck event, Emitter<SubjectState> emit) async {
    if (state.subject == null) {
      return;
    }

    debugPrint('AddDeck');

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
    debugPrint('SelectSubject');

    emit(SubjectState(
      subjects: state.subjects,
      subject: event.subject,
    ));
  }

  _onSelectDeck(SelectDeck event, Emitter<SubjectState> emit) {
    if (state.subject == null) {
      return;
    }

    debugPrint('SelectDeck');

    assert(state.subject!.decks.contains(event.deck));

    emit(SubjectState(
      subject: state.subject,
      deck: event.deck,
      subjects: state.subjects,
      visualize: event.visualize,
    ));
  }

  _onDeleteDeck(DeleteDeck event, Emitter<SubjectState> emit) async {
    if (state.subject == null) {
      return;
    }

    debugPrint('DeleteDeck');

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
    debugPrint('DeleteSubject');

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

    debugPrint('AddFlashcard');

    Flashcard flashcard = await LocalRepositoryService.addNewFlashcard(
      deck: state.deck!,
      question: event.question,
      answer: event.answer,
      index: event.index,
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

    debugPrint('SaveFlashcard');

    Flashcard flashcard = await LocalRepositoryService.updateFlashcard(
      flashcard: event.flashcard,
      question: event.question,
      answer: event.answer,
      index: event.index,
    );

    for (int i = 0; i < state.deck!.flashcards.length; i++) {
      if (state.deck!.flashcards[i].id == flashcard.id) {
        state.deck!.flashcards[i] = flashcard;
      }
    }

    event.completer?.complete();
  }

  _onLoadLocal(_LoadLocal event, Emitter<SubjectState> emit) async {
    debugPrint('_LoadLocal');

    List<Subject> subjects = await LocalRepositoryService.getSubjects();

    emit(SubjectState(
      subjects: subjects,
    ));
  }

  _onAddSubject(AddSubject event, Emitter<SubjectState> emit) async {
    debugPrint('AddSubject');

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

  _onDeleteAllSubject(DeleteAllSubjects event, Emitter<SubjectState> emit) {
    LocalRepositoryService.clear();

    emit(SubjectState(subjects: []));
  }

  _onReorderFlashcard(
      ReorderFlashcard event, Emitter<SubjectState> emit) async {
    if (state.deck == null || state.subject == null) {
      return;
    }

    if (event.newIndex == event.oldIndex) {
      return;
    }

    assert(
        state.deck!.flashcards.length >= max(event.newIndex, event.oldIndex));

    debugPrint('ReorderFlashcard');

    Deck deck = state.deck!;

    state.subject!.decks.remove(deck);
    List<Flashcard> flashcards = [...deck.flashcards];

    Flashcard flashcard = flashcards.removeAt(event.oldIndex);

    flashcards.insert(event.newIndex, flashcard);

    for (int i = min(event.newIndex, event.oldIndex);
        i <= max(event.newIndex, event.oldIndex);
        i++) {
      flashcards[i] = await LocalRepositoryService.updateFlashcard(
        flashcard: flashcards[i],
        index: i,
      );
    }

    deck = Deck(
      id: deck.id,
      name: deck.name,
      icon: deck.icon,
      flashcards: flashcards,
    );

    state.subject!.decks.add(deck);

    emit(SubjectState(
      deck: deck,
      subject: state.subject,
      subjects: state.subjects,
    ));
  }

  _onDeleteFlashcard(DeleteFlashcard event, Emitter<SubjectState> emit) async {
    if (state.deck == null || state.subject == null) {
      return;
    }

    debugPrint('DeleteFlashcard');

    Deck deck = state.deck!;

    state.subject!.decks.remove(deck);
    List<Flashcard> flashcards = [...deck.flashcards];

    flashcards.removeAt(event.index);
    await LocalRepositoryService.removeFlashcard(
        deck.flashcards[event.index], deck);

    for (int i = event.index; i < flashcards.length; i++) {
      flashcards[i] = await LocalRepositoryService.updateFlashcard(
        flashcard: flashcards[i],
        index: i,
      );
    }

    deck = Deck(
      id: deck.id,
      name: deck.name,
      icon: deck.icon,
      flashcards: flashcards,
    );

    state.subject!.decks.add(deck);

    emit(SubjectState(
      deck: deck,
      subject: state.subject,
      subjects: state.subjects,
    ));
  }
}
