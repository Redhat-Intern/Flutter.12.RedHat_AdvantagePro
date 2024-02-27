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
}
