
///转json
class LanguageHelper {

  static List? language ;

  static List<Contact>? getGithubLanguages() {
    List<Contact>? list =
    language?.map((v) => Contact.fromJson(v)).toList();
    return list;
  }

}

/// createdAt : "2022-03-10T07:43:43.298Z"
/// updatedAt : "2022-05-10T08:32:31.427Z"
/// deletedAt : null
/// id : "cf509f49-a045-11ec-b9e7-40b07680bfb9"
/// name : "沧州临港赫基化工有限公司"
/// number : "1-3"
/// shortName : "赫基化工"
/// address : null
/// environmentPrincipal : null
/// environmentPhone : null
/// pollutionDischarge : null
/// pollutionDischargeType : 1
/// pollutionDischargeStart : null
/// pollutionDischargeEnd : null
/// isPollutionDischarge : true
/// status : 1
/// region : {"id":"641b0fdf-59b6-4eff-8bfd-bee384c1f298","name":"西区"}
/// district : {"id":"b2eda75e-860b-4ed3-b923-092eee3e05a4","name":"第一片区"}
/// industry : {"id":"0a18c900-a0e0-11ec-96b0-40b07680bfb9","name":"医药行业"}
/// user : [{"id":"46b9c804-7cf3-4995-9404-e01a96e0ea26","nickname":"甄先生"}]

class Contact {
  Contact({
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.id,
    this.name,
    this.number,
    this.shortName,
    this.address,
    this.environmentPrincipal,
    this.environmentPhone,
    this.pollutionDischarge,
    this.pollutionDischargeType,
    this.pollutionDischargeStart,
    this.pollutionDischargeEnd,
    this.isPollutionDischarge,
    this.status,
    this.region,
    this.district,
    this.industry,
    this.user,});

  Contact.fromJson(dynamic json) {
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    deletedAt = json['deletedAt'];
    id = json['id'];
    name = json['name'];
    number = json['number'];
    shortName = json['shortName'];
    address = json['address'];
    environmentPrincipal = json['environmentPrincipal'];
    environmentPhone = json['environmentPhone'];
    pollutionDischarge = json['pollutionDischarge'];
    pollutionDischargeType = json['pollutionDischargeType'];
    pollutionDischargeStart = json['pollutionDischargeStart'];
    pollutionDischargeEnd = json['pollutionDischargeEnd'];
    isPollutionDischarge = json['isPollutionDischarge'];
    status = json['status'];
    region = json['region'] != null ? Region.fromJson(json['region']) : null;
    district = json['district'] != null ? District.fromJson(json['district']) : null;
    industry = json['industry'] != null ? Industry.fromJson(json['industry']) : null;
    if (json['user'] != null) {
      user = [];
      json['user'].forEach((v) {
        user?.add(User.fromJson(v));
      });
    }
  }
  String? createdAt;
  String? updatedAt;
  dynamic deletedAt;
  String? id;
  String? name;
  String? number;
  String? shortName;
  dynamic address;
  dynamic environmentPrincipal;
  dynamic environmentPhone;
  dynamic pollutionDischarge;
  int? pollutionDischargeType;
  dynamic pollutionDischargeStart;
  dynamic pollutionDischargeEnd;
  bool? isPollutionDischarge;
  int? status;
  Region? region;
  District? district;
  Industry? industry;
  List<User>? user;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    map['deletedAt'] = deletedAt;
    map['id'] = id;
    map['name'] = name;
    map['number'] = number;
    map['shortName'] = shortName;
    map['address'] = address;
    map['environmentPrincipal'] = environmentPrincipal;
    map['environmentPhone'] = environmentPhone;
    map['pollutionDischarge'] = pollutionDischarge;
    map['pollutionDischargeType'] = pollutionDischargeType;
    map['pollutionDischargeStart'] = pollutionDischargeStart;
    map['pollutionDischargeEnd'] = pollutionDischargeEnd;
    map['isPollutionDischarge'] = isPollutionDischarge;
    map['status'] = status;
    if (region != null) {
      map['region'] = region?.toJson();
    }
    if (district != null) {
      map['district'] = district?.toJson();
    }
    if (industry != null) {
      map['industry'] = industry?.toJson();
    }
    if (user != null) {
      map['user'] = user?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : "641b0fdf-59b6-4eff-8bfd-bee384c1f298"
/// name : "西区"
class Region {
  Region({
    this.id,
    this.name,});

  Region.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
  }
  String? id;
  String? name;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    return map;
  }

}
/// id : "0a18c900-a0e0-11ec-96b0-40b07680bfb9"
/// name : "医药行业"

/// id : "0a18c900-a0e0-11ec-96b0-40b07680bfb9"
/// name : "医药行业"

class Industry {
  Industry({
    this.id,
    this.name,});

  Industry.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
  }
  String? id;
  String? name;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    return map;
  }

}

class District {
  District({
    this.id,
    this.name,});

  District.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
  }
  int? id;
  String? name;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    return map;
  }

}
/// id : "46b9c804-7cf3-4995-9404-e01a96e0ea26"
/// nickname : "甄先生"

class User {
  User({
    this.id,
    this.nickname,});

  User.fromJson(dynamic json) {
    id = json['id'];
    nickname = json['nickname'];
  }
  int? id;
  String? nickname;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['nickname'] = nickname;
    return map;
  }

}