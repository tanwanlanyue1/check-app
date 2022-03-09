import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:scet_check/api/api.dart';
import 'package:scet_check/api/request.dart';
import 'package:scet_check/components/down_input.dart';
import 'package:scet_check/components/form_check.dart';
import 'package:scet_check/page/module_steward/check/hiddenParame/components/client_list_page.dart';
import 'package:scet_check/page/module_steward/check/statisticAnaly/components/layout_page.dart';
import 'package:scet_check/utils/screen/screen.dart';

///隐患排查
class PotentialRisksIndentification extends StatefulWidget {
  const PotentialRisksIndentification({Key? key}) : super(key: key);

  @override
  _PotentialRisksIndentificationState createState() => _PotentialRisksIndentificationState();
}

class _PotentialRisksIndentificationState extends State<PotentialRisksIndentification> {
  List tabBar = ["全园区","第一片区","第二片区","第三片区"];//头部
  final PageController pagesController = PageController();//页面控制器
  int _companyId = 0;//公司
  String _companyName = '';//公司名称
  List companyList = [];//全部公司数据
  Position? position;//定位
  int pageIndex = 0;//下标

  /// 获取全部公司
  void _getLatestData() async {
    Map<String, dynamic> params = pageIndex == 0 ? {}: {'area':pageIndex};
    var response = await Request().get(Api.url['all'], data: params);
    if(response['code'] == 200) {
      setState(() {
        companyList = response["data"];
      });
    }
  }

  ///签到
  void singIn(){
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context,state){
            return ListView(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: px(32)),
                  child: FormCheck.dataCard(
                      title: '签到',
                      children: [
                        FormCheck.rowItem(
                            title: '企业名称',
                            titleColor: Color(0xff323233),
                            child: FormCheck.inputWidget(hintText: '公司名称')
                        ),
                        FormCheck.rowItem(
                            title: '归属片区',
                            titleColor: Color(0xff323233),
                            child: FormCheck.inputWidget(hintText: '第一片区')
                        ),
                        FormCheck.rowItem(
                            title: '区域位置',
                            titleColor: Color(0xff323233),
                            child: FormCheck.inputWidget(hintText: '西区')
                        ),
                        FormCheck.rowItem(
                          title: '实时定位',
                          titleColor: Color(0xff323233),
                          child: Row(
                            children: [
                              position == null ?Container(): Text('${position?.longitude}',style: TextStyle(color: Color(0xff969799),fontSize: sp(28)),),
                              position == null ?Container(): Text('${position?.latitude}',style: TextStyle(color: Color(0xff969799),fontSize: sp(28))),
                              Container(
                                height: px(48),
                                margin: EdgeInsets.only(left: px(24)),
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all<Color>(Color(0XFF2288F4)),
                                  ),
                                  onPressed: () async{
                                    position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
                                    state(() {});},
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
                        FormCheck.rowItem(
                          title: '排查人员',
                          titleColor: Color(0xff323233),
                          child: DownInput(
                            value: '陈秋好',
                            data: [{'name':'陈秋好'},{"name":"张三"}],
                            more:true,
                          ),
                        ),
                        FormCheck.rowItem(
                            title: '排查日期',
                            titleColor: Color(0xff323233),
                            child: FormCheck.inputWidget(hintText: '西区')
                        ),
                        FormCheck.rowItem(
                            title: '填报人员',
                            titleColor: Color(0xff323233),
                            child: FormCheck.inputWidget(hintText: '陈秋好')
                        ),
                        FormCheck.submit(
                          cancel: (){
                            Navigator.pop(context);
                          },
                          submit: (){
                            Navigator.pop(context);
                          }
                        )
                      ]
                  ),
                )
              ],
            );
          });
        }
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    _getLatestData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutPage(
      tabBar: tabBar,
      callBack: (val){
        pageIndex = val;
        _getLatestData();
        setState(() {});
      },
      pageBody: [
        Column(
          children: [
            Container(
              height: px(24),
              margin: EdgeInsets.only(left:px(20),right: px(20)),
              color: Colors.white,
            ),
            Visibility(
              visible: companyList.isNotEmpty,
              child: Expanded(
                child: ClientListPage(
                  companyList: companyList,
                  callBack: (id,name){
                    _companyId = id;
                    _companyName = name;
                    Navigator.pushNamed(context, '/hiddenDetails',
                        arguments: {'companyId': _companyId,'companyName': _companyName,'check':true}
                        );
                    setState(() {});
                  },
                ),
              ),
            ),
          ],
        ),

        Column(
          children: [
            Container(
              height: px(24),
              margin: EdgeInsets.only(left:px(20),right: px(20)),
              color: Colors.white,
            ),
            Visibility(
              visible: companyList.isNotEmpty,
              child: Expanded(
                child: ClientListPage(
                  companyList: companyList,
                  callBack: (id,name){
                    singIn();
                    // _companyId = id;
                    // _companyName = name;
                    // details = true;
                    setState(() {});
                  },
                ),
              ),
            ),
          ],
        ),

        Column(
          children: [
            Container(
              height: px(24),
              margin: EdgeInsets.only(left:px(20),right: px(20)),
              color: Colors.white,
            ),
            Visibility(
              visible: companyList.isNotEmpty,
              child: Expanded(
                child: ClientListPage(
                  companyList: companyList,
                  callBack: (id,name){
                    _companyId = id;
                    _companyName = name;
                    Navigator.pushNamed(context, '/hiddenDetails',
                        arguments: {'companyId': _companyId,'companyName': _companyName,'check':true}
                    );
                    setState(() {});
                  },
                ),
              ),
            ),
          ],
        ),

        Column(
          children: [
            Container(
              height: px(24),
              margin: EdgeInsets.only(left:px(20),right: px(20)),
              color: Colors.white,
            ),
            Visibility(
              visible: companyList.isNotEmpty,
              child: Expanded(
                child: ClientListPage(
                  companyList: companyList,
                  callBack: (id,name){
                    _companyId = id;
                    _companyName = name;
                    Navigator.pushNamed(context, '/hiddenDetails',
                        arguments: {'companyId': _companyId,'companyName': _companyName,'check':true}
                    );
                    setState(() {});
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

}
