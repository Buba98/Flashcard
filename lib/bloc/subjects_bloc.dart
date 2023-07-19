import 'package:flashcard/servicie/local_repository_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/subject.dart';

abstract class SubjectsEvent {}

class AddSubject extends SubjectsEvent {
  final String name;
  final IconData icon;

  AddSubject({
    required this.name,
    required this.icon,
  });
}

class _LoadLocal extends SubjectsEvent {}

class SubjectsState {
  final List<Subject> subjects;

  SubjectsState({
    required this.subjects,
  });
}

class SubjectsBloc extends Bloc<SubjectsEvent, SubjectsState> {
  SubjectsBloc() : super(SubjectsState(subjects: [])) {
    on<AddSubject>(_onAddSubject);
    on<_LoadLocal>(_onLoadLocal);

    add(_LoadLocal());
  }

  _onLoadLocal(_LoadLocal event, Emitter<SubjectsState> emit) async {
    List<Subject> subjects = await LocalRepositoryService().getSubjects();

    emit(SubjectsState(subjects: subjects));
  }

  _onAddSubject(AddSubject event, Emitter<SubjectsState> emit) async {
    Subject subject = await LocalRepositoryService().addNewSubject(
      name: event.name,
      icon: event.icon,
    );

    List<Subject> subjects = [...state.subjects, subject];

    emit(SubjectsState(
      subjects: subjects,
    ));
  }
}
