import 'package:flutter/material.dart';

class AdaptableButton extends StatelessWidget {
  final bool expanded;
  final Function onPressed;
  final IconData icon;
  final String title;
  final IconData? iconExpanded;
  final String? titleExpanded;
  final bool selected;

  const AdaptableButton({
    super.key,
    required this.expanded,
    required this.onPressed,
    required this.icon,
    required this.title,
    this.iconExpanded,
    this.titleExpanded,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: expanded
          ? ListTile(
              selectedTileColor: Colors.black12,
              onTap: () => onPressed(),
              leading: Icon(iconExpanded ?? icon),
              title: Text(titleExpanded ?? title),
              selected: selected,
            )
          : Tooltip(
              message: title,
              child: ListTile(
                selectedTileColor: Colors.black12,
                title: Icon(icon),
                onTap: () => onPressed(),
                selected: selected,
              ),
            ),
    );
  }
}
