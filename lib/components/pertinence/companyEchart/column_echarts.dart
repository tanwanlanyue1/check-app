import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_echarts/flutter_echarts.dart';
import 'package:provider/provider.dart';
import 'package:scet_check/model/provider/provider_details.dart';
import 'package:scet_check/utils/screen/screen.dart';

///echarts 图表
///erectName:标题
///pieData:饼图data
///data:竖状图data
class ColumnEcharts extends StatefulWidget {
  final List? erectName;//标题
  final List? pieData;//饼图data
  final List? data;//竖状图data
  const ColumnEcharts({Key? key, this.erectName,this.pieData,this.data, }) : super(key: key);

  @override
  _ColumnEchartsState createState() => _ColumnEchartsState();
}

class _ColumnEchartsState extends State<ColumnEcharts> {

  List erectName = []; //柱状图标题
  List series =  []; //柱状图，数据
  List datas = []; // 饼图所需数据

  String columnImage = ''' ''';//横
  String erectImage = ''' ''';//竖状图
  String pie =  ''' ''';//饼图
  String themeColor = '';
  ///全局变量  判断展示哪一个图表
  late ProviderDetaild _providerDetaild;

  @override
  void initState() {
    series = widget.data ?? [];
    erectName = widget.erectName ?? [];
    datas = widget.pieData ?? [];
    // TODO: implement initState
    columnImage =  '''
      {
        title: {
          text: '柱状图'
        },
        tooltip: {
          trigger: 'axis',
          axisPointer: {
            type: 'shadow'
          }
        },
        legend: {},
        grid: {
          left: '3%',
          right: '4%',
          bottom: '3%',
          containLabel: true
        },
        xAxis: {
          type: 'value',
          boundaryGap: [0, 0.01],
        },
        yAxis: {
          type: 'category',
          data: ${jsonEncode(erectName)},
           axisLabel : {//坐标轴刻度标签的相关设置。
             formatter : function(params){
                      var \$newParamsName = "";// 最终拼接成的字符串
                      var \$paramsNameNumber = params.length;// 实际标签的个数
                      var \$provideNumber = 5;// 每行能显示的字的个数
                      var \$rowNumber = Math.ceil(\$paramsNameNumber / \$provideNumber);// 换行的话，需要显示几行，向上取整
                      if (\$paramsNameNumber > \$provideNumber) {
                        for (var p = 0; p < \$rowNumber; p++) {
                         var \$tempStr = "";// 表示每一次截取的字符串
                          var \$start = p * \$provideNumber;// 开始截取的位置
                          var \$end = \$start + \$provideNumber;// 结束截取的位置
                           if (p == \$rowNumber - 1) {
                            \$tempStr = params.substring(\$start, \$paramsNameNumber);
                           }else{
                           \$tempStr = params.substring(\$start, \$end) + "\\n";
                           }
                              \$newParamsName += \$tempStr;// 最终拼成的字符串
                        }
                      }else{
                       \$newParamsName = params;
                      }
                      return \$newParamsName
                  }
         },
        },
        series: ${jsonEncode(series)}
      }
      ''';
    pie =  '''
{
  legend: {
    bottom: '5%',
    left: 'center',
     icon: "circle"
  },
  series: [
    {
      name: '',
     //hoverAnimation: false, // 取消掉环形图鼠标移上去时自动放大
     selectedMode:'single',
      selectedOffset:20,
      type: 'pie',
      radius: ['40%', '70%'],
      avoidLabelOverlap: false,
      // top: '-30%',//饼图距离上面的距离
      //color:['red','blue','gray','yellow','teal'],//颜色
      itemStyle: { //调整相邻的边距和圆角
        borderRadius: 10,
        borderColor: '#fff',
        borderWidth: 2
      },
      label: {
        show: false, /*是否一直显示*/
        position: 'center',
         formatter: function (value) {
                            return `\${value['name']}`+
                            `\\n`+`\${value['value']}`;
                          },
      },
      emphasis: {
        label: {
          show: true,
          fontSize: '12',
          fontColor:'#323233'
        }
      },
      labelLine: {
        show: false
      },
      data: ${jsonEncode(datas)}
    }
  ]
}
      ''';
    erectImage =  '''
      {
        title: {
          text: '柱状图'
        },
          legend: {
            top: '5%',
            left: 'center',
            icon: 'square'
          },
        tooltip: {
          trigger: 'axis',
          axisPointer: {
            type: 'shadow'
          }
        },
        grid: {
          left: '3%',
          right: '4%',
          bottom: '3%',
          containLabel: true
        },
         xAxis: {
            type: 'category',
            data: ${jsonEncode(erectName)},
             axisLabel : {//坐标轴刻度标签的相关设置。
             formatter : function(params){
                      var \$newParamsName = "";// 最终拼接成的字符串
                      var \$paramsNameNumber = params.length;// 实际标签的个数
                      var \$provideNumber = 5;// 每行能显示的字的个数
                      var \$rowNumber = Math.ceil(\$paramsNameNumber / \$provideNumber);// 换行的话，需要显示几行，向上取整
                      if (\$paramsNameNumber > \$provideNumber) {
                        for (var p = 0; p < \$rowNumber; p++) {
                         var \$tempStr = "";// 表示每一次截取的字符串
                          var \$start = p * \$provideNumber;// 开始截取的位置
                          var \$end = \$start + \$provideNumber;// 结束截取的位置
                           if (p == \$rowNumber - 1) {
                            \$tempStr = params.substring(\$start, \$paramsNameNumber);
                           }else{
                           \$tempStr = params.substring(\$start, \$end) + "\\n";
                           }
                              \$newParamsName += \$tempStr;// 最终拼成的字符串
                        }
                      }else{
                       \$newParamsName = params;
                      }
                      return \$newParamsName
                  }
             },
            axisTick: {
              alignWithLabel: true,
              length: 0,
            },
          },
          yAxis: {
            type: 'value',
            name:'数量',
                  position: 'left',
          },
        series: ${jsonEncode(series)}
      }
      ''';
    super.initState();
  }

