import 'dart:convert';

import 'package:flashcard/model/flashcard.dart';
import 'package:flashcard/model/subject.dart';
import 'package:flashcard/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/deck.dart';

/// The entry __SUBJECTS__ contains a list of all the subjects
/// The entry _<subject.id> contains a list of all the decks in that subject
/// The entry *<deck.id> contains a list of all the flashcards in that deck
class LocalRepositoryService {
  static const String _subjectsEntry = '__SUBJECTS__';

  static final Future<SharedPreferences> _sharedPreferences =
      SharedPreferences.getInstance();

  ///METHODS FOR DEBUGGING

  ///GENERIC

  static Future<void> clear() async {
    debugPrint('CLEARING MEMORY');

    (await _sharedPreferences).clear();
  }

  static Future<void> debug() async {
    debugPrint('DEBUG START');

    for (String key in (await _sharedPreferences).getKeys()) {
      debugPrint('$key - ${(await _sharedPreferences).get(key)}');
    }

    debugPrint('DEBUG END');
  }

  static Future<void> remove(String key) async {
    debugPrint('REMOVING $key');
    (await _sharedPreferences).remove(key);
  }

  ///LIST STRING
  static Future<List<String>?> getStringList(String key) async {
    debugPrint('GETTING STRING LIST $key');

    List<String>? stringList = (await _sharedPreferences).getStringList(key);

    debugPrint(stringList.toString());

    return stringList;
  }

  static Future<void> setStringList(String key, List<String> value) async {
    debugPrint('SETTING STRING LIST $key');
    debugPrint(value.toString());
    (await _sharedPreferences).setStringList(key, value);
  }

  ///STRING

  static Future<String?> getString(String key) async {
    debugPrint('GETTING STRING LIST $key');

    String? string = (await _sharedPreferences).getString(key);

    debugPrint(string);

    return string;
  }

  static Future<void> setString(String key, String value) async {
    debugPrint('SETTING STRING $key');
    debugPrint(value);
    (await _sharedPreferences).setString(key, value);
  }

  /// REMOVE

  static Future<void> removeSubject(Subject subject) async {
    assert((await getStringList(_subjectsEntry) ?? []).contains(subject.id));

    for (Deck deck in subject.decks) {
      await removeDeck(deck, subject);
    }

    await remove('_${subject.id}');

    List<String> subjectIDs = await getStringList(_subjectsEntry) ?? [];

    assert(subjectIDs.contains(subject.id));

    subjectIDs.remove(subject.id);

    await setStringList(_subjectsEntry, subjectIDs);

    await remove(subject.id);
  }

  static Future<void> removeDeck(Deck deck, Subject subject) async {
    assert((await getStringList(_subjectsEntry) ?? []).contains(subject.id));

    for (Flashcard flashcard in deck.flashcards) {
      await removeFlashcard(flashcard, deck);
    }

    await remove('*${deck.id}');

    List<String> deckIDs = await getStringList('_${subject.id}') ?? [];

    assert(deckIDs.contains(deck.id));

    deckIDs.remove(deck.id);

    await setStringList('_${subject.id}', deckIDs);

    await remove(deck.id);
  }

  static Future<void> removeFlashcard(Flashcard flashcard, Deck deck) async {
    List<String> flashcardIDs = await getStringList('*${deck.id}') ?? [];

    assert(flashcardIDs.contains(flashcard.id));

    flashcardIDs.remove(flashcard.id);

    await setStringList('*${deck.id}', flashcardIDs);

    await remove(flashcard.id);
  }

  /// UPDATES
  static Future<Subject> updateSubject({
    required Subject subject,
    String? name,
    IconData? icon,
  }) async {

    assert(name != null || icon != null);

    Subject updatedSubject = Subject(
      id: subject.id,
      name: name ?? subject.name,
      icon: icon ?? subject.icon,
      decks: subject.decks,
    );

    await setString(subject.id, jsonEncode(updatedSubject.toJsonIdFriendly()));

    return updatedSubject;
  }

