import 'package:flutter/foundation.dart';

/// Immutable snapshot of what the passenger searched for.
@immutable
class SearchQuery {
  const SearchQuery({
    required this.from,
    required this.to,
    required this.date,
    this.passengers = 1,
    this.vehicleType,
  });

  final String from;
  final String to;
  final DateTime date;
  final int passengers;

  /// Raw English vehicle key (`Car`, `SUV`, `Auto`, `Bike`) or `null` for any.
  final String? vehicleType;
}

@immutable
class Driver {
  const Driver({
    required this.name,
    required this.rating,
    required this.trips,
    required this.verified,
  });

  final String name;
  final double rating;
  final int trips;
  final bool verified;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'name': name,
        'rating': rating,
        'trips': trips,
        'verified': verified,
      };

  factory Driver.fromJson(Map<String, dynamic> json) => Driver(
        name: json['name'] as String,
        rating: (json['rating'] as num).toDouble(),
        trips: (json['trips'] as num).toInt(),
        verified: json['verified'] as bool,
      );
}

@immutable
class Ride {
  const Ride({
    required this.id,
    required this.driver,
    required this.vehicleModel,
    required this.vehicleType,
    required this.plate,
    required this.from,
    required this.to,
    required this.departure,
    required this.duration,
    required this.seatsAvailable,
    required this.pricePerSeat,
    required this.ac,
    required this.amenities,
    required this.pickupPoints,
    required this.dropPoints,
  });

  final String id;
  final Driver driver;
  final String vehicleModel;
  final String vehicleType;
  final String plate;
  final String from;
  final String to;
  final DateTime departure;
  final Duration duration;
  final int seatsAvailable;
  final double pricePerSeat;
  final bool ac;
  final List<String> amenities;
  final List<String> pickupPoints;
  final List<String> dropPoints;

  DateTime get arrival => departure.add(duration);

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'driver': driver.toJson(),
        'vehicleModel': vehicleModel,
        'vehicleType': vehicleType,
        'plate': plate,
        'from': from,
        'to': to,
        'departure': departure.toIso8601String(),
        'durationMinutes': duration.inMinutes,
        'seatsAvailable': seatsAvailable,
        'pricePerSeat': pricePerSeat,
        'ac': ac,
        'amenities': amenities,
        'pickupPoints': pickupPoints,
        'dropPoints': dropPoints,
      };

  factory Ride.fromJson(Map<String, dynamic> json) => Ride(
        id: json['id'] as String,
        driver: Driver.fromJson(json['driver'] as Map<String, dynamic>),
        vehicleModel: json['vehicleModel'] as String,
        vehicleType: json['vehicleType'] as String,
        plate: json['plate'] as String,
        from: json['from'] as String,
        to: json['to'] as String,
        departure: DateTime.parse(json['departure'] as String),
        duration: Duration(minutes: (json['durationMinutes'] as num).toInt()),
        seatsAvailable: (json['seatsAvailable'] as num).toInt(),
        pricePerSeat: (json['pricePerSeat'] as num).toDouble(),
        ac: json['ac'] as bool,
        amenities: (json['amenities'] as List<dynamic>).cast<String>(),
        pickupPoints: (json['pickupPoints'] as List<dynamic>).cast<String>(),
        dropPoints: (json['dropPoints'] as List<dynamic>).cast<String>(),
      );
}

@immutable
class BookingReceipt {
  const BookingReceipt({
    required this.id,
    required this.ride,
    required this.seats,
    required this.total,
    required this.paidOnline,
    required this.createdAt,
    this.cancelled = false,
  });

  final String id;
  final Ride ride;
  final int seats;
  final double total;
  final bool paidOnline;
  final DateTime createdAt;
  final bool cancelled;

  /// True once the scheduled arrival time has passed.
  bool get completed => ride.arrival.isBefore(DateTime.now());

  BookingReceipt copyWith({bool? cancelled}) => BookingReceipt(
        id: id,
        ride: ride,
        seats: seats,
        total: total,
        paidOnline: paidOnline,
        createdAt: createdAt,
        cancelled: cancelled ?? this.cancelled,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'ride': ride.toJson(),
        'seats': seats,
        'total': total,
        'paidOnline': paidOnline,
        'createdAt': createdAt.toIso8601String(),
        'cancelled': cancelled,
      };

  factory BookingReceipt.fromJson(Map<String, dynamic> json) => BookingReceipt(
        id: json['id'] as String,
        ride: Ride.fromJson(json['ride'] as Map<String, dynamic>),
        seats: (json['seats'] as num).toInt(),
        total: (json['total'] as num).toDouble(),
        paidOnline: json['paidOnline'] as bool,
        createdAt: DateTime.parse(json['createdAt'] as String),
        cancelled: (json['cancelled'] as bool?) ?? false,
      );
}
