import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class DelivaryPosition {
  final String? name;
  final double? latitude;
  final double? longitude;
  final bool? getClose;
  final bool? finish;
  DelivaryPosition({
    this.name,
    this.latitude,
    this.longitude,
    this.getClose,
    this.finish,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'getClose': getClose,
      'finish': finish,
    };
  }

  factory DelivaryPosition.fromMap(Map<String, dynamic> map) {
    return DelivaryPosition(
      name: map['name'] != null ? map['name'] as String : null,
      latitude: map['latitude'] != null ? map['latitude'] as double : null,
      longitude: map['longitude'] != null ? map['longitude'] as double : null,
      getClose: map['getClose'] != null ? map['getClose'] as bool : false,
      finish: map['finish'] != null ? map['finish'] as bool : false,
    );
  }

  String toJson() => json.encode(toMap());

  factory DelivaryPosition.fromJson(String source) =>
      DelivaryPosition.fromMap(json.decode(source) as Map<String, dynamic>);
}
