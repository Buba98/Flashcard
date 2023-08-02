import 'dart:math';

import 'package:flutter/cupertino.dart';

Map<String, dynamic> iconDataToJson(IconData iconData) {
  Map<String, dynamic> json = {};

  json['codePoint'] = iconData.codePoint;
  json['fontFamily'] = iconData.fontFamily;
  json['fontPackage'] = iconData.fontPackage;
  json['matchTextDirection'] = iconData.matchTextDirection;

  return json;
}

IconData iconDataFromJson(Map<String, dynamic> json) {
  return IconData(
    json['codePoint'],
    fontFamily: json['fontFamily'],
    fontPackage: json['fontPackage'],
    matchTextDirection: json['matchTextDirection'],
  );
}

String generateRandomString({int length = 8}) {
  final Random random = Random();
  const String availableChars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  final String randomString = List.generate(length,
      (index) => availableChars[random.nextInt(availableChars.length)]).join();

  return randomString;
}
