import 'package:date_format/date_format.dart';

///时间转换
String utcToLocal(time) {
  return formatDate(DateTime.parse(time).toLocal() ,[yyyy,'-',mm,'-',dd, ' ',HH,':',nn,':',ss]);
}