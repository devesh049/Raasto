import '../domain/models.dart';

const Driver _rahul = Driver(
  name: 'Rahul Sharma',
  rating: 4.8,
  trips: 214,
  verified: true,
);
const Driver _priya = Driver(
  name: 'Priya Verma',
  rating: 4.9,
  trips: 342,
  verified: true,
);
const Driver _imran = Driver(
  name: 'Imran Khan',
  rating: 4.6,
  trips: 128,
  verified: true,
);
const Driver _sanjay = Driver(
  name: 'Sanjay Patel',
  rating: 4.4,
  trips: 87,
  verified: false,
);
const Driver _meena = Driver(
  name: 'Meena Yadav',
  rating: 4.7,
  trips: 176,
  verified: true,
);

/// Deterministic mock inventory for a search. Real backend replaces this later.
List<Ride> ridesFor(SearchQuery query) {
  final DateTime day = DateTime(
    query.date.year,
    query.date.month,
    query.date.day,
  );

  final List<Ride> all = <Ride>[
    Ride(
      id: 'R-1024',
      driver: _rahul,
      vehicleModel: 'Maruti Swift Dzire',
      vehicleType: 'Car',
      plate: 'CG 04 AB 1234',
      from: query.from,
      to: query.to,
      departure: day.add(const Duration(hours: 6, minutes: 30)),
      duration: const Duration(hours: 2, minutes: 15),
      seatsAvailable: 3,
      pricePerSeat: 450,
      ac: true,
      amenities: <String>['AC', 'Music', 'Charging point'],
      pickupPoints: <String>['${query.from} Bus Stand', '${query.from} Railway Station'],
      dropPoints: <String>['${query.to} Main Market', '${query.to} Bus Stand'],
    ),
    Ride(
      id: 'R-2087',
      driver: _priya,
      vehicleModel: 'Hyundai Ertiga',
      vehicleType: 'SUV',
      plate: 'CG 07 CD 8890',
      from: query.from,
      to: query.to,
      departure: day.add(const Duration(hours: 8, minutes: 0)),
      duration: const Duration(hours: 2, minutes: 5),
      seatsAvailable: 5,
      pricePerSeat: 620,
      ac: true,
      amenities: <String>['AC', 'Extra legroom', 'Water bottle'],
      pickupPoints: <String>['${query.from} Railway Station'],
      dropPoints: <String>['${query.to} Railway Station'],
    ),
    Ride(
      id: 'R-3391',
      driver: _imran,
      vehicleModel: 'Maruti WagonR',
      vehicleType: 'Car',
      plate: 'CG 12 EF 4521',
      from: query.from,
      to: query.to,
      departure: day.add(const Duration(hours: 10, minutes: 45)),
      duration: const Duration(hours: 2, minutes: 40),
      seatsAvailable: 2,
      pricePerSeat: 380,
      ac: false,
      amenities: <String>['Music', 'Charging point'],
      pickupPoints: <String>['${query.from} Main Market'],
      dropPoints: <String>['${query.to} Main Market'],
    ),
    Ride(
      id: 'R-4102',
      driver: _sanjay,
      vehicleModel: 'Bajaj RE Auto',
      vehicleType: 'Auto',
      plate: 'CG 15 GH 0099',
      from: query.from,
      to: query.to,
      departure: day.add(const Duration(hours: 13, minutes: 15)),
      duration: const Duration(hours: 3, minutes: 10),
      seatsAvailable: 3,
      pricePerSeat: 210,
      ac: false,
      amenities: <String>['Luggage space'],
      pickupPoints: <String>['${query.from} Bus Stand'],
      dropPoints: <String>['${query.to} Bus Stand'],
    ),
    Ride(
      id: 'R-5230',
      driver: _meena,
      vehicleModel: 'Toyota Innova',
      vehicleType: 'SUV',
      plate: 'CG 09 IJ 7788',
      from: query.from,
      to: query.to,
      departure: day.add(const Duration(hours: 16, minutes: 0)),
      duration: const Duration(hours: 2, minutes: 20),
      seatsAvailable: 6,
      pricePerSeat: 700,
      ac: true,
      amenities: <String>['AC', 'Large boot', 'Music', 'Charging point'],
      pickupPoints: <String>['${query.from} City Hospital'],
      dropPoints: <String>['${query.to} City Hospital'],
    ),
  ];

  final String? type = query.vehicleType;
  if (type == null) {
    return all;
  }
  return all.where((Ride r) => r.vehicleType == type).toList();
}

/// Sorts a ride list in place-safe fashion.
List<Ride> sortRides(List<Ride> rides, RideSort sort) {
  final List<Ride> copy = List<Ride>.of(rides);
  switch (sort) {
    case RideSort.earliest:
      copy.sort((Ride a, Ride b) => a.departure.compareTo(b.departure));
    case RideSort.cheapest:
      copy.sort((Ride a, Ride b) => a.pricePerSeat.compareTo(b.pricePerSeat));
    case RideSort.nearest:
      copy.sort((Ride a, Ride b) => b.driver.rating.compareTo(a.driver.rating));
  }
  return copy;
}

enum RideSort { earliest, cheapest, nearest }
