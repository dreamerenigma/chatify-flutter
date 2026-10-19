class LocationModel {
  double latitude;
  double longitude;
  String name;
  String address;
  String city;
  String district;

  LocationModel({
    required this.latitude,
    required this.longitude,
    this.name = '',
    this.address = '',
    this.city = '',
    this.district = '',
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      city: json['city'] as String? ?? '',
      district: json['district'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'name': name,
      'address': address,
      'city': city,
      'district': district,
    };
  }
}
