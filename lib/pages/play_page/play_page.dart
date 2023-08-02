import 'package:flashcard/bloc/play_bloc.dart';
import 'package:flashcard/pages/play_page/play_content.dart';
import 'package:flashcard/pages/play_page/play_drawer.dart';
import 'package:flashcard/widget/adaptable_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../model/deck.dart';
import '../../../model/subject.dart';

class PlayPage extends StatefulWidget {
  const PlayPage({
    super.key,
    required this.subject,
    required this.deck,
  });

  final Subject subject;
  final Deck deck;

  @override
  State<PlayPage> createState() => _PlayPageState();
}

class _PlayPageState extends State<PlayPage> {
  bool expanded = false;
  bool hiddenAnswer = true;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => PlayBloc(
        subject: widget.subject,
        deck: widget.deck,
      )..add(Play()),
      child: AdaptablePage(
        expanded: expanded,
        drawer: const PlayDrawer(),
        content: PlayContent(
          hiddenAnswer: hiddenAnswer,
          onHiddenAnswer: onHiddenAnswer,
        ),
        onExpand: onExpand,
        title: 'Play : ${widget.subject.name} - ${widget.deck.name}',
      ),
    );
  }

  onExpand() => setState(() => expanded = !expanded);

  onHiddenAnswer(bool hiddenAnswer) =>
      setState(() => this.hiddenAnswer = hiddenAnswer);
}
