import 'package:flashcard/exceptions/invalid_json.dart';

/// Model class for Flashcard
/// A flashcard is a question and answer pair
class Flashcard {
  final String? id;
  final String question;
  final String answer;

  Flashcard({
    this.id,
    required this.question,
    required this.answer,
  });

  static fromJson(Map<String, dynamic> json) {
    if (json['question'] == null ||
        json['question'] is! String ||
        json['answer'] == null ||
        json['answer'] is! String) {
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
    );
  }

  static Flashcard? fromJsonSafe(Map<String, dynamic> json) {
    try {
      return fromJson(json);
    } on InvalidJson {
      return null;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['question'] = question;
    data['answer'] = answer;
    return data;
  }

  Map<String, dynamic> toJsonIdFriendly() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['question'] = question;
    data['answer'] = answer;
    return data;
  }
}
