import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class RecieverLocation {
  final String? placeInfo;
  final double? langitude;
  final double? longitude;
  final String? buidlingInfo;
  final String? pincode;
  final String? phoneNumber;
  RecieverLocation({
    this.placeInfo,
    this.langitude,
    this.longitude,
    this.buidlingInfo,
    this.pincode,
    this.phoneNumber,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'placeInfo': placeInfo,
      'langitude': langitude,
      'longitude': longitude,
      'buidlingInfo': buidlingInfo,
      'pincode': pincode,
      'phoneNumber': phoneNumber,
    };
  }

  factory RecieverLocation.fromMap(Map<String, dynamic> map) {
    return RecieverLocation(
      placeInfo: map['placeInfo'] != null ? map['placeInfo'] as String : null,
      langitude: map['langitude'] != null ? map['langitude'] as double : null,
      longitude: map['longitude'] != null ? map['longitude'] as double : null,
      buidlingInfo:
          map['buidlingInfo'] != null ? map['buidlingInfo'] as String : null,
      pincode: map['pincode'] != null ? map['pincode'] as String : null,
      phoneNumber:
          map['phoneNumber'] != null ? map['phoneNumber'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory RecieverLocation.fromJson(String source) =>
      RecieverLocation.fromMap(json.decode(source) as Map<String, dynamic>);
}
