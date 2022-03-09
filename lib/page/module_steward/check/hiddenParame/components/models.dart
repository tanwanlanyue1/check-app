import 'dart:convert';
import 'package:azlistview/azlistview.dart';
import 'language_helper.dart';

class Languages extends Contact with ISuspensionBean {

  String? tagIndex;
  String? pinyin;
  String? shortPinyin;

  Languages.fromJson(Map<String, dynamic> json) : super.fromJson(json);

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = super.toJson();
    void addIfNonNull(String fieldName, dynamic value) {
      if (value != null) {
        map[fieldName] = value;
      }
    }
//    addIfNonNull('tagIndex', tagIndex);
    return map;
  }

  @override
  String getSuspensionTag() {
    return tagIndex ?? '';
  }

  @override
  String toString() {
    return json.encode(this);
  }
}