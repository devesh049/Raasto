import 'package:intl/intl.dart';

final NumberFormat _inr = NumberFormat.currency(
  locale: 'en_IN',
  symbol: '₹',
  decimalDigits: 0,
);
final DateFormat _time = DateFormat('h:mm a');
final DateFormat _date = DateFormat('d MMM yyyy');
final DateFormat _day = DateFormat('EEE, d MMM');

String formatInr(num value) => _inr.format(value);

String formatTime(DateTime value) => _time.format(value);

String formatDate(DateTime value) => _date.format(value);

String formatDay(DateTime value) => _day.format(value);

String formatDuration(Duration d) {
  final int h = d.inHours;
  final int m = d.inMinutes.remainder(60);
  if (h == 0) {
    return '${m}m';
  }
  if (m == 0) {
    return '${h}h';
  }
  return '${h}h ${m}m';
}
