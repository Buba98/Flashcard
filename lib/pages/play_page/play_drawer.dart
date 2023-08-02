
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/play_bloc.dart';
import '../../model/flashcard.dart';
import '../../widget/adaptable_stopwatch.dart';

class PlayDrawer extends StatelessWidget {
  const PlayDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlayBloc, PlayState>(
        builder: (BuildContext context, PlayState state) {
          return Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    if (state is Initialized)
                      for (final (bool?, Flashcard) element in state.flashcards)
                        IconButton(
                          onPressed: null,
                          icon: Icon(
                            Icons.circle,
                            color: element.$1 == null
                                ? Colors.grey
                                : element.$1!
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                  ],
                ),
              ),
              AdaptableStopwatch(
                stopwatch: state.stopwatch,
              ),
            ],
          );
        });
  }
}
