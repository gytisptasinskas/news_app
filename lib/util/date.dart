import 'package:intl/intl.dart';

class DateFormatter {
  static String formatDate(String dateString) {
    final DateTime parsedDate = DateTime.parse(dateString);
    return DateFormat('MMMM dd, yyyy').format(parsedDate);
  }
}
