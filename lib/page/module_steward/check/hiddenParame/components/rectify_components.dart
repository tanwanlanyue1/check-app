import 'package:flutter/material.dart';
import 'package:scet_check/components/generalduty/date_range.dart';
import 'package:scet_check/components/generalduty/down_input.dart';
import 'package:scet_check/utils/screen/screen.dart';
import 'package:scet_check/utils/time/utc_tolocal.dart';

//整改插件
class RectifyComponents{

  ///问题表单
  /// company:每一项数据
  /// i:第i项
  /// detail:详情使用，序号为圆
  /// review:复查记录是否开启
  /// callBack:回调
  /// history:历史台账
 static  Widget rectifyRow({required Map company,required int i,bool detail = false,bool history = false,Function? callBack}){
   return Container(
     margin: EdgeInsets.only(bottom: px(20),left: px(20),right: px(20),top: px(2)),
     padding: EdgeInsets.only(left: px(16),top: px(20),bottom: px(20)),
     decoration: BoxDecoration(
       color: Colors.white,
       borderRadius: BorderRadius.all(Radius.circular(px(4.0))),
     ),
     child: InkWell(
       child: Column(
         children: [
           Row(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               Visibility(
                 visible: !detail,
                 child: Text(i < 9 ? '0${i+1}':'$i',style: TextStyle(color: Color(0xff4D7FFF),fontSize: sp(28)),),
                 replacement: Container(
                   width: px(40),
                   height: px(40),
                   alignment: Alignment.center,
                   decoration: BoxDecoration(
                     gradient: LinearGradient(//渐变位置
                         begin: Alignment.topLeft,end: Alignment.bottomRight,
                         stops: const [0.0, 1.0], //[渐变起始点, 渐变结束点]
                         colors: const [Color(0xff9EB9FF), Color(0xff608DFF)]//渐变颜色[始点颜色, 结束颜色]
                     ),
                     borderRadius: BorderRadius.all(Radius.circular(30)),
                   ),
                   child: Text('${i+1}',style: TextStyle(color: Colors.white,fontSize: sp(i > 99 ? 22 : 26)),),
                 ),
               ),
               ConstrainedBox(
                 constraints: BoxConstraints(
                   maxWidth: Adapt.screenW()-px(280),
                 ),
                 child: Container(
                   margin: EdgeInsets.only(left: px(16),right: px(12)),
                   child: Text('${company["name"]}',style: TextStyle(color: Color(0xff323233),fontSize: sp(30),overflow: TextOverflow.ellipsis),),
                 ),
               ),
               Container(
                 alignment: Alignment.topLeft,
                 height: px(32),
                 width: px(32),
                 margin: EdgeInsets.only(top: px(8)),
                 child: company['isImportant'] ?? false ? Image.asset('lib/assets/icons/form/star.png') : Text(''),
               ),
               Spacer(),
               Container(
                 width: px(110),
                 height: px(48),
                 alignment: Alignment.center,
                 decoration: BoxDecoration(
                     color: Colorswitchs(company["status"]),
                     borderRadius: BorderRadius.only(
                       topLeft: Radius.circular(px(20)),
                       bottomLeft: Radius.circular(px(20)),
                     )
                 ),//状态；1,未整改;2,已整改;3,整改已通过;4,整改未通过
                 child: Text(switchs(company["status"])
                   ,style: TextStyle(color: Colors.white,fontSize: sp(20)),),
               ),
             ],
           ),
           history ?
           Container(
             margin: EdgeInsets.only(bottom: px(16),top: px(24)),
             child: Row(
               children: [
                 SizedBox(
                   height: px(32),
                   child: Image.asset('lib/assets/icons/my/otherArea.png'),
                 ),
                 Expanded(
                   child: Text(' ${company['district']['name']} ${company['screeningPerson']}',style: TextStyle(color: Color(0xff969799),fontSize: sp(26),fontFamily: 'R',overflow: TextOverflow.ellipsis),),
                 ),
               ],
             ),
           ): Container(),
           Container(
             margin: EdgeInsets.only(top: px(20)),
             child: Row(
               crossAxisAlignment: CrossAxisAlignment.start,
               mainAxisAlignment: MainAxisAlignment.start,
               children: [
                 Container(
                   height: px(18),
                   width: px(18),
                   margin: EdgeInsets.only(left: px(12)),
                   child: Icon(Icons.widgets_outlined,color: Color(0xffC8C9CC),size: 18,),
                 ),
                 Expanded(
                   child: Container(
                     margin: EdgeInsets.only(left: px(30),right: px(50)),
                     child: Text('${company["problemType"]?['name']}',style: TextStyle(color: Color(0xff969799),fontSize: sp(24)),overflow: TextOverflow.ellipsis,),
                   ),
                 ),
                 SizedBox(
                   height: px(32),
                   width: px(32),
                   child: Image.asset('lib/assets/icons/check/sandClock.png'),
                 ),
                 Container(
                   margin: EdgeInsets.only(left: px(24),right: px(80)),
                   child: Text(formatTime(company["createdAt"]),style: TextStyle(color: Color(0xff969799),fontSize: sp(24)),),
                 ),
                 SizedBox(
                   height: px(32),
                   width: px(32),
                   child: Image.asset('lib/assets/icons/check/sandClockEnd.png'),
                 ),
                 Container(
                   margin: EdgeInsets.only(left: px(12),right: px(12)),
                   child: Text(formatTime(company['updatedAt']),style: TextStyle(color: Color(0xff969799),fontSize: sp(24)),overflow: TextOverflow.ellipsis,),
                 ),
               ],
             ),
           ),
         ],
       ),
       onTap: (){
         callBack?.call();
       },
     ),
   );
 }

 ///清单表单列表
 /// company:每一项数据
 /// i:第i项
 /// callBack:回调
 static Widget repertoireRow({required Map company,required int i,Function? callBack}){
   return Container(
     margin: EdgeInsets.only(top: px(20),left: px(20),right: px(20)),
     padding: EdgeInsets.only(left: px(16),top: px(20),bottom: px(20)),
     decoration: BoxDecoration(
       color: Colors.white,
       borderRadius: BorderRadius.all(Radius.circular(px(4.0))),
     ),
     child: InkWell(
       child: Column(
         children: [
           Row(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               Container(
                 width: px(40),
                 height: px(40),
                 alignment: Alignment.center,
                 decoration: BoxDecoration(
                   gradient: LinearGradient(//渐变位置
                       begin: Alignment.topLeft,end: Alignment.bottomRight,
                       stops: const [0.0, 1.0], //[渐变起始点, 渐变结束点]
                       colors: const [Color(0xff9EB9FF), Color(0xff608DFF)]//渐变颜色[始点颜色, 结束颜色]
                   ),
                   borderRadius: BorderRadius.all(Radius.circular(30)),
                 ),
                 child: Text('${i+1}',style: TextStyle(color: Colors.white,fontSize: sp(28)),),
               ),
               ConstrainedBox(
                 constraints: BoxConstraints(
                   maxWidth: Adapt.screenW()-px(250),
                 ),
                 child: Container(
                   margin: EdgeInsets.only(left: px(16),right: px(12)),
                   child: FittedBox(
                     fit: BoxFit.scaleDown, //不让自己调放大，可以缩小
                     child: Text(formatTime(company['updatedAt'])+' 排查清单',style: TextStyle(color: Color(0xff323233),fontSize: sp(30)),),
                   ),
                 ),
               ),
               Container(
                 alignment: Alignment.topLeft,
                 height: px(32),
                 width: px(32),
                 margin: EdgeInsets.only(top: px(8)),
                 child: (company['isImportant'] ?? false) ? Image.asset('lib/assets/icons/form/star.png') : Text(''),
               ),
               Spacer(),
               Container(
                 width: px(110),
                 height: px(48),
                 alignment: Alignment.center,
                 decoration: BoxDecoration(
                     color: inventoryColor(company["status"]),
                     borderRadius: BorderRadius.only(
                       topLeft: Radius.circular(px(20)),
                       bottomLeft: Radius.circular(px(20)),
                     )
                 ),//状态；1,整改中;2,已归档;3,待审核;4,审核已通过;5,审核未通过;6,未提交;
                 child: Text(inventory(company["status"])
                   ,style: TextStyle(color: Colors.white,fontSize: sp(20)),),
               ),
             ],
           ),
           Container(
             margin: EdgeInsets.only(top: px(20)),
             child: Row(
               crossAxisAlignment: CrossAxisAlignment.start,
               mainAxisAlignment: MainAxisAlignment.start,
               children: [
                 Container(
                   margin: EdgeInsets.only(left: px(12)),
                   child: Text('排查人员',style: TextStyle(color: Color(0xff969799),fontSize: sp(24))),
                 ),
                 Expanded(
                   child: Container(
                     margin: EdgeInsets.only(left: px(24),right: px(20)),
                     child: Text('${company["checkPersonnel"]}',style: TextStyle(color: Color(0xff969799),fontSize: sp(24)),overflow: TextOverflow.ellipsis,),
                   ),
                 ),
                 SizedBox(
                   height: px(32),
                   width: px(32),
                   child: Image.asset('lib/assets/icons/check/sandClock.png'),
                 ),
                 Container(
                   margin: EdgeInsets.only(left: px(24),right: px(80)),
                   child: Text(formatTime(company["createdAt"]),style: TextStyle(color: Color(0xff969799),fontSize: sp(24)),),
                 ),
                 SizedBox(
                   height: px(32),
                   width: px(32),
                   child: Image.asset('lib/assets/icons/check/sandClockEnd.png'),
                 ),
                 Container(
                   margin: EdgeInsets.only(left: px(12),right: px(12)),
                   child: Text(formatTime(company['updatedAt']),style: TextStyle(color: Color(0xff969799),fontSize: sp(24)),),
                 ),
               ],
             ),
           ),
         ],
       ),
       onTap: (){
         callBack?.call();
       },
     ),
   );
 }

