import 'package:flashcard/presentation/education_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/subject_bloc.dart';
import '../../model/deck.dart';
import '../../model/subject.dart';
import '../../widget/adaptable_card.dart';

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
                : const DeckModify(),
      );
    });
  }
}

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
                )
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

  void onAddDeck(BuildContext context) {
    TextEditingController textEditingController = TextEditingController();

    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Create new deck'),
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
              context.read<SubjectBloc>().add(
                    AddDeck(
                      name: textEditingController.text,
                      icon: EducationIcons.book_pen,
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

class DeckModify extends StatelessWidget {
  const DeckModify({super.key});

  @override
  Widget build(BuildContext context) {
    return AdaptableCard(
      questionController: TextEditingController(),
      answerController: TextEditingController(),
    );
  }
}
