import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scet_check/api/api.dart';
import 'package:scet_check/api/request.dart';
import 'package:scet_check/page/environmental_stewardship/check/hiddenParame/components/rectify_components.dart';
import 'package:scet_check/utils/screen/screen.dart';

class HiddenDetails extends StatefulWidget {
  Map? arguments;
  HiddenDetails({Key? key,this.arguments, }) : super(key: key);

  @override
  _HiddenDetailsState createState() => _HiddenDetailsState();
}

class _HiddenDetailsState extends State<HiddenDetails> {
  String companyName = '';//公司名
  String companyId = '';//公司id
  List companyDetails = [];
  bool readOnly = true; //是否为只读
  bool check = true; //查验

  // 获取公司台账详情
  void _getProfile() async {
    var response = await Request().get(Api.url['getByCompanyId'] + '?company_id=$companyId');
    if(response['code'] == 200) {
      companyDetails = response["data"];
      setState(() {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    companyName = widget.arguments?['companyName'] ?? '';
    companyId = widget.arguments?['companyId'].toString() ?? '';
    check = widget.arguments?['check'] ?? false;
    _getProfile();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Material(
      child: ListView(
        padding: EdgeInsets.only(top: 0),
        children: [
          topBar(),
          Column(
            children: List.generate(companyDetails.length, (i) => RectifyComponents.rectifyRow(
                company: companyDetails,
                i: i,
                review: check,
                callBack:(){
                  Navigator.pushNamed(context, '/rectificationProblem',arguments: {'check':check,'readOnly':readOnly});
                }
            )),
          ),
        ],
      ),
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
              Navigator.pop(context);
            },
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Text("$companyName",style: TextStyle(color: Color(0xff323233),fontSize: sp(28)),),
            ),
          ),
          GestureDetector(
            child: Container(
              width: px(40),
              height: px(41),
              margin: EdgeInsets.only(right: px(20)),
              child: check ? Image.asset('lib/assets/icons/form/add.png') :
              Image.asset('lib/assets/images/home/filtrate.png'),
            ),
            onTap: (){
              if(check == true){
                Navigator.pushNamed(context, '/rectificationProblem',arguments: {'check':check,'readOnly':false});
              }
            },
          ),
        ],
      ),
    );
  }

}
