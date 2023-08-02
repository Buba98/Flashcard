import 'package:flashcard/widget/flashcard_text_editing_controller/flashcard_text_editing_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/subject_bloc.dart';
import 'adaptable_card.dart';

class AdaptableCardHolder extends StatelessWidget {
  const AdaptableCardHolder({
    super.key,
    required this.flashcardTextEditingController,
    required this.index,
  });

  final FlashcardTextEditingController flashcardTextEditingController;
  final int index;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints boxConstraints) {
      if (boxConstraints.maxWidth > 600) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ReorderableDragStartListener(
              index: index,
              child: Container(
                color: Colors.transparent,
                child: Column(
                  children: [
                    Text(
                      '${index + 1}.',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    const Icon(
                      Icons.drag_handle,
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () => context
                          .read<SubjectBloc>()
                          .add(DeleteFlashcard(index: index)),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: AdaptableCard(
                flashcardTextEditingController: flashcardTextEditingController,
              ),
            ),
          ],
        );
      } else {
        return ReorderableDragStartListener(
          index: index,
          child: Container(
            color: Colors.transparent,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${index + 1}.',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      width: 8.0,
                    ),
                    const Icon(
                      Icons.drag_handle,
                    ),
                  ],
                ),
                const SizedBox(width: 16.0),
                AdaptableCard(
                  flashcardTextEditingController:
                      flashcardTextEditingController,
                ),
              ],
            ),
          ),
        );
      }
    });
  }
}
