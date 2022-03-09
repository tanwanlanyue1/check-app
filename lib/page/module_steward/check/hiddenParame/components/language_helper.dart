import 'dart:collection';

///转json
class LanguageHelper {

  static Map<String, String>? languageMap ;
  static List? language ;

  static Map<String, String> getResource(List? list) {
    Map<String, String> map = HashMap();
    List<MapEntry<String, String>> mapEntryList = [];
    map.addEntries(mapEntryList);
    return map;
  }

  static List<Contact>? getGithubLanguages() {
    List<Contact>? list =
    language?.map((v) => Contact.fromJson(v)).toList();
    // language.map((v) => GithubLanguage.fromJson(v)).toList();
    return list;
  }

  static String getGithubLanguageColor(String language,
      {String defColor = ''}) {
    return languageMap?[language] ?? defColor;
  }
}


class Contact {
  Contact({
    this.id,
    this.name,
    this.shortName,
    this.area,});

  Contact.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    shortName = json['short_name'];
    area = json['area'];
  }
  int? id;
  String? name;
  String? shortName;
  int? area;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['short_name'] = shortName;
    map['area'] = area;
    return map;
  }

}