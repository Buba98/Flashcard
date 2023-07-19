import 'dart:convert';

import 'package:flashcard/model/flashcard.dart';
import 'package:flashcard/model/subject.dart';
import 'package:flashcard/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/deck.dart';

class LocalRepositoryService {
  final String _subjectsEntry = '__SUBJECTS__';

  static final LocalRepositoryService _singleton =
      LocalRepositoryService._internal();
  final Future<SharedPreferences> _sharedPreferences =
      SharedPreferences.getInstance();

  factory LocalRepositoryService() {
    return _singleton;
  }

  LocalRepositoryService._internal();

  /// REMOVE

  Future<void> removeSubject(Subject subject) async {
    assert(subject.id != null);
    assert(((await _sharedPreferences).getStringList(_subjectsEntry) ?? [])
        .contains(subject.id));

    for (Deck deck in subject.decks) {
      removeDeck(deck, subject);
    }

    (await _sharedPreferences).remove('_${subject.id!}');

    List<String> subjectIDs =
        (await _sharedPreferences).getStringList(_subjectsEntry) ?? [];

    assert(subjectIDs.contains(subject.id));

    subjectIDs.remove(subject.id);

    (await _sharedPreferences).setStringList(_subjectsEntry, subjectIDs);

    (await _sharedPreferences).remove(subject.id!);
  }

  Future<void> removeDeck(Deck deck, Subject subject) async {
    assert(deck.id != null);
    assert(subject.id != null);
    assert(((await _sharedPreferences).getStringList(_subjectsEntry) ?? [])
        .contains(subject.id));

    for (Flashcard flashcard in deck.flashcards) {
      removeFlashcard(flashcard, deck);
    }

    (await _sharedPreferences).remove('*${deck.id!}');

    List<String> deckIDs =
        (await _sharedPreferences).getStringList('_${subject.id}') ?? [];

    assert(deckIDs.contains(deck.id));

    deckIDs.remove(deck.id);

    (await _sharedPreferences).setStringList('_${subject.id}', deckIDs);

    (await _sharedPreferences).remove(deck.id!);
  }

  Future<void> removeFlashcard(Flashcard flashcard, Deck deck) async {
    assert(flashcard.id != null);
    assert(deck.id != null);

    List<String> flashcardIDs =
        (await _sharedPreferences).getStringList('*${deck.id}') ?? [];

    assert(flashcardIDs.contains(flashcard.id));

    flashcardIDs.remove(flashcard.id);

    (await _sharedPreferences).setStringList('_${flashcard.id}', flashcardIDs);

    (await _sharedPreferences).remove(flashcard.id!);
  }

  /// UPDATES
  Future<void> updateSubject(Subject subject) async {
    assert(subject.id != null);
    assert(((await _sharedPreferences).getStringList(_subjectsEntry) ?? [])
        .contains(subject.id));

    (await _sharedPreferences)
        .setString(subject.id!, jsonEncode(subject.toJsonIdFriendly()));
  }

  Future<void> updateDeck(Deck deck) async {
    assert(deck.id != null);
    assert(((await _sharedPreferences).getStringList(_subjectsEntry) ?? [])
        .contains(deck.id));

    (await _sharedPreferences)
        .setString(deck.id!, jsonEncode(deck.toJsonIdFriendly()));
  }

  Future<void> updateFlashcard(Flashcard flashcard) async {
    assert(flashcard.id != null);
    assert(((await _sharedPreferences).getStringList(_subjectsEntry) ?? [])
        .contains(flashcard.id));

    (await _sharedPreferences)
        .setString(flashcard.id!, jsonEncode(flashcard.toJsonIdFriendly()));
  }

  /// ADD NEW
  Future<Subject> addNewSubject({
    required String name,
    required IconData icon,
  }) async {
    List<String>? subjectIDs =
        (await _sharedPreferences).getStringList(_subjectsEntry) ?? [];

    String id;
    do {
      id = generateRandomString();
    } while (subjectIDs.contains(id));

    subjectIDs.add(id);

    (await _sharedPreferences).setStringList(_subjectsEntry, subjectIDs);

    Subject subject = Subject(
      id: id,
      name: name,
      decks: [],
      icon: icon,
    );

    (await _sharedPreferences)
        .setString(subject.id!, jsonEncode(subject.toJson()));

    return subject;
  }

  Future<Deck> addNewDeck({
    required String name,
    required IconData icon,
    required Subject subject,
  }) async {
    assert(subject.id != null);
    assert(((await _sharedPreferences).getStringList(_subjectsEntry) ?? [])
        .contains(subject.id));

    List<String>? deckIDs =
        (await _sharedPreferences).getStringList('_${subject.id}') ?? [];

    String id;
    do {
      id = generateRandomString();
    } while (deckIDs.contains(id));

    deckIDs.add(id);

    (await _sharedPreferences).setStringList('_${subject.id}', deckIDs);

    Deck deck = Deck(
      id: id,
      name: name,
      icon: icon,
      flashcards: [],
    );

    (await _sharedPreferences)
        .setString(deck.id!, jsonEncode(deck.toJsonIdFriendly()));

    return deck;
  }

  Future<Flashcard> addNewFlashcard({
    required String question,
    required String answer,
    required Deck deck,
  }) async {
    assert(deck.id != null);
    assert(((await _sharedPreferences).getStringList('*${deck.id}') ?? [])
        .contains(deck.id));

    List<String>? flashcardIDs =
        (await _sharedPreferences).getStringList('*${deck.id}') ?? [];

    String id;
    do {
      id = generateRandomString();
    } while (flashcardIDs.contains(id));

    flashcardIDs.add(id);

    (await _sharedPreferences).setStringList('*${deck.id}', flashcardIDs);

    Flashcard flashcard = Flashcard(
      id: id,
      question: question,
      answer: answer,
    );

    (await _sharedPreferences)
        .setString(flashcard.id!, jsonEncode(flashcard.toJson()));

    return flashcard;
  }

  /// GETTERS
  Future<Subject?> getSubject(String id) async {
    String? json = (await _sharedPreferences).getString(id);

    if (json == null) {
      return null;
    }

    Subject subject = Subject.fromJsonIdFriendly(jsonDecode(json));

    List<String> deckIDs =
        (await _sharedPreferences).getStringList('_$id') ?? [];

    for (String id in deckIDs) {
      Deck? deck = await getDeck(id);

      if (deck == null) {
        continue;
      }

      subject.decks.add(deck);
    }

    return subject;
  }

  Future<Deck?> getDeck(String id) async {
    String? json = (await _sharedPreferences).getString(id);

    if (json == null) {
      return null;
    }

    Deck deck = Deck.fromJsonIdFriendly(jsonDecode(json));

    List<String> flashcardIDs =
        (await _sharedPreferences).getStringList('*$id') ?? [];

    for (String id in flashcardIDs) {
      Flashcard? flashcard = await getFlashcard(id);

      if (flashcard == null) {
        continue;
      }

      deck.flashcards.add(flashcard);
    }

    return deck;
  }

  Future<Flashcard?> getFlashcard(String id) async {
    String? json = (await _sharedPreferences).getString(id);

    if (json == null) {
      return null;
    }

    return Flashcard.fromJson(jsonDecode(json));
  }

  Future<List<Subject>> getSubjects() async {
    List<String>? json =
        (await _sharedPreferences).getStringList(_subjectsEntry);

    if (json == null) {
      return [];
    }

    List<Subject> subjects = [];

    for (String id in json) {
      Subject? subject = await getSubject(id);

      if (subject == null) {
        continue;
      }

      subjects.add(subject);
    }

    return subjects;
  }
}
