import 'package:intl/intl.dart';

class DateFormatter {
  static String formatDate(DateTime date) =>
      DateFormat('dd MMM yyyy').format(date);

  static String formatTime(DateTime date) => DateFormat('hh:mm a').format(date);

  static String formatDateTime(DateTime date) =>
      DateFormat('dd MMM yyyy, hh:mm a').format(date);

  static String formatDateShort(DateTime date) =>
      DateFormat('dd/MM/yyyy').format(date);
}
