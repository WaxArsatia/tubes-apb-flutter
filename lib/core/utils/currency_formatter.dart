import 'package:intl/intl.dart';

final class CurrencyFormatter {
  CurrencyFormatter._();

  static final NumberFormat _idrFormatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp. ',
    decimalDigits: 0,
  );

  static String idr(num amount) {
    return _idrFormatter.format(amount);
  }
}
