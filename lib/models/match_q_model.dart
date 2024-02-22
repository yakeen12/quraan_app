class MatchQuestion {
  String id;
  Map<String, String> pairs;
  bool isButtonPressable = false;

  MatchQuestion({
    required this.id,
    required this.pairs,
  });

  factory MatchQuestion.fromJson(Map<String, dynamic> json) {
    return MatchQuestion(
      id: json['_id'],
      pairs: Map<String, String>.from(json['pairs']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'pairs': pairs,
    };
  }
}
