class TestField {
  String question;
  Map<String, String> options;
  String answer;

  TestField(this.question, this.options, this.answer);

  Map<String, dynamic> toMap() {
    return {
      "question": question,
      "options": options,
      "answer": answer,
    };
  }

  factory TestField.fromJson(Map<String, dynamic> json) {
    return TestField(
      json["question"],
      Map.from(json["options"])
          .map((key, value) => MapEntry(key.toString(), value.toString())),
      json["answer"],
    );
  }
}
