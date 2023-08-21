import 'package:flashcard/model/flashcard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/play_bloc.dart';
import '../../widget/adaptable_card/adaptable_card.dart';
import '../../widget/flashcard_text_editing_controller/flashcard_text_editing_controller.dart';

class PlayContent extends StatefulWidget {
  const PlayContent({
    super.key,
    required this.hiddenAnswer,
    required this.onHiddenAnswer,
  });

  final bool hiddenAnswer;
  final Function(bool) onHiddenAnswer;

  @override
  State<PlayContent> createState() => _PlayContentState();
}

class _PlayContentState extends State<PlayContent> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: BlocBuilder<PlayBloc, PlayState>(
          builder: (BuildContext context, PlayState state) {
        if (state is Playing) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: AdaptableCard(
                  readOnly: true,
                  hiddenAnswer: widget.hiddenAnswer,
                  flashcardTextEditingController:
                      FlashcardTextEditingController(
                    flashcard: state.nextFlashcard,
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              if (widget.hiddenAnswer)
                ElevatedButton(
                  onPressed: () => widget.onHiddenAnswer(false),
                  child: const Text(
                    'Reveal answer',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              if (!widget.hiddenAnswer)
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          widget.onHiddenAnswer(true);
                          context.read<PlayBloc>().add(Answer(correct: true));
                        },
                        child: const Text(
                          'Correct',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          widget.onHiddenAnswer(true);
                          context.read<PlayBloc>().add(
                                Answer(correct: false),
                              );
                        },
                        child: const Text(
                          'Wrong',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          );
        }
        if (state is Finished) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Finished!',
                  style: TextStyle(
                    fontSize: 40.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16.0),
                Text(
                  'Correct: ${state.flashcards.fold<int>(0, (previousValue, (
                        bool?,
                        Flashcard
                      ) element) => element.$1 ?? false ? previousValue + 1 : previousValue)}',
                  style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 16.0),
                Text(
                  'Wrong: ${state.flashcards.fold<int>(0, (previousValue, (
                        bool?,
                        Flashcard
                      ) element) => element.$1 ?? false ? previousValue : previousValue + 1)}',
                  style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () => context.read<PlayBloc>().add(Play()),
                  child: const Text(
                    'Play again',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        return const SizedBox();
      }),
    );
  }
}
