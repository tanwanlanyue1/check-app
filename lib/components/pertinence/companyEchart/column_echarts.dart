import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_echarts/flutter_echarts.dart';
import 'package:scet_check/utils/screen/screen.dart';

///echarts 图表
///erectName:标题
///pieData:饼图data
///data:竖状图data
///erect:是否展示竖状图
class ColumnEcharts extends StatefulWidget {
  final List? erectName;//标题
  final List? pieData;//饼图data
  final List? data;//竖状图data
  final String? title;//标题
  final bool erect;//是否展示竖状图
  const ColumnEcharts({Key? key, this.erectName,this.pieData,this.data,this.title,this.erect = false}) : super(key: key);

  @override
  _ColumnEchartsState createState() => _ColumnEchartsState();
}

class _ColumnEchartsState extends State<ColumnEcharts> {

  List erectName = []; //柱状图标题
  List series =  []; //柱状图，数据
  List datas = []; // 饼图所需数据

  String columntitle = '';//标题
  String columnImage = ''' ''';//横
  String erectImage = ''' ''';//竖状图
  String pie =  ''' ''';//饼图
  Color backgroundColor = Colors.white;//背景色

  @override
  void initState() {
    // TODO: implement initState
    alterData();
    super.initState();
  }

  @override
  void didUpdateWidget(ColumnEcharts oldWidget) {
    super.didUpdateWidget(oldWidget);
    alterData();
  }

  ///赋值数据
  void alterData(){
    columntitle = widget.title ?? '';
    series = widget.data ?? [];
    erectName = widget.erectName ?? [];
    datas = widget.pieData ?? [];
    // columnImage =  '''
    //   {
    //     title: {
    //       left: 'center',
    //        top: '12',
    //       text: '$columntitle'
    //     },
    //     tooltip: {
    //       trigger: 'axis',
    //       axisPointer: {
    //         type: 'shadow'
    //       }
    //     },
    //     legend: {},
    //     grid: {
    //       left: '3%',
    //       right: '4%',
    //       bottom: '3%',
    //       containLabel: true
    //     },
    //     xAxis: {
    //       type: 'value',
    //       boundaryGap: [0, 0.01],
    //     },
    //     yAxis: {
    //       type: 'category',
    //       data: ${jsonEncode(erectName)},
    //        axisLabel : {//坐标轴刻度标签的相关设置。
    //          formatter : function(params){
    //                   var \$newParamsName = "";// 最终拼接成的字符串
    //                   var \$paramsNameNumber = params.length;// 实际标签的个数
    //                   var \$provideNumber = 4;// 每行能显示的字的个数
    //                   var \$rowNumber = Math.ceil(\$paramsNameNumber / \$provideNumber);// 换行的话，需要显示几行，向上取整
    //                   if (\$paramsNameNumber > \$provideNumber) {
    //                     for (var p = 0; p < \$rowNumber; p++) {
    //                      var \$tempStr = "";// 表示每一次截取的字符串
    //                       var \$start = p * \$provideNumber;// 开始截取的位置
    //                       var \$end = \$start + \$provideNumber;// 结束截取的位置
    //                        if (p == \$rowNumber - 1) {
    //                         \$tempStr = params.substring(\$start, \$paramsNameNumber);
    //                        }else{
    //                        \$tempStr = params.substring(\$start, \$end) + "\\n";
    //                        }
    //                           \$newParamsName += \$tempStr;// 最终拼成的字符串
    //                     }
    //                   }else{
    //                    \$newParamsName = params;
    //                   }
    //                   return \$newParamsName
    //               }
    //      },
    //     },
    //   }
    //   ''';
    //series: ${jsonEncode(series)}
    pie =  '''
        {
         tooltip: {
            trigger: 'item',
         },
          legend: {
            bottom: '10',
            left: 'center',
             icon: "circle",
              formatter:(name)=>{
                      if(!name) return ''
                      if(name.length > 10){
                        name = name.slice(0,10) + "..."
                      }
                      return name
                    }
          },
          series: [
            {
             //hoverAnimation: false, // 取消掉环形图鼠标移上去时自动放大
             selectedMode:'single',
              selectedOffset:20,
              type: 'pie',
              radius: ['40%', '70%'],
              avoidLabelOverlap: false,
              top: '-10%',//饼图距离上面的距离
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
                            return  `\${value['value']}`+`\\n`+
                            `\${value['name']}`;
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
      backgroundColor: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
          { offset: 0, color: '#C5D0FE' },
          { offset: 1, color: '#E6EBFB' }
        ]),
        title: {
          left: 'center',
           top: '12',
          text: '$columntitle'
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
            // axisLabel:{rotate : 50 ,interval:0},//斜着展示, interval:间隔
            axisLabel : {//坐标轴刻度标签的相关设置。
             formatter : function(params){
                      var \$newParamsName = "";// 最终拼接成的字符串
                      var \$paramsNameNumber = params.length;// 实际标签的个数
                      var \$provideNumber = 4;// 每行能显示的字的个数
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
         series: {
             'type': 'bar',
             'data': ${jsonEncode(series)},
             itemStyle: {
              color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
                { offset: 0, color: '#8AB1FF' },
                { offset: 1, color: '#3378FF' }
              ])
            }
           }
      }
      ''';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
          height: px(720+((erectName.length/2)*20)),
          child: widget.erect ?
          Echarts(
            reloadAfterInit: true,
            option: pie,
          ):
          Echarts(
            option: erectImage,
          )
          //   :Echarts(
          //   reloadAfterInit: true,
          //   option: columnImage,
          // )
      ),
    );
  }
}