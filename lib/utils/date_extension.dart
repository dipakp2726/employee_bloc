import 'package:intl/intl.dart';

extension DateExtension on DateTime {
  /// return date in US format
  String get toDateOnly {
    DateFormat dateFormat = DateFormat('d MMM y');

    // Format the date and time
    String formattedDate = dateFormat.format(this);

    return formattedDate;
  }
}