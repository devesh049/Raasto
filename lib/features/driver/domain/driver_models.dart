import 'package:flutter/foundation.dart';

/// A ride a driver has published to share empty seats.
@immutable
class PublishedRide {
  const PublishedRide({
    required this.id,
    required this.from,
    required this.to,
    required this.departure,
    required this.seats,
    required this.pricePerSeat,
    required this.vehicleModel,
    required this.plate,
  });

  final String id;
  final String from;
  final String to;
  final DateTime departure;
  final int seats;
  final double pricePerSeat;
  final String vehicleModel;
  final String plate;

  double get potentialEarnings => seats * pricePerSeat;
}
