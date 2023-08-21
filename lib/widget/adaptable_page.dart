import 'package:flutter/material.dart';

import 'adaptable_button.dart';

class AdaptablePage extends StatelessWidget {
  const AdaptablePage({
    super.key,
    required this.expanded,
    required this.drawer,
    required this.content,
    required this.onExpand,
    required this.title,
    this.actions,
  });

  final bool expanded;
  final Widget drawer;
  final Widget content;
  final Function() onExpand;
  final String title;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return MediaQuery.of(context).size.width > 600
        ? DesktopPage(
            expanded: expanded,
            drawer: drawer,
            content: content,
            onExpand: onExpand,
            title: title,
            actions: actions,
          )
        : MobilePage(
            expanded: expanded,
            drawer: drawer,
            content: content,
            onExpand: onExpand,
            title: title,
            actions: actions,
          );
  }
}

class DesktopPage extends StatelessWidget {
  const DesktopPage({
    super.key,
    required this.expanded,
    required this.drawer,
    required this.content,
    required this.onExpand,
    required this.title,
    this.actions,
  });

  final bool expanded;
  final Widget drawer;
  final Widget content;
  final Function() onExpand;
  final String title;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: <Widget>[
            SizedBox(
              width: expanded ? 250 : 100,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    AdaptableButton(
                      expanded: expanded,
                      onPressed: onExpand,
                      icon: expanded
                          ? Icons.keyboard_double_arrow_left
                          : Icons.keyboard_double_arrow_right,
                      title: expanded ? 'Collapse' : 'Expand',
                    ),
                    const Divider(),
                    Expanded(
                      child: drawer,
                    )
                  ],
                ),
              ),
            ),
            const VerticalDivider(
              thickness: 1,
              width: 1,
            ),
            // This is the main content.
            Expanded(
              child: Scaffold(
                appBar: AppBar(
                  title: Text(title),
                  actions: actions,
                ),
                body: content,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class MobilePage extends StatelessWidget {
  const MobilePage({
    super.key,
    required this.expanded,
    required this.drawer,
    required this.content,
    required this.onExpand,
    required this.title,
    this.actions,
  });

  final bool expanded;
  final Widget drawer;
  final Widget content;
  final Function() onExpand;
  final String title;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (Navigator.of(context).canPop()) ...[
              AdaptableButton(
                onPressed: () => Navigator.of(context).maybePop(),
                title: 'Back',
                icon: Icons.arrow_back,
                expanded: false,
              ),
              const SizedBox(width: 8),
            ],
            Text(title),
          ],
        ),
        actions: actions,
        leading: AdaptableButton(
          onPressed: onExpand,
          title: expanded ? 'Collapse' : 'Expand',
          icon: expanded
              ? Icons.keyboard_double_arrow_left
              : Icons.keyboard_double_arrow_right,
          expanded: false,
        ),
      ),
      body: expanded
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: drawer,
            )
          : content,
    );
  }
}
