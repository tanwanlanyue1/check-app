import 'dart:convert';
import 'package:azlistview/azlistview.dart';
import 'language_helper.dart';

class Languages extends Contact with ISuspensionBean {

  String? tagIndex;
  String? pinyin;
  String? shortPinyin;

  Languages.fromJson(Map<String, dynamic> json) : super.fromJson(json);

  //返回标签
  @override
  String getSuspensionTag() {
    return tagIndex ?? '';
  }

}