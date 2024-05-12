// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Order {
  // ignore: non_constant_identifier_names
  final String donor_id;
  // ignore: non_constant_identifier_names
  final String receiver_id;
  final String food;
  final String image;
  final String status;
  final String id;
  final DateTime date;
  final int quantity;

  Order({
    // ignore: non_constant_identifier_names
    required this.donor_id,
    // ignore: non_constant_identifier_names
    required this.receiver_id,
    required this.food,
    required this.image,
    required this.status,
    required this.id,
    required this.date,
    required this.quantity,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'donor_id': donor_id,
      'receiver_id': receiver_id,
      'food': food,
      'image': image,
      'status': status,
      'id': id,
      'date': date.toIso8601String(),
      'quantity': quantity,
    };
    return map;
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      donor_id: map['donor_id'] as String,
      receiver_id: map['receiver_id'] as String,
      food: map['food'] as String,
      image: map['image'] as String,
      status: map['status'] as String,
      id: map['id'] as String,
      date: DateTime.parse(map['date'] as String),
      quantity: map['quantity'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Order.fromJson(String source) =>
      Order.fromMap(json.decode(source) as Map<String, dynamic>);
}
