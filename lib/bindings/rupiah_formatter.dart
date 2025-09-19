import 'package:intl/intl.dart';

class RupiahFormatter {
  static String withRupiah(int num) {
    final rupiahFormat = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return rupiahFormat.format(num);
  }

  static int parseRupiah(String rp) {
    final numericValue = rp
        .replaceAll("Rp", "")
        .replaceAll(" ", "")
        .replaceAll(".", "");
    return int.tryParse(numericValue) ?? 0;
  }
}
