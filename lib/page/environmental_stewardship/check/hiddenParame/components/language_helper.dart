import 'dart:collection';
import 'dart:convert';

class LanguageHelper {

  static Map<String, String>? languageMap ;
  static List? language ;
  // static Map<String, String> languageMap = getResource(githubLanguageColors);

  static Map<String, String> getResource(List? list) {
    Map<String, String> map = HashMap();
    List<MapEntry<String, String>> mapEntryList = [];
    // for (int i = 0, length = list.length; i < length; i++) {
    //   Map<String, String> tokens = list[i];
    //   String? name = tokens['name'];
    //   String? color = tokens['color'];
    //   // if (color != null && name != null) {
    //   if (color != null && name != null) {
    //     MapEntry<String, String> mapEntry = MapEntry(name, color,);
    //     mapEntryList.add(mapEntry);
    //   }
    // }
    map.addEntries(mapEntryList);
    return map;
  }

  // static List<GithubLanguage>? getGithubLanguages() {
  //   List<GithubLanguage>? list =
  //   language?.map((v) => GithubLanguage.fromJson(v)).toList();
  //   // githubLanguageColors.map((v) => GithubLanguage.fromJson(v)).toList();
  //   return list;
  // }
  //
  // static List<GithubLanguage> getGithubSpokenLanguages() {
  //   List<GithubLanguage> list =
  //       githubSpokenLanguage.map((v) => GithubLanguage.fromJson(v)).toList();
  //   return list;
  // }
  static List<Contact>? getGithubLanguages() {
    List<Contact>? list =
    language?.map((v) => Contact.fromJson(v)).toList();
    // githubLanguageColors.map((v) => GithubLanguage.fromJson(v)).toList();
    return list;
  }

  static List<Contact> getGithubSpokenLanguages() {
    List<Contact> list =
    githubSpokenLanguage.map((v) => Contact.fromJson(v)).toList();
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
const List githubSpokenLanguage = [
  {"urlParam": "ab", "name": "Abkhazian"},
  {"urlParam": "aa", "name": "Afar"},
  {"urlParam": "af", "name": "Afrikaans"},
  {"urlParam": "ak", "name": "Akan"},
  {"urlParam": "ho", "name": "Hiri Motu"},
  {"urlParam": "hu", "name": "Hungarian"},
  {"urlParam": "ia", "name": "Interlingua (International Auxil..."},
  {"urlParam": "za", "name": "Zhuang, Chuang"},
  {"urlParam": "zu", "name": "Zulu"}
];
