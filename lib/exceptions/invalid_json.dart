class InvalidJson implements Exception {
  Object source;
  String pattern;

  InvalidJson(this.source, this.pattern);

  @override
  String toString() {
    return "Invalid JSON format.\nExpected:\n$pattern\ngot:\n$source";
  }
}
