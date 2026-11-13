import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/driver_models.dart';

/// In-memory list of rides the driver has published in this session.
///
/// Prototype storage; a real backend will persist and sync these.
class PublishedRidesStore extends Notifier<List<PublishedRide>> {
  @override
  List<PublishedRide> build() => const <PublishedRide>[];

  void add(PublishedRide ride) {
    state = <PublishedRide>[ride, ...state];
  }

  void remove(String id) {
    state = state.where((PublishedRide r) => r.id != id).toList();
  }
}

final NotifierProvider<PublishedRidesStore, List<PublishedRide>>
    publishedRidesProvider =
    NotifierProvider<PublishedRidesStore, List<PublishedRide>>(
  PublishedRidesStore.new,
);

/// Total potential earnings across all published rides.
final Provider<double> potentialEarningsProvider = Provider<double>((Ref ref) {
  return ref
      .watch(publishedRidesProvider)
      .fold<double>(0, (double sum, PublishedRide r) => sum + r.potentialEarnings);
});
