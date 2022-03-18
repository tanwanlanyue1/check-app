// ignore_for_file: constant_identifier_names
/// 配置全局本地缓存的key
class StorageKey {
  static const String AppVersion = 'appVersion'; // App端 企业/政府/第三方

  static const String PersonalData = 'personalData'; // 个人资料缓存

  static const String STORAGE_USER_PROFILE_KEY = 'user_profile'; // 用户 - 配置信息

  static const String STORAGE_DEVICE_ALREADY_OPEN_KEY = 'device_already_open1'; // 设备是否第一次打开

  static const String Token = 'token'; // 用户token

  static const String allCompany = 'allCompany'; // 全部公司

  static const String port = 'port'; // 判断是哪一端

  static const String FontBold = 'Alibaba-PuHuiTi-Bold.ttf'; // 阿里巴巴 Alibaba-PuHuiTi-Bold.ttf字体缓存

  static const String FontMedium = 'Alibaba-PuHuiTi-Medium.ttf'; // 阿里巴巴 Alibaba-PuHuiTi-Medium.ttf字体缓存

  static const String FontRegular = 'Alibaba-PuHuiTi-Regular.ttf'; // 阿里巴巴 Alibaba-PuHuiTi-Regular.ttf字体缓存

  static const String FontDownload = "font_download_finish"; // 是否下载完字体

  static const List productMainList = [
    '环保管家',
    '企业',
    '环保局',
  ]; // 页面类型ID
}
