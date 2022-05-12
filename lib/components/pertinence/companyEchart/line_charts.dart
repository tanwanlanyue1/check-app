import 'package:flutter/material.dart';
import 'package:flutter_echarts/flutter_echarts.dart';
///折线图
///facName:名称
///unit:单位
///warnLevel:颜色等级
///valueData:数据
class LineCharts extends StatelessWidget {
  final String? facName;
  final String? unit;
  final int? warnLevel;
  final List? valueData;
  LineCharts({Key? key, this.facName, this.warnLevel,this.unit, this.valueData}) : super(key: key);

  var themeColor; 
  void _colorSelect(int? level) {
    switch(level) {
      case 0: themeColor = 'rgba(102, 143, 255, 1)'; break;
      case 1: themeColor = 'rgba(144, 204, 0, 1)'; break;
      case 2: themeColor = 'rgba(255, 219, 0, 1)'; break; 
      case 3: themeColor = 'rgba(255, 134, 0, 1)'; break; 
      case 4: themeColor = 'rgba(102, 143, 255, 1)'; break;
      default: themeColor = 'rgba(102, 143, 255, 1)';
    }
  }

  @override
  Widget build(BuildContext context) {
    _colorSelect(warnLevel);
    return Echarts(
      option: '''
             {
  tooltip: {
    trigger: 'item'
  },
  legend: {
    top: '5%',
    left: 'center'
  },
  series: [
    {
      name: 'Access From',
      type: 'pie',
      radius: ['40%', '70%'],
      avoidLabelOverlap: false,
      itemStyle: {
        borderRadius: 10,
        borderColor: '#fff',
        borderWidth: 2
      },
      label: {
        show: false,
        position: 'center'
      },
      emphasis: {
        label: {
          show: true,
          fontSize: '40',
          fontWeight: 'bold'
        }
      },
      labelLine: {
        show: false
      },
      data: [
        { value: 1048, name: 'Search Engine' },
        { value: 735, name: 'Direct' },
        { value: 580, name: 'Email' },
        { value: 484, name: 'Union Ads' },
        { value: 300, name: 'Video Ads' }
      ]
    }
  ]
}
            ''',
    );
  }
}