//问题颜色状态
 static Color Colorswitchs(status){
    switch(status){
      case 0 : return Color(0xffFAAA5A);
      case 1 : return Color(0xff7196F5);
      case 2 : return Color(0xff7196F5);
      case 3 : return Color(0xff95C758);
      case 4 : return Color(0xff7196F5);
      default: return Color(0xffFAAA5A);
    }
  }

  //问题状态 状态:1,未整改;2,已整改;3,整改已通过;4,整改未通过;0,未审核;
  static String switchs(status){
    switch(status){
      case 1 : return '整改未提交';
      case 2 : return '整改已提交';
      case 3 : return '已归档';
      case 4 : return '整改未通过';
      case 0 : return '未提交';
      default: return '未审核';
    }
  }

  //清单状态 1,整改中;2,已归档;3,待审核;4,审核已通过;5,审核未通过;6,未提交;
  static String inventory(status){
    switch(status){
      case 1 : return '整改中';
      case 2 : return '已归档';
      case 3 : return '待审核';
      case 5 : return '未提交';
      case 6 : return '未提交';
      default: return '整改中';
    }
  }

//清单颜色状态
  static Color inventoryColor(status){
    switch(status){
      case 1 : return Color(0xff7196F5);
      case 2 : return Color(0xff95C758);
      case 3 : return Color(0xffFAAA5A);
      case 5 : return Color(0xffFAAA5A);
      case 6 : return Color(0xffFAAA5A);
      default: return Color(0xff7196F5);
    }
  }
  ///状态
  ///title:标题
  ///str:内容
  ///star:是否星标
  static Widget tabText({String? title, String? str,bool star = false,int status = 1}){
    return SizedBox(
      height: px(82),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(left: px(24),right: px(12)),
            child: Text("$title",style: TextStyle(
                fontSize: sp(28.0),
                color: Color(0xff4D7FFF),
                fontWeight: FontWeight.bold
            )),
          ),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: Adapt.screenW()-px(200),
            ),
            child: Container(
              margin: EdgeInsets.only(left: px(16),right: px(12)),
              child: Text("$str",style: TextStyle(
                  fontSize: sp(28.0),
                  color: Color(0XFF323233)
              ),maxLines: 1,overflow: TextOverflow.ellipsis,),
            ),
          ),
          Visibility(
            visible: star,
            child: Container(
              alignment: Alignment.topLeft,
              height: px(32),
              width: px(32),
              child: Image.asset('lib/assets/icons/form/star.png'),
            ),
          ),
          Spacer(),
          Container(
            width: px(110),
            height: px(48),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: Colorswitchs(status),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(px(20)),
                  bottomLeft: Radius.circular(px(20)),
                )
            ),//状态；1,未整改;2,已整改;3,整改已通过;4,整改未通过 5.未提交
            child: Text(switchs(status)
              ,style: TextStyle(color: Colors.white,fontSize: sp(20)),),
          )
        ],
      ),
    );
  }

  ///抽屉
  ///typeStatus:默认状态
  ///status:下拉数据
  ///startTime--endTime:起止时间
  ///callBack 下拉选择回调
  ///trueBack 确认回调
  ///timeBack 日期选择回调
  ///callPop 清空已选择状态
  ///typeProblem 问题选择项
  ///problemType 问题类型数据
  ///defaultData 问题类型默认数据
  ///typeBack 问题类型回调
  ///currentDataList 默认选中项
  static Widget endDrawers(context,{
    required String typeStatus,
    required List status,
    required List currentDataList,
    required DateTime startTime,
    required DateTime endTime,
    List? problemType,
    List? defaultData,
    String? typeProblem,
    Function? callPop,
    Function? callBack,
    Function? timeBack,
    Function? trueBack,
    Function? typeBack,
  }){
    return Container(
      width: px(600),
      color: Color(0xFFFFFFFF),
      padding: EdgeInsets.only(left: px(20), right: px(20),bottom: px(50)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment:MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '问题搜索',
                style: TextStyle(fontSize: sp(30),color: Color(0xFF2E2F33),fontFamily:"M"),
              ),
              IconButton(
                icon: Icon(Icons.clear,color: Colors.red,size: px(39),),
                onPressed: (){
                  Navigator.pop(context);
                },
              )
            ],
          ),
          Row(
            children: [
              Container(
                height: px(72),
                width: px(140),
                alignment: Alignment.centerLeft,
                child: Text('状态：',style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: px(20), right: px(20)),
                  child: DownInput(
                    value: typeStatus,
                    data: status,
                    more: true,
                    currentDataList: currentDataList,
                    callback: (val){
                      callBack?.call(val);
                    },
                  ),
                ),
              ),
            ],
          ),
          problemType != null ?
          Container(
            margin: EdgeInsets.only(top: px(12)),
            child: Row(
              children: [
                Container(
                  height: px(72),
                  width: px(140),
                  alignment: Alignment.centerLeft,
                  child: Text('类型：',style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: px(20), right: px(20)),
                    child: DownInput(
                      value: typeProblem,
                      data: problemType,
                      currentDataList: defaultData,
                      more: true,
                      callback: (val){
                        typeBack?.call(val);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ) :
          Container(),
          Row(
            children: [
              Container(
                height: px(72),
                width: px(140),
                alignment: Alignment.bottomCenter,
                child: Text('起止时间：',style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),),
              ),
              Expanded(
                child: Container(
                  height: px(72),
                  width: px(580),
                  color: Colors.white,
                  margin: EdgeInsets.only(top: px(24),left: px(24),right: px(24)),
                  child: DateRange(
                    start: startTime,
                    end: endTime,
                    showTime: false,
                    callBack: (val) {
                      timeBack?.call(val);
                    },
                  ),
                ),
              ),
            ],
          ),
          Spacer(),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  child: Container(
                    alignment: Alignment.center,
                    color: Color(0xffE6EAF5),
                    height: px(56),
                    padding: EdgeInsets.only(left: px(49),right: px(49)),
                    child: Text('重置',style: TextStyle(color: Colors.black,fontSize: sp(24)),),
                  ),
                  onTap: (){
                    callPop?.call();
                  },
                ),
              ),
              Expanded(
                child: InkWell(
                  child: Container(
                    color: Color(0xff4D7FFF),
                    height: px(56),
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(left: px(49),right: px(49)),
                    child: Text('确定',style: TextStyle(color: Colors.white,fontSize: sp(24)),),
                  ),
                  onTap: (){
                    trueBack?.call();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  ///AppBar
  ///name标题
  static PreferredSizeWidget appBars({String? name,Widget? leading}){
   return AppBar(
     backgroundColor: Color(0xff19191A),
     title: Text(
       '$name',
       style: TextStyle(fontSize: sp(30),fontFamily: 'M'),
     ),
     leading: leading,
     centerTitle: true,
   );
  }

  ///AppBar背景色
  static Widget appBarBac(){
    return Container(
      height: Adapt.padTopH(),
      color: Color(0xff19191A),
    );
  }

 ///时间格式
 ///time:时间
 static String formatTime(time) {
    return utcToLocal(time.toString()).substring(0,10);
  }

}