import 'package:flutter/material.dart';
import 'package:scet_check/utils/screen/screen.dart';

class Search extends StatefulWidget {
  final Color bgColor;
  final Color textFieldColor;
  final hintText;
  final Function? search;
  final Function? screen;

  Search({
    this.bgColor = Colors.white,
    this.textFieldColor = Colors.white,
    this.hintText ='搜索',
    this.search,
    this.screen,
  });

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final TextEditingController _controller = TextEditingController(); //输入框控制器
  FocusNode _contentFocusNode = FocusNode();
@override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      height: px(112.0),
      alignment: Alignment.centerLeft,
      color: widget.bgColor,
      child:Row(
        children: [
          Expanded(
            child: Container(
              width: px(587.0),
              height: px(72.0),
              padding: EdgeInsets.only(left: px(24.0)),
              margin: EdgeInsets.only(left: px(24.0)),
              decoration: BoxDecoration(
                color: widget.textFieldColor,
                borderRadius: BorderRadius.circular(px(12.0)),
              ),
              child: TextField(
                maxLines: 1,
                // style: TextStyle(fontSize: sp(28.0), textBaseline: TextBaseline.ideographic),
                controller: _controller,
                focusNode: _contentFocusNode,
                decoration: InputDecoration(
                  // contentPadding: EdgeInsets.only(top:5, left: px(-10.0)),
                    hintText: widget.hintText,
                    hintStyle: TextStyle(fontSize: sp(28.0), color: Color(0xff5C6066)),
                    border: InputBorder.none,
                    icon: Image.asset(
                      'lib/assets/icons/other/search.png',
                      width: px(30.0),
                      height: px(30.0),
                      fit: BoxFit.cover,
                    ),
                    suffixIcon: Container(
                      width: px(30.0),
                      height: px(30.0),
                      padding: EdgeInsets.symmetric(vertical: px(10.0)),
                      child: GestureDetector(
                        onTap: () {
                          if (_controller.text == '') {
                            _contentFocusNode.unfocus();
                          } else {
                            _controller.clear();
                          }
                        },
                        child: Image.asset(
                          'lib/assets/icons/other/close.png',
                          width: px(30.0),
                          height: px(30.0),
                        ),
                      ),
                    )),
                textInputAction: TextInputAction.search,
                onSubmitted: (value) {
                  widget.search?.call(value);
                },
                onChanged: (value) {
                  widget.search?.call(value);
                },
                onEditingComplete: () {
                  _contentFocusNode.unfocus();
                },
              ),
            ),
          ),
          InkWell(
            child: Container(
              width: px(139),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('筛选',style: TextStyle(fontSize: sp(28),color: Color(0xFF787A80)),),
                  Image.asset('lib/assets/icons/other/select.png',width: px(25),height: px(25),)
                ],
              ),
            ),
            onTap:(){
              widget.screen?.call();
            },
          )
        ],
      ),
    );
  }
}
