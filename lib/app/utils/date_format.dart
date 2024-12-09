import 'package:intl/intl.dart';

String formatDate(String dateTimeStr) {
  try {
    DateTime dateTime = DateTime.parse(dateTimeStr);
    return DateFormat('dd MMM yyyy, HH:mm').format(dateTime);
  } catch (e) {
    return 'Invalid date';
  }
}
