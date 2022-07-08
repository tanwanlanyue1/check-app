import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:intl/intl.dart';
import 'package:scet_check/utils/screen/screen.dart';

///日期选择
class TimeSelect extends StatefulWidget {
  final GlobalKey<ScaffoldState>? scaffoldKey;
  final DateTime? time;
  final String? hintText;
  final int? type;
  final callBack;
  const TimeSelect({Key? key, required this.scaffoldKey, this.time, this.hintText, this.type,this.callBack}):super(key: key);

  @override
  _TimeSelectState createState() => _TimeSelectState();
}

class _TimeSelectState extends State<TimeSelect> {

  String? currentTime;

  @override
  void initState() {
    super.initState();
    currentTime = widget.time != null ?  formatTime(widget.time!) : '';
  }

  @override
  void didUpdateWidget(covariant TimeSelect oldWidget) {
    // TODO: implement didUpdateWidget
    if(widget.time != oldWidget.time){
      currentTime = widget.time != null ?  formatTime(widget.time!) : '';
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: px(56.0),
      color: Color(0xffF5F6FA),
      child: OutlinedButton(
        style: ButtonStyle(
            padding: ButtonStyleButton.allOrNull<EdgeInsetsGeometry>(EdgeInsets.fromLTRB(px(10.0), 0.0, px(10.0), 0.0)),
            side: ButtonStyleButton.allOrNull<BorderSide>(BorderSide(color: Color(0xffF5F6FA)))
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: currentTime == null ?
              Text(
                '${widget.hintText}',
                style: TextStyle(
                  fontSize: sp(28.0),
                  color: Color(0XFFB0B2B8)
                )
              )
              :
              Text(
                widget.type == 7 ?
                '${currentTime?.substring(0,10)}':
                '$currentTime',
                style: TextStyle(
                  fontSize: sp(26.0),
                  color: Color(0XFF585858)
                ),
                overflow: TextOverflow.ellipsis,
              )
            ),
            Padding(
              padding: EdgeInsets.only(left: 2.0),
              child: Icon(
                Icons.date_range,
                size: sp(24.0),
                color: Color(0XFF8A8E99)
              ),
            )
          ],
        ),
        onPressed:() {
          showPickerDateTime24(context);
        },
      )
    );
  }

  showPickerDateTime24(BuildContext context) {
    Picker(
        cancelText:'取消',
        confirmText:'确定',
        selectedTextStyle:TextStyle(color: Colors.blue),
        cancelTextStyle: TextStyle(
            fontSize: sp(28.0),
            fontWeight: FontWeight.w600,
            color: Color(0XFF585858)
        ),
        confirmTextStyle: TextStyle(
            fontSize: sp(28.0),
            fontWeight: FontWeight.w600,
            color: Color(0XFF585858)
        ),
        textStyle:TextStyle(
          color: Color(0XFF585858),
          fontSize: sp(28.0),
        ),
        adapter: DateTimePickerAdapter(
            type: widget.type == null ? PickerDateTimeType.kYMDHM : widget.type!,
            isNumberMonth: true,
            yearSuffix: "年",
            monthSuffix: "月",
            daySuffix: "日"
        ),
        title: Text(
            "请选择时间",
            style: TextStyle(
                fontSize: sp(28.0),
                fontWeight: FontWeight.w600,
                color: Color(0XFF585858)
            )
        ),
        delimiter: [
          PickerDelimiter(column: 3, child: Container(
            width: 8.0,
            alignment: Alignment.center,
          )),
          PickerDelimiter(column: 5, child: Container(
            width: 12.0,
            alignment: Alignment.center,
            child: Text((widget.type ?? 0) > 7 ? ':' : '', style: TextStyle(fontWeight: FontWeight.bold)),
            color: Colors.white,
          )),
        ],
        onConfirm: (Picker picker, List value) {
          DateTime time = DateTime.parse((picker.adapter as DateTimePickerAdapter).value.toString());
          widget.callBack(time);
          setState(() {
            if((widget.type ?? 8) > 7){
              currentTime = formatTime(time);
            }else{
              currentTime = formatTimes(time);
            }
          });
        }).show(widget.scaffoldKey!.currentState!);
  }

  String formatTime(DateTime time) {
    return DateFormat("yyyy-MM-dd HH:mm:ss").format(time);
  }
  ///转换天
  String formatTimes(DateTime time) {
    return DateFormat("yyyy-MM-dd").format(time);
  }
}