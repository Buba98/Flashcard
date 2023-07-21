import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/subject_bloc.dart';
import '../../../model/deck.dart';
import '../../../model/flashcard.dart';
import '../../../widget/adaptable_card.dart';

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
        for (Flashcard flashcard in deck.flashcards) ...[
          AdaptableCard(
            questionController: TextEditingController(text: flashcard.question),
            answerController: TextEditingController(text: flashcard.answer),
          ),
          const SizedBox(height: 16.0),
        ],
        ListTile(
          leading: const Icon(Icons.add),
          title: const Text('Create new flashcard'),
          onTap: () => context.read<SubjectBloc>().add(AddFlashCard()),
        ),
      ],
    );
  }
}
