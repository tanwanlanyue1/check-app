
class Api {
  static const baseUrl = 'https://cz.scet.com.cn:1443/api';

  // static const baseUrlApp = 'http://10.10.1.217:9750';
  static const baseUrlApp = 'http://10.10.1.217:8687/';

  static const baseWs = 'wss://cz.scet.com.cn:1443/api/wfws';

  static final Map url = {
    'version': baseUrlApp + '/manualInsert/platFromXiaZai',//版本更新

    'user': baseUrlApp + 'user',//获取数据

    'login': baseUrlApp + 'auth/login',//登录

    'register': baseUrlApp + 'user/register',//注册

    'getByCompanyId': baseUrlApp + 'ledgerReview/getByCompanyId',//隐患台账公司详情

    'ledgerColumns': baseUrlApp + 'ledgerReview/columns',//隐患台账表头

    'statistics': baseUrlApp + 'hiddenLedger/statistics',//公司统计

    'problem': baseUrlApp + 'problem',//隐患问题

    'all': baseUrlApp + 'company/all',//公司

    'lawFile': baseUrlApp + 'law',//法律文件

    'fileSearch': baseUrlApp + 'law/search',//法律文件搜索

    'columns': baseUrlApp + 'company/columns',//表头

    'fields': baseUrlApp + 'company/fields',//表单

    'panelist': baseUrlApp + 'company/list',//分页列表
  };
}