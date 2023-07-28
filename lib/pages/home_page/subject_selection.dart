import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';

import '../../bloc/subject_bloc.dart';
import '../../model/subject.dart';
import '../../presentation/education_icons.dart';
import '../../service/local_repository_service.dart';
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
        if (kDebugMode) ...[
          const Divider(),
          AdaptableButton(
            onPressed: () => LocalRepositoryService.debug(),
            icon: Icons.info_outline,
            title: 'Debug info',
            expanded: expanded,
          ),
          AdaptableButton(
            onPressed: () =>
                context.read<SubjectBloc>().add(DeleteAllSubjects()),
            icon: Icons.remove_outlined,
            title: 'Delete all subjects',
            expanded: expanded,
          ),
        ]
      ],
    );
  }

  void onAddSubject(BuildContext context) {
    TextEditingController textEditingController = TextEditingController();

    showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        IconData icon = EducationIcons.openBook;

        return StatefulBuilder(
          builder: (BuildContext context, Function setState) {
            return AlertDialog(
              title: const Text('Create new subject'),
              content: Flex(
                direction: Axis.vertical,
                mainAxisSize: MainAxisSize.min,
                children: [
                  AdaptableButton(
                    onPressed: () async {
                      IconData? newIcon =
                          await FlutterIconPicker.showIconPicker(context,
                              iconPackModes: [IconPack.custom],
                              customIconPack: EducationIcons.icons);

                      if (newIcon != null) {
                        setState(() {
                          icon = newIcon;
                        });
                      }
                    },
                    icon: icon,
                    expanded: true,
                    title: 'Select icon',
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextField(
                    decoration: const InputDecoration(
                      hintText: 'Enter the name of the subject',
                    ),
                    controller: textEditingController,
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Cancel'),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    context.read<SubjectBloc>().add(
                          AddSubject(
                            name: textEditingController.text,
                            icon: icon,
                          ),
                        );

                    Navigator.pop(context, 'OK');
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