  static Future<Deck> updateDeck({
    required Deck deck,
    String? name,
    IconData? icon,
  }) async {
    assert(name != null || icon != null);

    Deck updatedDeck = Deck(
      id: deck.id,
      name: name ?? deck.name,
      icon: icon ?? deck.icon,
      flashcards: deck.flashcards,
    );

    await setString(updatedDeck.id, jsonEncode(updatedDeck.toJsonIdFriendly()));

    return updatedDeck;
  }

  static Future<Flashcard> updateFlashcard({
    required Flashcard flashcard,
    String? question,
    String? answer,
    int? index,
  }) async {
    assert(question != null || answer != null || index != null);

    Flashcard updatedFlashcard = Flashcard(
        id: flashcard.id,
        question: question ?? flashcard.question,
        answer: answer ?? flashcard.answer,
        index: index ?? flashcard.index);

    await setString(
      updatedFlashcard.id,
      jsonEncode(updatedFlashcard.toJsonIdFriendly()),
    );

    return updatedFlashcard;
  }

  /// ADD NEW
  static Future<Subject> addNewSubject({
    required String name,
    required IconData icon,
  }) async {
    List<String>? subjectIDs = await getStringList(_subjectsEntry) ?? [];

    String id;
    do {
      id = generateRandomString();
    } while (subjectIDs.contains(id));

    subjectIDs.add(id);

    await setStringList(_subjectsEntry, subjectIDs);

    Subject subject = Subject(
      id: id,
      name: name,
      decks: [],
      icon: icon,
    );

    await setString(subject.id, jsonEncode(subject.toJsonIdFriendly()));

    return subject;
  }

  static Future<Deck> addNewDeck({
    required String name,
    required IconData icon,
    required Subject subject,
  }) async {
    assert((await getStringList(_subjectsEntry) ?? []).contains(subject.id));

    List<String>? deckIDs = await getStringList('_${subject.id}') ?? [];

    String id;
    do {
      id = generateRandomString();
    } while (deckIDs.contains(id));

    deckIDs.add(id);

    await setStringList('_${subject.id}', deckIDs);

    Deck deck = Deck(
      id: id,
      name: name,
      icon: icon,
      flashcards: [],
    );

    await setString(deck.id, jsonEncode(deck.toJsonIdFriendly()));

    return deck;
  }

  static Future<Flashcard> addNewFlashcard({
    required String question,
    required String answer,
    required int index,
    required Deck deck,
  }) async {
    List<String>? flashcardIDs = await getStringList('*${deck.id}') ?? [];

    String id;
    do {
      id = generateRandomString();
    } while (flashcardIDs.contains(id));

    flashcardIDs.add(id);

    await setStringList('*${deck.id}', flashcardIDs);

    Flashcard flashcard = Flashcard(
      id: id,
      question: question,
      answer: answer,
      index: index,
    );

    await setString(flashcard.id, jsonEncode(flashcard.toJson()));

    return flashcard;
  }

  /// GETTERS
  static Future<Subject?> getSubject(String id) async {
    String? json = await getString(id);

    if (json == null) {
      return null;
    }

    Subject subject = Subject.fromJsonIdFriendly(jsonDecode(json));

    List<String> deckIDs = await getStringList('_$id') ?? [];

    for (String id in deckIDs) {
      Deck? deck = await getDeck(id);

      if (deck == null) {
        continue;
      }

      subject.decks.add(deck);
    }

    return subject;
  }

  static Future<Deck?> getDeck(String id) async {
    String? json = await getString(id);

    if (json == null) {
      return null;
    }

    Deck deck = Deck.fromJsonIdFriendly(jsonDecode(json));

    List<String> flashcardIDs = await getStringList('*$id') ?? [];

    for (String id in flashcardIDs) {
      Flashcard? flashcard = await getFlashcard(id);

      if (flashcard == null) {
        continue;
      }

      deck.flashcards.add(flashcard);
    }

    return deck;
  }

  static Future<Flashcard?> getFlashcard(String id) async {
    String? json = await getString(id);

    if (json == null) {
      return null;
    }

    return Flashcard.fromJson(jsonDecode(json));
  }

  static Future<List<Subject>> getSubjects() async {
    List<String>? json = await getStringList(_subjectsEntry);

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
