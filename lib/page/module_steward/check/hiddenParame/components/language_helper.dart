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

///Contact: json解析
/// createdAt : "2022-03-10T07:43:43.512Z"
/// updatedAt : "2022-03-11T03:01:39.179Z"
/// deletedAt : null
/// id : "cf7123d1-a045-11ec-b9e7-40b07680bfb9" 公司id
/// name : "沧州康达制药有限公司临港分公司" 公司名
/// shortName : "康达制药" 公司简称
/// region : "东区"
/// status : 1 状态: 1,正常生产; 2,停产
/// districtId : "5e007c3c-eba8-4f90-962b-6bfe35c348bd"片区ID
/// industryId : null 行业ID
class Contact {
  Contact({
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.id,
    this.name,
    this.shortName,
    this.status,
    this.districtId,
    this.industryId,});

  Contact.fromJson(dynamic json) {
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    deletedAt = json['deletedAt'];
    id = json['id'];
    name = json['name'];
    shortName = json['shortName'];
    status = json['status'];
    districtId = json['districtId'];
    industryId = json['industryId'];
  }
  String? createdAt;
  String? updatedAt;
  dynamic deletedAt;
  String? id;
  String? name;
  String? shortName;
  int? status;
  String? districtId;
  dynamic industryId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    map['deletedAt'] = deletedAt;
    map['id'] = id;
    map['name'] = name;
    map['shortName'] = shortName;
    map['status'] = status;
    map['districtId'] = districtId;
    map['industryId'] = industryId;
    return map;
  }

}

// class Contact {
//   Contact({
//     this.id,
//     this.name,
//     this.shortName,
//     this.area,});
//
//   Contact.fromJson(dynamic json) {
//     id = json['id'];
//     name = json['name'];
//     shortName = json['short_name'];
//     area = json['area'];
//   }
//   int? id;
//   String? name;
//   String? shortName;
//   int? area;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['id'] = id;
//     map['name'] = name;
//     map['short_name'] = shortName;
//     map['area'] = area;
//     return map;
//   }
//
// }