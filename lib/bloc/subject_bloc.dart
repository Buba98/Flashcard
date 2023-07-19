import 'package:flashcard/servicie/local_repository_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/deck.dart';
import '../model/subject.dart';

abstract class SubjectEvent {}

class AddDeck extends SubjectEvent {
  final String name;
  final IconData icon;

  AddDeck({
    required this.name,
    required this.icon,
  });
}

class SelectSubject extends SubjectEvent {
  final Subject? subject;

  SelectSubject(this.subject);
}

class SelectDeck extends SubjectEvent {
  final Deck? deck;

  SelectDeck(this.deck);
}

class SubjectState {
  final Subject? subject;
  final Deck? deck;

  SubjectState({
    this.subject,
    this.deck,
  });
}

class SubjectBloc extends Bloc<SubjectEvent, SubjectState> {
  SubjectBloc() : super(SubjectState()) {
    on<AddDeck>(_onAddDeck);
    on<SelectSubject>(_onSelectSubject);
    on<SelectDeck>(_onSelectDeck);
  }

  _onAddDeck(AddDeck event, Emitter<SubjectState> emit) async {
    if (state.subject == null) {
      return;
    }

    Deck deck = await LocalRepositoryService().addNewDeck(
      subject: state.subject!,
      name: event.name,
      icon: event.icon,
    );

    Subject subject = state.subject!..decks.add(deck);

    emit(SubjectState(
      subject: subject,
      deck: state.deck,
    ));
  }

  _onSelectSubject(SelectSubject event, Emitter<SubjectState> emit) {
    emit(SubjectState(
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
    ));
  }
}
