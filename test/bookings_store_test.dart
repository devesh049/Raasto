import 'package:flutter_test/flutter_test.dart';
import 'package:raasto/features/search/data/mock_rides.dart';
import 'package:raasto/features/search/domain/models.dart';

BookingReceipt _receipt({
  required DateTime date,
  bool paidOnline = true,
  bool cancelled = false,
}) {
  final Ride ride = ridesFor(
    SearchQuery(from: 'Raipur', to: 'Bilaspur', date: date),
  ).first;
  return BookingReceipt(
    id: 'BK-TEST-1',
    ride: ride,
    seats: 2,
    total: 1000,
    paidOnline: paidOnline,
    createdAt: date,
    cancelled: cancelled,
  );
}

void main() {
  test('BookingReceipt JSON round-trip preserves every field', () {
    final BookingReceipt receipt = _receipt(date: DateTime(2026, 1, 1, 9));
    final BookingReceipt restored =
        BookingReceipt.fromJson(receipt.toJson());

    expect(restored.id, receipt.id);
    expect(restored.seats, receipt.seats);
    expect(restored.total, receipt.total);
    expect(restored.paidOnline, receipt.paidOnline);
    expect(restored.cancelled, receipt.cancelled);
    expect(restored.createdAt, receipt.createdAt);
    expect(restored.ride.id, receipt.ride.id);
    expect(restored.ride.driver.name, receipt.ride.driver.name);
    expect(restored.ride.from, receipt.ride.from);
    expect(restored.ride.to, receipt.ride.to);
    expect(restored.ride.departure, receipt.ride.departure);
    expect(restored.ride.amenities, receipt.ride.amenities);
    expect(restored.ride.pickupPoints, receipt.ride.pickupPoints);
  });

  test('copyWith toggles cancelled only', () {
    final BookingReceipt receipt = _receipt(date: DateTime(2026, 1, 1, 9));
    final BookingReceipt cancelled = receipt.copyWith(cancelled: true);
    expect(cancelled.cancelled, isTrue);
    expect(cancelled.id, receipt.id);
    expect(cancelled.total, receipt.total);
  });

  test('completed is true once the arrival time has passed', () {
    final BookingReceipt past = _receipt(date: DateTime(2020, 1, 1));
    final BookingReceipt future = _receipt(date: DateTime(2099, 1, 1));
    expect(past.completed, isTrue);
    expect(future.completed, isFalse);
  });
}
