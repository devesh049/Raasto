import 'package:flutter/widgets.dart';

/// A goods vehicle category the passenger can choose.
@immutable
class GoodsVehicle {
  const GoodsVehicle({
    required this.id,
    required this.name,
    required this.capacity,
    required this.basePrice,
    required this.icon,
  });

  final String id;
  final String name;
  final String capacity;
  final double basePrice;
  final IconData icon;
}

/// What the passenger wants to send.
@immutable
class GoodsRequest {
  const GoodsRequest({
    required this.from,
    required this.to,
    required this.date,
    required this.goodsType,
    required this.weightKg,
    this.vehicleId,
  });

  final String from;
  final String to;
  final DateTime date;
  final String goodsType;
  final int weightKg;

  /// Selected [GoodsVehicle.id], or `null` for any suitable vehicle.
  final String? vehicleId;
}

/// A transporter's quote for a [GoodsRequest].
@immutable
class GoodsQuote {
  const GoodsQuote({
    required this.id,
    required this.transporter,
    required this.vehicleName,
    required this.capacity,
    required this.rating,
    required this.price,
    required this.etaMinutes,
  });

  final String id;
  final String transporter;
  final String vehicleName;
  final String capacity;
  final double rating;
  final double price;
  final int etaMinutes;
}

/// Confirmed goods booking.
@immutable
class GoodsBooking {
  const GoodsBooking({
    required this.id,
    required this.request,
    required this.quote,
    required this.total,
    required this.createdAt,
  });

  final String id;
  final GoodsRequest request;
  final GoodsQuote quote;
  final double total;
  final DateTime createdAt;
}
