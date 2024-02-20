class MultiQuestion {
  final String? id;
  final String? question;
  final List<String>? choices;
  final String? rightAnswer;
  final int? level;
  String selectedOption = '';
  bool isButtonPressable = false;

  MultiQuestion(
      {required this.id,
      required this.question,
      required this.choices,
      required this.rightAnswer,
      required this.level});

  factory MultiQuestion.fromJson(Map<String, dynamic> json) {
    return MultiQuestion(
      id: json['_id'],
      question: json['question'],
      choices: List<String>.from(json['choices']),
      rightAnswer: json['rightAnswer'],
      level: json['level'],
    );
  }
}
