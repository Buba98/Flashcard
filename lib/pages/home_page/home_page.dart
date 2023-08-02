import 'package:flashcard/bloc/subject_bloc.dart';
import 'package:flashcard/pages/home_page/home_content/home_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/subject.dart';
import '../../widget/adaptable_button.dart';
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
    return BlocBuilder<SubjectBloc, SubjectState>(
      builder: (BuildContext context, SubjectState subjectState) {
        return AdaptablePage(
          expanded: expanded,
          onExpand: onExpand,
          drawer: SubjectSelection(
            subjects: subjectState.subjects,
            expanded: expanded,
          ),
          content: const HomeContent(),
          title: subjectState.subject == null
              ? 'Select subject'
              : '${subjectState.subject!.name}${subjectState.deck == null ? '' : ' - ${subjectState.deck!.name}'}',
          actions: [
            if (subjectState.subject != null)
              IntrinsicWidth(
                child: AdaptableButton(
                  onPressed: () => onDeleteSubject(subjectState.subject!),
                  title: 'Delete subject',
                  icon: Icons.delete_outline,
                  expanded: false,
                ),
              ),
          ],
        );
      },
    );
  }

  void onExpand() => setState(() => expanded = !expanded);

  void onDeleteSubject(Subject subject) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Delete subject'),
        content: const Text('Are you sure you want to delete this subject?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<SubjectBloc>().add(
                    DeleteSubject(
                      subject: subject,
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
