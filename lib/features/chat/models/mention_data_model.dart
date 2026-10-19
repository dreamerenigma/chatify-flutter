class MentionDataModel {
  final String userId;
  final String text;
  final int start;
  final int end;

  const MentionDataModel({
    required this.userId,
    required this.text,
    required this.start,
    required this.end,
  });

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'text': text,
      'start': start,
      'end': end,
    };
  }

  factory MentionDataModel.fromJson(Map<String, dynamic> json) {
    return MentionDataModel(
      userId: (json['user_id'] ?? json['userId'] ?? '').toString(),
      text: (json['text'] ?? '').toString(),
      start: (json['start'] as num?)?.toInt() ?? 0,
      end: (json['end'] as num?)?.toInt() ?? 0,
    );
  }
}
