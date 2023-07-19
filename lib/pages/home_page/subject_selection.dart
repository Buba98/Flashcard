import 'package:flashcard/bloc/subjects_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/subject_bloc.dart';
import '../../model/subject.dart';
import '../../presentation/education_icons.dart';
import '../../widget/adaptable_button.dart';

class SubjectSelection extends StatelessWidget {
  const SubjectSelection({
    super.key,
    required this.subjects,
    this.expanded = true,
  });

  final List<Subject> subjects;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        for (Subject subject in subjects) ...[
          AdaptableButton(
            onPressed: () =>
                context.read<SubjectBloc>().add(SelectSubject(subject)),
            icon: subject.icon,
            title: subject.name,
            expanded: expanded,
            selected: context.read<SubjectBloc>().state.subject == subject,
          ),
          const Divider(),
        ],
        AdaptableButton(
          onPressed: () => onAddSubject(context),
          icon: Icons.add,
          title: 'Add subject',
          expanded: expanded,
        ),
      ],
    );
  }

  void onAddSubject(BuildContext context) {
    TextEditingController textEditingController = TextEditingController();

    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Create new subject'),
        content: TextField(
          controller: textEditingController,
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<SubjectsBloc>().add(
                    AddSubject(
                      name: textEditingController.text,
                      icon: EducationIcons.open_book,
                    ),
                  );

              Navigator.pop(context, 'OK');
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}