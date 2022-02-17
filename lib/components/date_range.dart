import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:scet_check/utils/screen/screen.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

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

  String? startTime, endTime;

  @override
  void initState() {
    startTime = widget.showTime? formatTime(widget.start) : formatTime2(widget.start);
    endTime = widget.showTime? formatTime(widget.end): formatTime2(widget.end);
    super.initState();
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
              Text(
                '$startTime ~ $endTime',
                style: TextStyle(
                    fontSize: ScreenUtil().setSp(22.0),
                    color: Color(0XFF585858)
                ),
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.justify,
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
                      if (val is PickerDateRange) {
                        var picked = [
                          val.startDate,
                          val.endDate,];
                        widget.callBack?.call(picked);
                        startTime = formatTime(val.startDate);
                        endTime = formatTime(val.endDate);
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