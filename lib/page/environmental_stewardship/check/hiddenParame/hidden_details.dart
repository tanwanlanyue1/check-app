import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:scet_check/api/api.dart';
import 'package:scet_check/api/request.dart';
import 'package:scet_check/components/date_range.dart';
import 'package:scet_check/components/dialog_pages.dart';
import 'package:scet_check/components/down_input.dart';
import 'package:scet_check/components/form_check.dart';
import 'package:scet_check/components/toast_widget.dart';
import 'package:scet_check/utils/dateUtc/date_utc.dart';
import 'package:scet_check/utils/screen/screen.dart';


class HiddenDetails extends StatefulWidget {
  int companyId;
  String? companyName;
  Function? callBack;
  HiddenDetails({Key? key,required this.companyId,this.companyName,this.callBack}) : super(key: key);

  @override
  _HiddenDetailsState createState() => _HiddenDetailsState();
}

class _HiddenDetailsState extends State<HiddenDetails> {
  List companyDetails = [];

  // 获取公司台账详情
  void _getProfile() async {
    var response = await Request().get(Api.url['getByCompanyId'] + '?company_id=${widget.companyId}');
    if(response['code'] == 200) {
      companyDetails = response["data"];
      setState(() {});
    }
  }
  DateTime start = DateTime.now().add(Duration(days: -7));
  DateTime end = DateTime.now();
  @override
  void initState() {
    // TODO: implement initState
    _getProfile();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.only(top: 0),
      children: [
        topBar(),
        Column(
          children: List.generate(companyDetails.length, (i) => rectifyRow(i: i)),
        ),
        FormCheck.tabText(title: "标题",str: '内容阿达adqeq'),
        FormCheck.rowItem(
          title: "表单标题",
          alignStart: true,
          child: Container(
            height: px(170),
            color: Colors.brown,
            child: Text("asd"),
          )
        ),
        FormCheck.selectWidget(
          hintText: '提示',
          items: [{'name':'selectWidget','value':'452'},{'name':'名字','value':'42'},{'name':'选项','value':'1452'}],
          value: '名字'
        ),
        FormCheck.dataCard(
          children: [
            DownInput(
              data: [{'name':'123','id':1},{'name':'asd'}],
              callback: (val){
                ToastWidget.showDialog(
                  msg: '是否选择这一项？+ $val',
                );
              },
              currentData:{'name':'asd'},
              value: '123',
            ),
          ]
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              SizedBox(
                height: 24.0,
                child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Color(0XFF2288F4)),
                    ),
                  onPressed: () async{
                    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
                        // .then((value){});
                    print(position);
                  },
                  child: Text(
                    '获取定位',
                    style: TextStyle(
                        color: Colors.white,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        Container(
          width: px(300),
          height: px(120),
          color: Colors.teal,
          alignment: Alignment.center,
          child:DialogPages.succeedDialogBtn(
            str: '弹窗',
            bgColor: Color(0xFF8F98B3),
            onTap: () {
              DialogPages.dialog(context);
            },
          ),
        ),
        DateRange(
          start: start,
          end: end,
          callBack: (val){
            start = val[0];
            end = val[1];
            setState(() {});
          },
        ),
      ],
    );
  }

  //头部
  Widget topBar(){
    return Container(
      color: Colors.white,
      height: px(88),
      child: Row(
        children: [
          InkWell(
            child: Container(
              height: px(40),
              width: px(41),
              margin: EdgeInsets.only(left: px(20)),
              child: Image.asset('lib/assets/icons/other/chevronLeft.png',fit: BoxFit.fill,),
            ),
            onTap: (){
              widget.callBack?.call();
            },
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Text("${widget.companyName}",style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),),
            ),
          ),
          GestureDetector(
            child: Container(
              width: px(40),
              height: px(41),
              margin: EdgeInsets.only(right: px(20)),
              child: Image.asset('lib/assets/images/home/filtrate.png'),
            ),
            onTap: (){
            },
          ),
        ],
      ),
    );
  }

  //整改表单
  Widget rectifyRow({required int i}){
    return Container(
      margin: EdgeInsets.all(px(20)),
      padding: EdgeInsets.only(left: px(16),right: px(20),top: px(20)),
      height: px(145),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(px(4.0))),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: px(5)),
            child: Text(i < 9 ?'0${i+1}':'${i+1}',style: TextStyle(color: Color(0xff4D7FFF),fontSize: sp(28)),),
          ),
          Expanded(
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: px(16),right: px(16),top: px(5)),
                      child: Text('${companyDetails[i]["name"]}',style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),),
                    ),
                    SizedBox(
                      height: px(28),
                      width: px(28),
                      child: Icon(Icons.star,color: Color(0xffE65C5C),),
                    )
                  ],
                ),
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
                      Container(
                        margin: EdgeInsets.only(left: px(24),right: px(80)),
                        child: Text('${companyDetails[i]["tag"]}',style: TextStyle(color: Color(0xff969799),fontSize: sp(24)),),
                      ),
                      SizedBox(
                        height: px(18),
                        width: px(18),
                        child: Icon(Icons.access_time,color: Color(0xffC8C9CC),size: 18,),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: px(24),right: px(80)),
                        child: Text(formatTime(companyDetails[i]["updateTime"]),style: TextStyle(color: Color(0xff969799),fontSize: sp(24)),),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Align(
            child: Container(
              width: px(120),
              height: px(56),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: companyDetails[i]['type'] == -1 ? Color(0xffFAAA5A):
                companyDetails[i]['type'] == 1 ? Color(0xff7196F5):
                Color(0xff95C758),
                borderRadius: BorderRadius.all(Radius.circular(px(8.0))),
              ),//状态；-1：未处理;0:处理完；1：处理中
              child: Text(companyDetails[i]['type'] == -1 ? '未整改':
                  companyDetails[i]['type'] == 1 ? '整改中':'整改完成'
                ,style: TextStyle(color: Colors.white,fontSize: sp(24)),),
            ),
          ),
        ],
      ),
    );
  }

  String formatTime(time) {
    return dateUtc(time.toString()).substring(0,10);
  }
}
