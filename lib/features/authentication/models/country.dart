class Country {
  final String code;
  final String alphaCode;
  final String name;
  final String nativeName;
  final String flag;

  Country(
    this.code,
    this.alphaCode,
    this.name,
    this.nativeName,
    this.flag,
  );

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'alphaCode': alphaCode,
      'name': name,
      'nativeName': nativeName,
      'flag': flag,
    };
  }

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      json['code'] as String? ?? '',
      json['alphaCode'] as String? ?? '',
      json['name'] as String? ?? '',
      json['nativeName'] as String? ?? '',
      json['flag'] as String? ?? '',
    );
  }
}
