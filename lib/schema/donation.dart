import 'dart:convert';

class Donation {
  final String food;
  final int quantity;
  final String image;
  final DateTime? donatedAt;
  final String? donor;
  final int? distance;
  final String? donationId;

  Donation({
    required this.food,
    required this.quantity,
    required this.image,
    this.donatedAt,
    this.donor,
    this.distance,
    this.donationId,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'food': food,
      'quantity': quantity,
      'image': image,
    };

    if (donatedAt != null) {
      map['donatedAt'] = donatedAt!.toIso8601String();
    }

    if (donationId != null) {
      map['donationId'] = donationId;
    }

    return map;
  }

  factory Donation.fromMap(Map<String, dynamic> map) {
    return Donation(
      food: map['food'] as String,
      quantity: map['quantity'] as int,
      image: map['image'] as String,
      donatedAt: map['donatedAt'] != null
          ? DateTime.parse(map['donatedAt'] as String)
          : null,
      donor: map['donor'] != null ? map['donor'] as String : null,
      distance: map['distance'] != null ? map['distance'] as int : null,
      donationId:
          map['donationId'] != null ? map['donationId'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Donation.fromJson(String source) =>
      Donation.fromMap(json.decode(source) as Map<String, dynamic>);
}
