class BlockedUserModel {
  final String userId;
  late String userImage;
  late String phoneNumber;

  BlockedUserModel({
    required this.userId,
    required this.userImage,
    required this.phoneNumber,
  });

  factory BlockedUserModel.fromJson(Map<String, dynamic> json) {
    return BlockedUserModel(
      userId: json['userId'] ?? '',
      userImage: json['userImage'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'userImage': userImage,
      'phoneNumber': phoneNumber,
    };
  }
}
