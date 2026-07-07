import 'package:intl/intl.dart';

class HumanFormats {
  static String number( double number, [ int decimals = 0 ] ) {
    final formattedNumber = NumberFormat.currency(
      decimalDigits: decimals,
      symbol: '',
      locale: 'de_DE'
    ).format(number);

    return formattedNumber;
  }
}