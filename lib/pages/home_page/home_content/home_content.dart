import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/subject_bloc.dart';
import 'deck_modify.dart';
import 'deck_selection.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubjectBloc, SubjectState>(
      builder: (BuildContext context, SubjectState subjectState) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: subjectState.subject == null
              ? const Center(
                  child: Text('Select a subject first'),
                )
              : subjectState.deck == null
                  ? DeckSelection(
                      subject: subjectState.subject!,
                    )
                  : DeckModify(
                      deck: subjectState.deck!,
                      visualize: subjectState.visualize ?? false,
                    ),
        );
      },
    );
  }
}
