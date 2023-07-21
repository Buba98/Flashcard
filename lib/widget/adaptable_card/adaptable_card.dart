import 'package:flashcard/widget/auto_save_text_editing_controller.dart';
import 'package:flutter/material.dart';

import 'card_text_field.dart';

class AdaptableCard extends StatelessWidget {
  const AdaptableCard({
    super.key,
    required this.autoSaveTextEditingController,
    required this.index,
  });

  final AutoSaveTextEditingController autoSaveTextEditingController;
  final int index;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints boxConstraints) {
      if (boxConstraints.maxWidth > 600) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${index + 1}.',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: _ActualCard(
                expanded: true,
                autoSaveTextEditingController: autoSaveTextEditingController,
              ),
            ),
          ],
        );
      } else {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '${index + 1}.',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 16.0),
            _ActualCard(
              expanded: false,
              autoSaveTextEditingController: autoSaveTextEditingController,
            ),
          ],
        );
      }
    });
  }
}

class _ActualCard extends StatelessWidget {
  const _ActualCard({
    required this.autoSaveTextEditingController,
    required this.expanded,
  });

  final AutoSaveTextEditingController autoSaveTextEditingController;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: expanded
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: CardTextField.question(
                        controller:
                            autoSaveTextEditingController.questionController,
                      ),
                    ),
                    const VerticalDivider(),
                    Expanded(
                      child: CardTextField.answer(
                        controller:
                            autoSaveTextEditingController.answerController,
                      ),
                    ),
                  ],
                )
              : Column(
                  children: [
                    CardTextField.question(
                      controller:
                          autoSaveTextEditingController.questionController,
                    ),
                    const Divider(),
                    CardTextField.answer(
                      controller:
                          autoSaveTextEditingController.answerController,
                    ),
                  ],
                )),
    );
  }
}
