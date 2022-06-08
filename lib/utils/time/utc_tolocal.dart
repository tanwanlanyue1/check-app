import 'package:date_format/date_format.dart';

///日期转换
String formatTime(time) {
  return utcToLocal(time.toString()).substring(0,16);
}

///时间转换
String utcToLocal(time) {
  if(null == time){
    return '-';
  }
  return formatDate(DateTime.parse(time).toLocal() ,[yyyy,'-',mm,'-',dd, ' ',HH,':',nn,':',ss]);
}