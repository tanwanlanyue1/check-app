
///转json
class LanguageHelper {

  static List? language ;

  static List<Contact>? getGithubLanguages() {
    List<Contact>? list =
    language?.map((v) => Contact.fromJson(v)).toList();
    return list;
  }

}

///Contact: json解析
/// createdAt : "2022-03-10T07:43:43.512Z"
/// updatedAt : "2022-03-11T03:01:39.179Z"
/// number : 编号
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
    this.industry,});

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
  }
  String? createdAt;
  String? updatedAt;
  dynamic deletedAt;
  String? id;
  String? name;
  dynamic number;
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
/// id : "b2eda75e-860b-4ed3-b923-092eee3e05a4"
/// name : "第一片区"

class District {
  District({
    this.id,
    this.name,});

  District.fromJson(dynamic json) {
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