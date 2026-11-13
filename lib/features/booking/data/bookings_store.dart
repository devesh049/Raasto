import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/storage/preferences.dart';
import '../../search/domain/models.dart';

/// Local, persistent list of passenger bookings.
///
/// Prototype storage: the whole list is serialized to SharedPreferences. A real
/// backend will replace this with a server-synced repository.
class BookingsStore extends Notifier<List<BookingReceipt>> {
  @override
  List<BookingReceipt> build() {
    final String? raw = ref.watch(sharedPreferencesProvider).getString(PrefKeys.bookings);
    if (raw == null || raw.isEmpty) {
      return const <BookingReceipt>[];
    }
    try {
      final List<dynamic> decoded = jsonDecode(raw) as List<dynamic>;
      return decoded
          .map((dynamic e) => BookingReceipt.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return const <BookingReceipt>[];
    }
  }

  Future<void> add(BookingReceipt receipt) async {
    state = <BookingReceipt>[receipt, ...state];
    await _persist();
  }

  Future<void> cancel(String id) async {
    state = state
        .map((BookingReceipt b) => b.id == id ? b.copyWith(cancelled: true) : b)
        .toList();
    await _persist();
  }

  Future<void> _persist() async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setString(
      PrefKeys.bookings,
      jsonEncode(state.map((BookingReceipt b) => b.toJson()).toList()),
    );
  }
}

final NotifierProvider<BookingsStore, List<BookingReceipt>> bookingsProvider =
    NotifierProvider<BookingsStore, List<BookingReceipt>>(BookingsStore.new);

/// Confirmed, paid and not yet finished.
final Provider<List<BookingReceipt>> upcomingBookingsProvider =
    Provider<List<BookingReceipt>>((Ref ref) {
  return ref.watch(bookingsProvider).where((BookingReceipt b) {
    return !b.cancelled && !b.completed && b.paidOnline;
  }).toList();
});

/// Cash bookings still awaiting payment to the driver.
final Provider<List<BookingReceipt>> pendingBookingsProvider =
    Provider<List<BookingReceipt>>((Ref ref) {
  return ref.watch(bookingsProvider).where((BookingReceipt b) {
    return !b.cancelled && !b.completed && !b.paidOnline;
  }).toList();
});

final Provider<List<BookingReceipt>> completedBookingsProvider =
    Provider<List<BookingReceipt>>((Ref ref) {
  return ref.watch(bookingsProvider).where((BookingReceipt b) {
    return !b.cancelled && b.completed;
  }).toList();
});

final Provider<List<BookingReceipt>> cancelledBookingsProvider =
    Provider<List<BookingReceipt>>((Ref ref) {
  return ref.watch(bookingsProvider).where((BookingReceipt b) => b.cancelled).toList();
});
