import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:scet_check/utils/screen/screen.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

///日期范围选择
class DateRange extends StatefulWidget {
  final DateTime start;
  final DateTime end;
  final bool showTime;
  final Function? callBack;
  const DateRange({Key? key, required this.start,required  this.end, this.callBack, this.showTime = true}):super(key: key);

  @override
  _DateRangeState createState() => _DateRangeState();
}

class _DateRangeState extends State<DateRange> {

  String? startTime, endTime;//默认选择的时间范围

  @override
  void initState() {
    startTime = widget.showTime? formatTime(widget.start) : formatTime2(widget.start);
    endTime = widget.showTime? formatTime(widget.end): formatTime2(widget.end);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant DateRange oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    if(widget.start != oldWidget.start || widget.end != oldWidget.end){
      startTime = widget.showTime? formatTime(widget.start) : formatTime2(widget.start);
      endTime = widget.showTime? formatTime(widget.end): formatTime2(widget.end);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setHeight(60.0),
      color: Color(0xffF5F6FA),
      child: OutlinedButton(
        style: ButtonStyle(
          padding: ButtonStyleButton.allOrNull<EdgeInsetsGeometry>(EdgeInsets.fromLTRB(px(10.0), 0.0, px(5.0), 0.0)),
          side: ButtonStyleButton.allOrNull<BorderSide>(BorderSide(color: Color(0XffF5F6FA)))
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            startTime == null ?  
              Text(
                '请选择时间区间', 
                style: TextStyle(
                  fontSize: sp(28.0),
                  color: Color(0XFFA8ABB3)
                )
              ) 
            :
              Expanded(
                child: Text(
                  '${startTime.toString().substring(0,10)} ~ ${endTime.toString().substring(0,10)}',
                  style: TextStyle(
                      fontSize: sp(22.0),
                      color: Color(0XFF585858)
                  ),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
            Padding(
              padding: EdgeInsets.only(right: px(10)),
              child: Icon(
                Icons.date_range, 
                size: sp(30.0),
                color: Color(0XFF8A8E99)
              ),
            )
          ],
        ),
        onPressed: () async {
          DateTime start = widget.start;
          DateTime end = widget.end;
          return showDialog(context: context, builder: (context){
            return GestureDetector(
              child: Center(
                child: SizedBox(
                  height: px(750),
                  width: px(550),
                  child: SfDateRangePicker(
                    selectionMode: DateRangePickerSelectionMode.range,
                    headerHeight: 50,
                    showActionButtons: true,
                    backgroundColor: Colors.white,
                    initialSelectedRange: PickerDateRange(start, end),
                    cancelText: "取消",
                    confirmText: "确定",
                    minDate: DateTime(start.year-15,start.month,),
                    maxDate: DateTime(start.year+1,start.month,),
                    onCancel: (){
                      Navigator.pop(context);
                    },
                    onSubmit: (val) async{
                      Navigator.pop(context);
                      List picked = [];
                      if (val is PickerDateRange) {
                        //拿到当天的最后一秒
                        if(val.endDate != null){
                          picked = [
                            val.startDate,
                            DateTime(val.endDate!.year,val.endDate!.month,val.endDate!.day, 23,59,59),
                          ];
                        }else{
                          picked = [
                            val.startDate,
                            DateTime(val.startDate!.year,val.startDate!.month,val.startDate!.day, 23,59,59),
                          ];
                        }
                        widget.callBack?.call(picked);
                        startTime = formatTime(val.startDate);
                        endTime = formatTime(picked[1]);
                        setState(() {});
                      }
                    },
                  ),
                ),
              ),
              onTap: (){
                Navigator.pop(context);
              },
            );
          });
        }    
      )
    );
  }

  String formatTime(time) {
    return DateFormat("yyyy-MM-dd HH:mm:ss").format(time);
  }
  String formatTime2(time) {
    return DateFormat("yyyy-MM-dd").format(time);
  }
}