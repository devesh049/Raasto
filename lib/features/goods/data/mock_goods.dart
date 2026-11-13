import 'package:flutter/material.dart';

import '../domain/goods_models.dart';

/// Available goods vehicle categories (deterministic mock inventory).
const List<GoodsVehicle> goodsVehicles = <GoodsVehicle>[
  GoodsVehicle(
    id: 'loader3w',
    name: '3-Wheeler Loader',
    capacity: '500 kg',
    basePrice: 900,
    icon: Icons.electric_rickshaw_rounded,
  ),
  GoodsVehicle(
    id: 'tata-ace',
    name: 'Tata Ace',
    capacity: '750 kg',
    basePrice: 1200,
    icon: Icons.local_shipping_rounded,
  ),
  GoodsVehicle(
    id: 'pickup',
    name: 'Pickup (Bolero)',
    capacity: '1.5 ton',
    basePrice: 1800,
    icon: Icons.agriculture_rounded,
  ),
  GoodsVehicle(
    id: 'truck14',
    name: 'Truck (14 ft)',
    capacity: '4 ton',
    basePrice: 3500,
    icon: Icons.fire_truck_rounded,
  ),
];

GoodsVehicle? goodsVehicleById(String? id) {
  if (id == null) {
    return null;
  }
  for (final GoodsVehicle v in goodsVehicles) {
    if (v.id == id) {
      return v;
    }
  }
  return null;
}

const List<String> _transporters = <String>[
  'Sharma Logistics',
  'Gupta Transport Co.',
  'Jai Bhawani Carriers',
  'Rathore Freight',
  'Verma Roadlines',
];

/// Builds deterministic quotes for a request. Real backend replaces this later.
List<GoodsQuote> quotesFor(GoodsRequest request) {
  final List<GoodsVehicle> pool = request.vehicleId == null
      ? goodsVehicles
      : goodsVehicles.where((GoodsVehicle v) => v.id == request.vehicleId).toList();

  final List<GoodsQuote> quotes = <GoodsQuote>[];
  for (int i = 0; i < pool.length; i++) {
    final GoodsVehicle v = pool[i];
    final double weightFactor = 1 + (request.weightKg / 2000).clamp(0.0, 0.6);
    final double variance = 1 + (i * 0.06);
    quotes.add(
      GoodsQuote(
        id: 'Q-${v.id}-$i',
        transporter: _transporters[i % _transporters.length],
        vehicleName: v.name,
        capacity: v.capacity,
        rating: 4.4 + (i % 4) * 0.15,
        price: (v.basePrice * weightFactor * variance).roundToDouble(),
        etaMinutes: 25 + i * 15,
      ),
    );
  }
  quotes.sort((GoodsQuote a, GoodsQuote b) => a.price.compareTo(b.price));
  return quotes;
}
