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

///时间转换 年，月，日
String utcTransition() {
  String now = formatDate(DateTime.parse(DateTime.now().toString()).toLocal() ,[yyyy,'',mm,'',dd,])+'/';
  return now;
}