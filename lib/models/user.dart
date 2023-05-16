// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class User {
  final String id;
  final String name;
  final String email;
  final String password;
  final String address;
  final String type;
  // ignore: non_constant_identifier_names
  final String FCMToken;
  final String token;
  final List<dynamic> cart;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.address,
    required this.type,
    // ignore: non_constant_identifier_names
    required this.FCMToken,
    required this.token,
    required this.cart,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'password': password,
      'address': address,
      'type': type,
      'FCMToken': FCMToken,
      'token': token,
      'cart': cart,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map["_id"] ?? '',
      email: map["email"] ?? '',
      name: map["name"] ?? '',
      password: map["password"] ?? '',
      address: map["address"] ?? '',
      type: map["type"] ?? '',
      FCMToken: map["FCMToken"] ?? '',
      token: map["token"] ?? '',
      cart: List<Map<String, dynamic>>.from(
          map["cart"]?.map((x) => Map<String, dynamic>.from(x))),
    );
  }

  String toJson() => jsonEncode(toMap());

  factory User.fromJson(String source) => User.fromMap(jsonDecode(source));

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? password,
    String? address,
    String? type,
    // ignore: non_constant_identifier_names
    String? FCMToken,
    String? token,
    List<dynamic>? cart,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      address: address ?? this.address,
      type: type ?? this.type,
      FCMToken: FCMToken ?? this.FCMToken,
      token: token ?? this.token,
      cart: cart ?? this.cart,
    );
  }
}
