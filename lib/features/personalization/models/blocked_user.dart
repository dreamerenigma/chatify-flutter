class BlockedUser {
  BlockedUser({
    required this.userImage,
    required this.phoneNumber,
  });
  late String userImage;
  late String phoneNumber;

  Map<String, dynamic> toMap() {
    return {
      'userImage': userImage,
      'phoneNumber': phoneNumber,
    };
  }

  BlockedUser.fromJson(Map<String, dynamic> json){
    userImage = json['userImage'] ?? '';
    phoneNumber = json['phoneNumber'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['userImage'] = userImage;
    data['phoneNumber'] = phoneNumber;
    return data;
  }
}
