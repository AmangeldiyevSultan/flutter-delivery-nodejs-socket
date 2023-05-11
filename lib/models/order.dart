// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:gooddelivary/models/delivary_position.dart';
import 'package:gooddelivary/models/product.dart';
import 'package:gooddelivary/models/reciever_location.dart';

class Order {
  final String id;
  final List<Product> products;
  final List<int> quantity;
  final RecieverLocation address;
  final String userId;
  final int orderedAt;
  final int status;
  final DelivaryPosition deliveryPosition;
  final double totalPrice;
  Order({
    required this.id,
    required this.products,
    required this.quantity,
    required this.address,
    required this.userId,
    required this.orderedAt,
    required this.status,
    required this.deliveryPosition,
    required this.totalPrice,
  });

  // Map<String, dynamic> toMap() {
  //   return <String, dynamic>{
  //     'id': id,
  //     'products': products.map((x) => x.toMap()).toList(),
  //     'quantity': quantity,
  //     'address': address,
  //     'userId': userId,
  //     'orderedAt': orderedAt,
  //     'status': status,
  //     'totalPrice': totalPrice,
  //   };
  // }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['_id'] ?? '',
      products: List<Product>.from(
          map['products']?.map((x) => Product.fromMap(x['product']))),
      quantity: List<int>.from(
        map['products']?.map(
          (x) => x['quantity'],
        ),
      ),
      address: RecieverLocation.fromMap(map['address'] as Map<String, dynamic>),
      deliveryPosition: DelivaryPosition.fromMap(
          map['delivaryPosition'] as Map<String, dynamic>),
      userId: map['userId'] ?? '',
      orderedAt: map['orderedAt']?.toInt() ?? 0,
      status: map['status']?.toInt() ?? 0,
      totalPrice: map['totalPrice']?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Order.fromJson(String source) =>
      Order.fromMap(json.decode(source) as Map<String, dynamic>);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'products': products.map((x) => x.toMap()).toList(),
      'quantity': quantity,
      'address': address.toMap(),
      'userId': userId,
      'orderedAt': orderedAt,
      'delivaryPosition': deliveryPosition,
      'status': status,
      'totalPrice': totalPrice,
    };
  }
}
