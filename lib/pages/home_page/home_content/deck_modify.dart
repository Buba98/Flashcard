import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/subject_bloc.dart';
import '../../../model/deck.dart';
import '../../../widget/adaptable_card/adaptable_card.dart';
import '../../../widget/auto_save_text_editing_controller.dart';

class DeckModify extends StatelessWidget {
  const DeckModify({
    super.key,
    required this.deck,
  });

  final Deck deck;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        for (int i = 0; i < deck.flashcards.length; i++) ...[
          AdaptableCard(
            index: i,
            autoSaveTextEditingController: AutoSaveTextEditingController(
              flashcard: deck.flashcards[i],
              subjectBloc: context.read<SubjectBloc>(),
            ),
          ),
          const SizedBox(height: 16.0),
        ],
        ListTile(
          leading: const Icon(Icons.add),
          title: const Text('Create new flashcard'),
          onTap: () => context.read<SubjectBloc>().add(AddFlashcard()),
        ),
      ],
    );
  }
}
