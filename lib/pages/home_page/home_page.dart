import 'package:flashcard/bloc/subject_bloc.dart';
import 'package:flashcard/bloc/subjects_bloc.dart';
import 'package:flashcard/pages/home_page/home_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../widget/adaptable_page.dart';
import 'subject_selection.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubjectsBloc, SubjectsState>(
      builder: (BuildContext context, SubjectsState subjectsState) {
        return BlocBuilder<SubjectBloc, SubjectState>(
            builder: (BuildContext context, SubjectState subjectState) {
          return AdaptablePage(
            expanded: expanded,
            onExpand: onExpand,
            drawer: SubjectSelection(
              subjects: subjectsState.subjects,
              expanded: expanded,
            ),
            content: const HomeContent(),
            title: subjectState.subject == null
                ? 'Select subject'
                : '${subjectState.subject!.name}${subjectState.deck == null ? '' : ' - ${subjectState.deck!.name}'}',
          );
        });
      },
    );
  }

  void onExpand() => setState(() => expanded = !expanded);
}
