
class Api {
  static const baseUrl = 'https://cz.scet.com.cn:1443/api';

  // static const baseUrlApp = 'http://10.10.1.217:9750';
  static const baseUrlApp = 'http://10.10.1.217:8687/';

  static const baseWs = 'wss://cz.scet.com.cn:1443/api/wfws';

  static final Map url = {
    'version': baseUrlApp + '/manualInsert/platFromXiaZai',//版本更新

    'log': baseUrlApp + 'user/login',//登录 sign-in

    'register': baseUrlApp + 'user/register',//注册

    'getByCompanyId': baseUrlApp + 'hiddenLedger/getByCompanyId',//隐患台账公司详情

    'statistics': baseUrlApp + 'hiddenLedger/statistics',//公司统计

    'all': baseUrlApp + 'company/all',//公司

    'lawFile': baseUrlApp + 'lawFile',//法律文件

    'fileSearch': baseUrlApp + 'lawFile/search',//法律文件搜索

    'columns': baseUrlApp + 'company/columns',//表头

    'fields': baseUrlApp + 'company/fields',//表单

    'panelist': baseUrlApp + 'company/list',//分页列表
  };
}