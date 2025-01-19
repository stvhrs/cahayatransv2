import 'package:intl/intl.dart';

class Rupiah {
  static String format(double i) {
    if(i.isNegative){return "( "+ NumberFormat.currency(
            locale: "id_ID", decimalDigits: 0, symbol: 'Rp ')
        .format(i)  .replaceAll('-', '')
        .toString()+" )";}else{
    return  NumberFormat.currency(
            locale: "id_ID", decimalDigits: 0, symbol: 'Rp ')
        .format(i) .replaceAll('-', '')
        .toString();}
      
  }
 static String formatTanpaKurung(double i) {
    if(i.isNegative){return NumberFormat.currency(
            locale: "id_ID", decimalDigits: 0, symbol: '')
        .format(i)  .replaceAll('-', '')
        .toString();}else{
    return  NumberFormat.currency(
            locale: "id_ID", decimalDigits: 0, symbol: '')
        .format(i) .replaceAll('-', '')
        .toString();}
      
  }


  static String format2(double i) {
   if(i.isNegative){return "( "+ NumberFormat.currency(
            locale: "id_ID", decimalDigits: 0, symbol: '')
        .format(i) .replaceAll('-', '')
        .toString()+" )";}else{
    return  NumberFormat.currency(
            locale: "id_ID", decimalDigits: 0, symbol: '')
        .format(i) .replaceAll('-', '')
        .toString();}
  }

  static double parse(String s) {
    return NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ')
        .parse(s)
        .toDouble();
  }
}
