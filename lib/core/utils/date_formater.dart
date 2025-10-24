import 'package:intl/intl.dart';

class DateFormater {
  static DateTime _convertDateUtc(String dateString) {
    final DateTime dateTimeUtc = DateTime.parse(dateString);
    final dateTimeLocal = dateTimeUtc.toLocal();

    return dateTimeLocal;
  }

  static String dateFormatedLocal(String dateString) {
    final DateTime dateTimeLocal = _convertDateUtc(dateString);

    final formatoBr = DateFormat('dd/MM/yyyy : HH:mm', 'pt_BR');
    final dataFormatadaBr = formatoBr.format(dateTimeLocal);

    return dataFormatadaBr;
  }

  static String dateFormateInFull(String dateString) {
    DateTime dateTimeLocal = _convertDateUtc(dateString);

    final formatoExtenso = DateFormat("d 'de' MMMM 'de' y", 'pt_BR');
    final dataPorExtenso = formatoExtenso.format(dateTimeLocal);
    return dataPorExtenso;
  }
}
