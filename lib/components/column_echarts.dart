import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_echarts/flutter_echarts.dart';
import 'package:provider/provider.dart';
import 'package:scet_check/model/provider/provider_details.dart';

//echarts 图表

class ColumnEcharts extends StatefulWidget {
  final List? erectName;//标题
  final List? pieData;//饼图data
  final List? data;//竖状图data
  const ColumnEcharts({Key? key, this.erectName,this.pieData,this.data, }) : super(key: key);

  @override
  _ColumnEchartsState createState() => _ColumnEchartsState();
}

class _ColumnEchartsState extends State<ColumnEcharts> {
  ///
  ///  xAxis 改为yAxis 就是竖轴
  ///  饼图  radius: ['40%', '70%'], 控制内外圈的大小
  ///  label: {
  ///         show: false, 点击是否显示
  ///    fontSize: '40',大小
  ///         position: 'center' 显示的位置
  ///       },
  List erectName = []; //柱状图标题
  List series = []; //柱状图，数据
  List datas = []; // 饼图所需数据

  String columnImage = ''' ''';//横
  String erectImage = ''' ''';//竖状图
  String pie =  ''' ''';//饼图
  String themeColor = '';

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
          // boundaryGap: [0, 0.01]
        },
        yAxis: {
          type: 'category',
          data: ${jsonEncode(erectName)}
        },
        series: ${jsonEncode(series)}
      }
      ''';
    pie =  '''
{
// tooltip: {
//     trigger: 'item'
//   },
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
        position: 'center'
      },
      emphasis: {
        label: {
          show: true,
          fontSize: '24',
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
            // axisLabel:{interval: 0,rotate:40}
            // axisLabel:{interval: 0,}
            axisLabel: {
              interval: 0,
            }
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
          boundaryGap: [0, 0.01]
        },
        yAxis: {
          type: 'category',
          data: ${jsonEncode(erectName)}
        },
        series: ${jsonEncode(series)}
      }
      ''';
    pie =  '''
{
// tooltip: {
//     trigger: 'item'
//   },
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
        position: 'center'
      },
      emphasis: {
        label: {
          show: true,
          fontSize: '24',
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
            // axisLabel:{interval: 0,rotate:40}
            // axisLabel:{interval: 0,}
            axisLabel: {
              interval: 0,
            }
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
    var _homeModel = Provider.of<ProviderDetaild>(context, listen: true);
    return SizedBox(
      width: 550,
      height: 550,
      child: _homeModel.cloumnChart == 0 ?
      Echarts(
        option: pie,
      ):
      _homeModel.cloumnChart == 1 ?
      Echarts(
      option: erectImage,
    ):
      Echarts(
        option: columnImage,
      )
    );
  }

}
