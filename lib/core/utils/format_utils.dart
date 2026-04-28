class FormatUtils {
  static double parseBrazilianDouble(String value) {
    return double.parse(value.replaceAll(',', '.'));
  }

  static String formatCurrency(double value) {
    return 'R\$ ${value.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  static String formatDate(DateTime? date) {
    if (date == null) return 'Selecionar data';

    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();

    return '$day/$month/$year';
  }
}
