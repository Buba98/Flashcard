import 'package:flashcard/widget/flashcard_text_editing_controller/flashcard_text_editing_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/subject_bloc.dart';
import 'adaptable_card.dart';

class AdaptableCardHolder extends StatefulWidget {
  const AdaptableCardHolder({
    super.key,
    required this.flashcardTextEditingController,
    required this.index,
    required this.visualize,
  });

  final FlashcardTextEditingController flashcardTextEditingController;
  final int index;
  final bool visualize;

  @override
  State<AdaptableCardHolder> createState() => _AdaptableCardHolderState();
}

class _AdaptableCardHolderState extends State<AdaptableCardHolder> {
  late bool visualize = widget.visualize;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints boxConstraints) {
      if (boxConstraints.maxWidth > 600) {
        return ReorderableDragStartListener(
          index: widget.index,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                color: Colors.transparent,
                child: FlexCardHolderOptions(
                  index: widget.index,
                  direction: Axis.vertical,
                  onEdit: onEdit,
                  visualize: visualize,
                  defaultVisualize: widget.visualize,
                ),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: AdaptableCard(
                  readOnly: visualize,
                  flashcardTextEditingController:
                      widget.flashcardTextEditingController,
                ),
              ),
            ],
          ),
        );
      } else {
        return ReorderableDragStartListener(
          index: widget.index,
          child: Container(
            color: Colors.transparent,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FlexCardHolderOptions(
                  index: widget.index,
                  direction: Axis.horizontal,
                  onEdit: onEdit,
                  visualize: visualize,
                  defaultVisualize: widget.visualize,
                ),
                const SizedBox(width: 16.0),
                AdaptableCard(
                  readOnly: widget.visualize,
                  flashcardTextEditingController:
                      widget.flashcardTextEditingController,
                ),
              ],
            ),
          ),
        );
      }
    });
  }

  void onEdit() {
    setState(() => visualize = !visualize);
  }
}

class FlexCardHolderOptions extends StatelessWidget {
  const FlexCardHolderOptions({
    super.key,
    required this.index,
    required this.direction,
    required this.onEdit,
    required this.visualize,
    required this.defaultVisualize,
  });

  final int index;
  final Axis direction;
  final Function() onEdit;
  final bool visualize;
  final bool defaultVisualize;

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: direction,
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
          height: 8.0,
        ),
        const Icon(
          Icons.drag_handle,
        ),
        const SizedBox(
          height: 8.0,
        ),
        IconButton(
          icon:
              Icon(defaultVisualize ? Icons.visibility_outlined : Icons.edit_outlined),
          isSelected: visualize != defaultVisualize,
          onPressed: onEdit,
        ),
        const SizedBox(
          height: 8.0,
        ),
        IconButton(
          icon: const Icon(Icons.delete_outline),
          onPressed: () =>
              context.read<SubjectBloc>().add(DeleteFlashcard(index: index)),
        ),
      ],
    );
  }
}
