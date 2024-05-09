// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Donation {
  final String food;
  final int quantity;
  final String image;

  Donation({required this.food, required this.quantity, required this.image});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'food': food,
      'quantity': quantity,
      'image': image,
    };
  }

  factory Donation.fromMap(Map<String, dynamic> map) {
    return Donation(
      food: map['food'] as String,
      quantity: map['quantity'] as int,
      image: map['image'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Donation.fromJson(String source) =>
      Donation.fromMap(json.decode(source) as Map<String, dynamic>);
}
