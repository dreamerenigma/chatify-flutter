class SurveyModel {
  final String question;
  final List<String> options;
  final bool allowMultipleAnswers;
  final Map<String, String> reactions;

  SurveyModel({
    required this.question,
    required this.options,
    required this.allowMultipleAnswers,
    this.reactions = const {},
  });

  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'options': options,
      'allowMultipleAnswers': allowMultipleAnswers,
      'reactions': reactions,
    };
  }

  factory SurveyModel.fromJson(Map<String, dynamic> json) {
    return SurveyModel(
      question: json['question'] ?? '',
      options: List<String>.from(json['options'] ?? []),
      allowMultipleAnswers: json['allowMultipleAnswers'] ?? false,
      reactions: json['reactions'] != null ? Map<String, String>.from(json['reactions']) : {},
    );
  }
}
