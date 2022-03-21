
class Api {
  static const baseUrl = 'https://cz.scet.com.cn:1443/api';

  // static const baseUrlApp = 'http://10.10.1.217:9750';
  static const baseUrlApp = 'http://10.10.1.217:8687/';

  static const baseWs = 'wss://cz.scet.com.cn:1443/api/wfws';

  static final Map url = {
    'version': baseUrlApp + '/manualInsert/platFromXiaZai',//版本更新

    'user': baseUrlApp + 'user',//获取用户数据

    'login': baseUrlApp + 'auth/login',//登录

    'district': baseUrlApp + 'district',//片区统计

    'industry': baseUrlApp + 'industry',//行业

    'lawFile': baseUrlApp + 'law',//法律文件

    'company': baseUrlApp + 'company',//获取全部企业

    'companyList': baseUrlApp + 'company/list',//企业分页列表

    'companyCount': baseUrlApp + 'company/count',//获取企业数据总数

    'inventory': baseUrlApp + 'inventory',//保存清单

    'inventoryList': baseUrlApp + 'inventory/list',//清单分页列表

    "uploadImg": baseUrlApp + 'file/upload?savePath=清单/',// 上传图片

    'problem': baseUrlApp + 'problem',//获取问题

    'problemList': baseUrlApp + 'problem/list',//问题分页列表

    'problemStatistics': baseUrlApp + 'problem/statistics',//问题统计数目

    'problemCount': baseUrlApp + 'problem/count',//获取数据总数

    'problemType': baseUrlApp + 'problem_type',//问题类型

    'solution': baseUrlApp + 'solution',//整改

    'solutionList': baseUrlApp + 'solution/list',//整改分页列表

    'review': baseUrlApp + 'review',//复查

    'reviewList': baseUrlApp + 'review/list',//复查分页列表

    'inventoryReport': baseUrlApp + 'inventory_report',//清单报告


    'fileSearch': baseUrlApp + 'law/search',//法律文件搜索

    'versions':baseUrlApp + 'version/list',//检测App更新

  };
}