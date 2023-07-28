import 'package:flashcard/utils.dart';
import 'package:flutter/material.dart';

import '../exceptions/invalid_json.dart';
import 'flashcard.dart';

/// Model class for Deck
/// A deck is a collection of flashcards
/// It should contain all the flashcards for a particular topic of a subject
class Deck implements Comparable<Deck> {
  final String id;
  final List<Flashcard> flashcards;
  final String name;
  final IconData icon;

  Deck({
    required this.id,
    required this.name,
    required this.icon,
    required this.flashcards,
  });

  static Deck fromJson(Map<String, dynamic> json) {
    if (json['name'] == null ||
        json['name'] is! String ||
        json['flashcards'] == null ||
        json['flashcards'] is! List ||
        json['icon'] == null ||
        json['icon'] is! Map<String, dynamic>) {
      throw InvalidJson(
          json,
          'Deck:{'
          ' "id": String?,'
          ' "name": String,'
          ' "flashcards": List<Flashcard>'
          ' "icon": IconData'
          '}');
    }
    final List<Flashcard> flashcards = [];
    for (final flashcard in json['flashcards']) {
      final Flashcard flashcardObj = Flashcard.fromJson(flashcard);
      flashcards.add(flashcardObj);
    }
    return Deck(
      id: json['id'],
      name: json['name'],
      flashcards: flashcards,
      icon: iconDataFromJson(json['icon']),
    );
  }

  static Deck fromJsonIdFriendly(Map<String, dynamic> json) {
    json['flashcards'] = [];
    return fromJson(json);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['flashcards'] =
        flashcards.map((flashcard) => flashcard.toJson()).toList();
    data['name'] = name;
    data['icon'] = iconDataToJson(icon);
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
  int compareTo(Deck other) {
    return name.compareTo(other.name);
  }

  @override
  String toString() {
    return toJson().toString();
  }
}
