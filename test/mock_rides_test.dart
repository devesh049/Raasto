import 'package:flutter_test/flutter_test.dart';
import 'package:raasto/features/search/data/mock_rides.dart';
import 'package:raasto/features/search/domain/models.dart';

SearchQuery _query({String? vehicleType}) => SearchQuery(
      from: 'Raipur',
      to: 'Bilaspur',
      date: DateTime(2026, 1, 1),
      vehicleType: vehicleType,
    );

void main() {
  test('ridesFor returns rides bound to the requested route', () {
    final List<Ride> rides = ridesFor(_query());
    expect(rides, isNotEmpty);
    expect(
      rides.every((Ride r) => r.from == 'Raipur' && r.to == 'Bilaspur'),
      isTrue,
    );
  });

  test('ridesFor filters by vehicle type', () {
    final List<Ride> suvs = ridesFor(_query(vehicleType: 'SUV'));
    expect(suvs, isNotEmpty);
    expect(suvs.every((Ride r) => r.vehicleType == 'SUV'), isTrue);
  });

  test('sortRides by cheapest is ascending by price', () {
    final List<Ride> rides = sortRides(ridesFor(_query()), RideSort.cheapest);
    for (int i = 0; i < rides.length - 1; i++) {
      expect(rides[i].pricePerSeat <= rides[i + 1].pricePerSeat, isTrue);
    }
  });

  test('sortRides by earliest is ascending by departure', () {
    final List<Ride> rides = sortRides(ridesFor(_query()), RideSort.earliest);
    for (int i = 0; i < rides.length - 1; i++) {
      expect(
        !rides[i].departure.isAfter(rides[i + 1].departure),
        isTrue,
      );
    }
  });

  test('sortRides does not mutate the source list', () {
    final List<Ride> source = ridesFor(_query());
    final String firstId = source.first.id;
    sortRides(source, RideSort.cheapest);
    expect(source.first.id, firstId);
  });
}