  @override
  void didUpdateWidget(ColumnEcharts oldWidget) {
    super.didUpdateWidget(oldWidget);
    series = widget.data ?? [];
    erectName = widget.erectName ?? [];
    datas = widget.pieData ?? [];
    columnImage =  '''
      {
        title: {
          text: '柱状图'
        },
        tooltip: {
          trigger: 'axis',
          axisPointer: {
            type: 'shadow'
          }
        },
        legend: {},
        grid: {
          left: '3%',
          right: '4%',
          bottom: '3%',
          containLabel: true
        },
        xAxis: {
          type: 'value',
          boundaryGap: [0, 0.01],
        },
        yAxis: {
          type: 'category',
          data: ${jsonEncode(erectName)},

     axisLabel : {//坐标轴刻度标签的相关设置。
       formatter : function(params){
                var \$newParamsName = "";// 最终拼接成的字符串
                var \$paramsNameNumber = params.length;// 实际标签的个数
                var \$provideNumber = 5;// 每行能显示的字的个数
                var \$rowNumber = Math.ceil(\$paramsNameNumber / \$provideNumber);// 换行的话，需要显示几行，向上取整
                if (\$paramsNameNumber > \$provideNumber) {
                  for (var p = 0; p < \$rowNumber; p++) {
                   var \$tempStr = "";// 表示每一次截取的字符串
                    var \$start = p * \$provideNumber;// 开始截取的位置
                    var \$end = \$start + \$provideNumber;// 结束截取的位置
                     if (p == \$rowNumber - 1) {
                      \$tempStr = params.substring(\$start, \$paramsNameNumber);
                     }else{
                     \$tempStr = params.substring(\$start, \$end) + "\\n";
                     }
                        \$newParamsName += \$tempStr;// 最终拼成的字符串
                  }
                }else{
                 \$newParamsName = params;
                }
                return \$newParamsName
            }
   },

        },
        series: ${jsonEncode(series)}
      }
      ''';
    pie =  '''
{
  legend: {
    bottom: '5%',
    left: 'center',
     icon: "circle"
  },
  series: [
    {
      name: '',
     //hoverAnimation: false, // 取消掉环形图鼠标移上去时自动放大
     selectedMode:'single',
      selectedOffset:20,
      type: 'pie',
      radius: ['40%', '70%'],
      avoidLabelOverlap: false,
      // top: '-30%',//饼图距离上面的距离
      //color:['red','blue','gray','yellow','teal'],//颜色
      itemStyle: { //调整相邻的边距和圆角
        borderRadius: 10,
        borderColor: '#fff',
        borderWidth: 2
      },

      label: {
        show: false, /*是否一直显示*/
        position: 'center',
                 formatter: function (value) {
                            return `\${value['name']}`+
                            `\\n`+`\${value['value']}`;
                          },
      },
      emphasis: {
        label: {
          show: true,
          fontSize: '12',
          fontColor:'#323233'
        }
      },
      labelLine: {
        show: false
      },
      data: ${jsonEncode(datas)}
    }
  ]
}
      ''';
    erectImage =  '''
      {
        title: {
          text: '柱状图'
        },
          legend: {
            top: '5%',
            left: 'center',
            icon: 'square'
          },
        tooltip: {
          trigger: 'axis',
          axisPointer: {
            type: 'shadow'
          }
        },
        grid: {
          left: '3%',
          right: '4%',
          bottom: '3%',
          containLabel: true
        },
         xAxis: {
            type: 'category',
            data: ${jsonEncode(erectName)},
            axisTick: {
              alignWithLabel: true,
              length: 0,
            },
             axisLabel : {//坐标轴刻度标签的相关设置。
             formatter : function(params){
                      var \$newParamsName = "";// 最终拼接成的字符串
                      var \$paramsNameNumber = params.length;// 实际标签的个数
                      var \$provideNumber = 5;// 每行能显示的字的个数
                      var \$rowNumber = Math.ceil(\$paramsNameNumber / \$provideNumber);// 换行的话，需要显示几行，向上取整
                      if (\$paramsNameNumber > \$provideNumber) {
                        for (var p = 0; p < \$rowNumber; p++) {
                         var \$tempStr = "";// 表示每一次截取的字符串
                          var \$start = p * \$provideNumber;// 开始截取的位置
                          var \$end = \$start + \$provideNumber;// 结束截取的位置
                           if (p == \$rowNumber - 1) {
                            \$tempStr = params.substring(\$start, \$paramsNameNumber);
                           }else{
                           \$tempStr = params.substring(\$start, \$end) + "\\n";
                           }
                              \$newParamsName += \$tempStr;// 最终拼成的字符串
                        }
                      }else{
                       \$newParamsName = params;
                      }
                      return \$newParamsName
                  }
             },
          },
          yAxis: {
            type: 'value',
            name:'数量',
                  position: 'left',
          },
        series: ${jsonEncode(series)}
      }
      ''';
  }

  @override
  Widget build(BuildContext context) {
    _providerDetaild = Provider.of<ProviderDetaild>(context, listen: true);
    return SizedBox(
      width: px(550),
      height: px(700),
      child: _providerDetaild.cloumnChart == 0 ?
      Echarts(
        option: pie,
      ):
      _providerDetaild.cloumnChart == 1 ?
      Echarts(
        option: erectImage,
      ):Echarts(
        option: columnImage,
      )
    );
  }

}