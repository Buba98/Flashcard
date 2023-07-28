import 'package:flutter/material.dart';

import '../exceptions/invalid_json.dart';
import '../utils.dart';
import 'deck.dart';

class Subject implements Comparable<Subject> {
  final String id;
  final String name;
  final List<Deck> decks;
  final IconData icon;

  Subject({
    required this.id,
    required this.name,
    required this.decks,
    required this.icon,
  });

  static Subject fromJson(Map<String, dynamic> json) {
    if (json['name'] == null ||
        json['name'] is! String ||
        json['decks'] == null ||
        json['decks'] is! List ||
        json['icon'] == null ||
        json['icon'] is! Map<String, dynamic>) {
      throw InvalidJson(
          json,
          'Subject:{'
          ' "id": String?,'
          ' "name": String,'
          ' "decks": List<Deck>,'
          ' "icon": IconData'
          '}');
    }
    final List<Deck> decks = [];
    for (final deck in json['decks']) {
      final Deck deckObj = Deck.fromJson(deck);
      decks.add(deckObj);
    }
    return Subject(
      id: json['id'],
      name: json['name'],
      decks: decks,
      icon: iconDataFromJson(
        json['icon'],
      ),
    );
  }

  static Subject fromJsonIdFriendly(Map<String, dynamic> json) {
    json['decks'] = [];

    return fromJson(json);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['decks'] = decks.map((deck) => deck.toJson()).toList();
    data['name'] = name;
    data['icon'] = iconDataToJson(icon);
    data['id'] = id;
    return data;
  }

  Map<String, dynamic> toJsonIdFriendly() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['icon'] = iconDataToJson(icon);
    return data;
  }

  @override
  int compareTo(Subject other) {
    return name.compareTo(other.name);
  }

  @override
  String toString() {
    return toJson().toString();
  }
}
