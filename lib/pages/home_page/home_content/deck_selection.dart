import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';

import '../../../bloc/subject_bloc.dart';
import '../../../model/deck.dart';
import '../../../model/subject.dart';
import '../../../presentation/education_icons.dart';
import '../../../widget/adaptable_button.dart';

class DeckSelection extends StatelessWidget {
  const DeckSelection({
    super.key,
    required this.subject,
  });

  final Subject subject;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        for (final Deck deck in subject.decks) ...[
          ListTile(
            leading: Icon(deck.icon),
            title: Text(deck.name),
            subtitle: Text('${deck.flashcards.length} cards'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () => null,
                  icon: const Icon(Icons.play_arrow_outlined),
                ),
                const SizedBox(width: 16.0),
                IconButton(
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: () =>
                      context.read<SubjectBloc>().add(SelectDeck(deck)),
                ),
                const SizedBox(width: 16.0),
                IconButton(
                  icon: const Icon(Icons.delete_outlined),
                  onPressed: () => onDeleteDeck(context, deck),
                ),
              ],
            ),
          ),
          const Divider(),
        ],
        ListTile(
          onTap: () => onAddDeck(context),
          leading: const Icon(Icons.add),
          title: const Text('Add deck'),
        )
      ],
    );
  }

  void onDeleteDeck(BuildContext context, Deck deck) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Delete deck'),
        content: const Text('Are you sure you want to delete this deck?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<SubjectBloc>().add(
                    DeleteDeck(
                      deck: deck,
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

  void onAddDeck(BuildContext context) {
    TextEditingController textEditingController = TextEditingController();

    showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        IconData icon = EducationIcons.openBook;

        return StatefulBuilder(
          builder: (BuildContext context, Function setState) {
            return AlertDialog(
              title: const Text('Create new deck'),
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
                      hintText: 'Enter the name of the deck',
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
                          AddDeck(
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
