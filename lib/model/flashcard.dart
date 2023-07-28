import 'package:flashcard/exceptions/invalid_json.dart';

/// Model class for Flashcard
/// A flashcard is a question and answer pair
class Flashcard implements Comparable<Flashcard>{
  final String id;
  final String question;
  final String answer;
  final int index;

  Flashcard({
    required this.id,
    required this.question,
    required this.answer,
    required this.index,
  });

  static Flashcard fromJson(Map<String, dynamic> json) {
    if (json['question'] == null ||
        json['question'] is! String ||
        json['answer'] == null ||
        json['answer'] is! String ||
        json['index'] == null ||
        json['index'] is! int) {
      throw InvalidJson(
          json,
          'Flashcard:{'
          ' "id": String?,'
          ' "name": String,'
          ' "question": String'
          '}');
    }
    return Flashcard(
      id: json['id'],
      question: json['question'],
      answer: json['answer'],
      index: json['index'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['question'] = question;
    data['answer'] = answer;
    data['index'] = index;
    return data;
  }

  Map<String, dynamic> toJsonIdFriendly() {
    return toJson();
  }

  @override
  int compareTo(Flashcard other) {
    return index.compareTo(other.index);
  }

  @override
  String toString() {
    return toJson().toString();
  }
}
