import 'dart:io';
import 'dart:ui' as ui;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:image_editor_dove/image_editor.dart';
import 'package:image_editor_dove/model/float_text_model.dart';
import 'package:image_editor_dove/widget/drawing_board.dart';
import 'package:image_editor_dove/widget/editor_panel_controller.dart';
import 'package:image_editor_dove/widget/float_text_widget.dart';
import 'package:image_editor_dove/widget/image_editor_delegate.dart';
import 'package:image_editor_dove/widget/text_editor_page.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';

///图片编辑器ui扩展
class EditorImage extends ImageEditorDelegate{

  Color operatorStatuscolor(bool choosen) => choosen ? Colors.red : Colors.white;

  @override
  Widget addTextWidget(double limitSize, OperateType type, {required bool choosen}) {
    return Column(
      children: [
        Icon(Icons.title, size: limitSize, color: operatorStatuscolor(choosen)),
      ],
    );
  }
  ///头部返回按钮
  @override
  Widget backBtnWidget(double limitSize) {
    return Icon(Icons.chevron_left, size: 35);
  }

  @override
  Widget get boldTagWidget => Text(
    '粗体',
    style: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold),
  );

  @override
  List<Color> get brushColors => const <Color>[
    Color(0xFFFA4D32),
    Color(0xFFFF7F1E),
    Color(0xFF2DA24A),
    Color(0xFFF2F2F2),
    Color(0xFF222222),
    Color(0xFF1F8BE5),
    Color(0xFF4E43DB),
  ];


  @override
  Widget brushWidget(double limitSize, OperateType type, {required bool choosen}) {
    return Icon(Icons.brush_outlined, size: limitSize, color: operatorStatuscolor(choosen));
  }

  @override
  Widget doneWidget(BoxConstraints constraints) {
    return Container(
      constraints: constraints,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(6)),
          gradient: const LinearGradient(colors: [Colors.green, Colors.greenAccent])),
      child: Text(
        '保存',
        style: TextStyle(fontSize: 15, color: Colors.white),
      ),
    );
  }

  @override
  Widget flipWidget(double limitSize, OperateType type, {required bool choosen}) {
    return Icon(Icons.flip, size: limitSize, color: operatorStatuscolor(choosen));
  }

  @override
  Widget mosaicWidget(double limitSize, OperateType type, {required bool choosen}) {
    return Icon(Icons.auto_awesome_mosaic, size: limitSize, color: operatorStatuscolor(choosen));
  }

  @override
  Widget get resetWidget => Text('复位', style: TextStyle(color: Colors.white, fontSize: 16));

  @override
  Widget rotateWidget(double limitSize, OperateType type, {required bool choosen}) {
    return Icon(Icons.rotate_right, size: limitSize, color: operatorStatuscolor(choosen));
  }

  @override
  SliderThemeData sliderThemeData(BuildContext context) => SliderTheme.of(context).copyWith(
    trackHeight: 2,
    thumbColor: Colors.white,
    disabledThumbColor: Colors.white,
    activeTrackColor: const Color(0xFFF83112),
    inactiveTrackColor: Colors.white.withOpacity(0.5),
    // overlayShape: overlayRadius(),
  );

  @override
  Widget get sliderRightWidget => _txtFlatWidget('大');

  ///
  Widget _txtFlatWidget(String txt) {
    return Text(
      txt,
      style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 13),
    );
  }

  @override
  List<Color> get textColors => const <Color>[
    Color(0xFFFA4D32),
    Color(0xFFFF7F1E),
    Color(0xFF2DA24A),
    Color(0xFFF2F2F2),
    Color(0xFF222222),
    Color(0xFF1F8BE5),
    Color(0xFF4E43DB),
  ];

  @override
  // TODO: implement textConfigModel
  TextConfigModel get textConfigModel =>  DefaultTextConfigModel();

  @override
  // TODO: implement textSelectedBorder
  Border get textSelectedBorder => DashBorder();

  @override
  Widget undoWidget(double limitSize) => Icon(Icons.undo, size: limitSize, color: Colors.white);

  @override
  Widget get sliderLeftWidget => _txtFlatWidget('小');

}

///图片编辑器扩展
class ImageEditorExtend extends ImageEditor {
  final Key? key;
  final File originImage;
  final Directory? savePath;
  const ImageEditorExtend({
    this.key,
    required this.originImage,
    this.savePath,
  }) : super(key: key,originImage: originImage);

  static ImageEditorDelegate uiDelegate = DefaultImageEditorDelegate();

  @override
  State<StatefulWidget> createState() {
    return ImageEditorExtendState();
  }

}

class ImageEditorExtendState extends State<ImageEditor>
    with SignatureBinding, ScreenShotBinding, RotateCanvasBinding, TextCanvasBind,LittleWidgetBind, WindowUiBinding{
  final EditorPanelControllerBind _panelController = EditorPanelControllerBind();


  double get headerHeight => windowStatusBarHeight;

  double get bottomBarHeight => 105 + windowBottomBarHeight;

  ///调整编辑框高度
  double get canvasHeight => screenHeight - bottomBarHeight - headerHeight;

  ///：操作面板按钮的水平空间。
  Widget get controlBtnSpacing => SizedBox(width: 5.toDouble());

  ///S将编辑后的图像保存到[小部件]。savePath]或[getTemporaryDirectory())
  void saveImage() {
    _panelController.takeShot.value = true;
    screenshotController.capture(pixelRatio: 1.0).then((value) async {
      final paths = widget.savePath ?? await getTemporaryDirectory();
      final file = await File('${paths.path}/' + DateTime.now().toString() + '.jpg').create();
      file.writeAsBytes(value ?? []);
      decodeImg().then((value) {
        if (value == null) {
          Navigator.pop(context);
        } else {
          Navigator.pop(context, EditorImageResult(value.width, value.height, file));
        }
      }).catchError((e) {
        Navigator.pop(context);
      });
    });
  }

  Future<ui.Image?> decodeImg() async {
    return await decodeImageFromList(widget.originImage.readAsBytesSync());
  }

  static ImageEditorState? of(BuildContext context) {
    return context.findAncestorStateOfType<ImageEditorState>();
  }

  @override
  void initState() {
    super.initState();
    initPainter();
  }

  @override
  Widget build(BuildContext context) {
    _panelController.screenSize ??= windowSize;
    return Material(
      color: Colors.black,
      child: Listener(
        onPointerMove: (v) {
          _panelController.pointerMoving(v);
        },
        child: Screenshot(
          controller: screenshotController,
          child: Stack(
            children: [
              //appBar
              ValueListenableBuilder<bool>(
                  valueListenable: _panelController.showAppBar,
                  builder: (ctx, value, child) {
                    return AnimatedPositioned(
                        top: value ? 0 : -headerHeight,
                        left: 0, right: 0,
                        child: ValueListenableBuilder<bool>(
                            valueListenable: _panelController.takeShot,
                            builder: (ctx, value, child) {
                              return Opacity(
                                opacity: value ? 0 : 1,
                                child: AppBar(
                                  iconTheme: IconThemeData(color: Colors.white, size: 16),
                                  leading: backWidget(),
                                  backgroundColor: Colors.transparent,
                                  actions: [
                                    resetWidget(onTap: resetCanvasPlate)
                                  ],
                                ),
                              );
                            }),
                        duration: _panelController.panelDuration);
                  }),
              //canvas
              Positioned.fromRect(
                  rect: Rect.fromLTWH(0, headerHeight, screenWidth, canvasHeight),
                  child: RotatedBox(
                    quarterTurns: rotateValue,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        _buildImage(),
                        _buildBrushCanvas(),
                        // buildTextCanvas(),
                      ],
                    ),
                  )),
              //bottom operation(control) bar
              ValueListenableBuilder<bool>(
                  valueListenable: _panelController.showBottomBar,
                  builder: (ctx, value, child) {
                    return AnimatedPositioned(
                        bottom: value ? 0 : -bottomBarHeight,
                        child: SizedBox(
                          width: screenWidth,
                          child: ValueListenableBuilder<bool>(
                              valueListenable: _panelController.takeShot,
                              builder: (ctx, value, child) {
                                return Opacity(
                                  opacity: value ? 0 : 1,
                                  child: _buildControlBar(),
                                );
                              }),
                        ),
                        duration: _panelController.panelDuration);
                  }),
              //trash bin
              ValueListenableBuilder<bool>(
                  valueListenable: _panelController.showTrashCan,
                  builder: (ctx, value, child) {
                    return AnimatedPositioned(
                        bottom: value ? _panelController.trashCanPosition.dy : -headerHeight,
                        left: _panelController.trashCanPosition.dx,
                        child: _buildTrashCan(),
                        duration: _panelController.panelDuration);
                  }),
              //text canvas
              Positioned.fromRect(
                  rect: Rect.fromLTWH(0, headerHeight, screenWidth, screenHeight),
                  child: RotatedBox(
                    quarterTurns: rotateValue,
                    child: buildTextCanvas(),
                  )),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildBrushCanvas() {
    if (pathRecord.isEmpty) {
      pathRecord.add(Signature(
        controller: painterController,
        backgroundColor: Colors.transparent,
      ));
    }
    return StatefulBuilder(builder: (ctx, canvasSetter) {
      this.canvasSetter = canvasSetter;
      return realState?.ignoreWidgetByType(OperateType.brush, Stack(
        children: pathRecord,
      )) ?? SizedBox();
    });
  }


  Widget _buildControlBar() {
    return Container(
      color: Colors.black,
      width: screenWidth,
      height: bottomBarHeight,
      padding: EdgeInsets.only(left: 16, right: 16, bottom: windowBottomBarHeight),
      child: Column(
        children: [
          Expanded(
            child: ValueListenableBuilder<OperateType>(
              valueListenable: _panelController.operateType,
              builder: (ctx, value, child) {
                return Opacity(
                  opacity: _panelController.show2ndPanel() ? 1 : 0,
                  child: Row(
                    mainAxisAlignment: value == OperateType.brush ?
                    MainAxisAlignment.spaceAround : MainAxisAlignment.end,
                    children: [
                      if(value == OperateType.brush)
                        ..._panelController.brushColor
                            .map<Widget>((e) => CircleColorWidget(
                          color: e,
                          valueListenable: _panelController.colorSelected,
                          onColorSelected: (color) {
                            if(pColor.value == color.value) return;
                            changePainterColor(color);
                          },
                        ))
                            .toList(),
                      SizedBox(width: 35.toDouble()),
                      unDoWidget(onPressed: undo),
                      if(value == OperateType.mosaic)
                        SizedBox(width: 7.toDouble()),
                    ],
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: Row(
              children: [
                _buildButton(OperateType.brush, '画笔', onPressed: () {
                  switchPainterMode(DrawStyle.normal);
                }),
                controlBtnSpacing,
                _buildButton(OperateType.text, '文字', onPressed: toTextEditorPage),
                controlBtnSpacing,
                _buildButton(OperateType.flip, '镜像', onPressed: flipCanvas),
                controlBtnSpacing,
                _buildButton(OperateType.rotated, '旋转', onPressed: rotateCanvasPlate),
                controlBtnSpacing,
                _buildButton(OperateType.mosaic, '马赛克', onPressed: () {
                  switchPainterMode(DrawStyle.mosaic);
                }),
                Expanded(child: SizedBox()),
                doneButtonWidget(onPressed: saveImage),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildImage() {
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.rotationY(flipValue),
      child: Container(
        alignment: Alignment.center,
        child: Image.file(widget.originImage),
      ),
    );
  }

  //垃圾桶
  Widget _buildTrashCan() {
    return ValueListenableBuilder<Color>(
        valueListenable: _panelController.trashColor,
        builder: (ctx, value, child) {
          final bool isActive = value.value == EditorPanelController.defaultTrashColor.value;
          return Container(
            width: _panelController.tcSize.width,
            height: _panelController.tcSize.height,
            decoration: BoxDecoration(
                color: value,
                borderRadius: BorderRadius.all(Radius.circular(8))
            ),
            child: Column(
              children: [
                SizedBox(width: 12.toDouble()),
                Icon(Icons.delete_outline, size: 32, color: Colors.white,),
                SizedBox(width: 4.toDouble()),
                Text(isActive ? '移动到这里进行删除' : '删除',
                  style: TextStyle(color: Colors.white, fontSize: 12),)
              ],
            ),
          );
        });
  }

  Widget _buildButton(OperateType type, String txt, {VoidCallback? onPressed}) {
    return GestureDetector(
      onTap: () {
        _panelController.switchOperateType(type);
        onPressed?.call();
      },
      child: ValueListenableBuilder(
        valueListenable: _panelController.operateType,
        builder: (ctx, value, child) {
          return SizedBox(
            width: 44,
            height: 41,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                getOperateTypeRes(type, choosen: _panelController.isCurrentOperateType(type)),
                Text(
                  txt,
                  style: TextStyle(
                      color: _panelController.isCurrentOperateType(type)
                          ? const Color(0xFFFA4D32) : const Color(0xFF999999), fontSize: 11),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

///图片
extension _BaseImageEditorState on State {
  ImageEditorExtendState? get realState {
    if (this is ImageEditorExtendState) {
      return this as ImageEditorExtendState;
    }
    return null;
  }
}

///监听画笔事件
mixin LittleWidgetBind<T extends StatefulWidget> on State<T> {

  ///go back widget
  Widget backWidget({VoidCallback? onPressed}) {
    return GestureDetector(
      onTap: onPressed ?? () {
        Navigator.pop(context);
      },
      child: ImageEditor.uiDelegate.buildBackWidget(),
    );
  }

  ///控制栏中的操作按钮
  Widget getOperateTypeRes(OperateType type, {required bool choosen}) {
    return ImageEditor.uiDelegate.buildOperateWidget(type, choosen: choosen);
  }

  ///动作完成的部件
  Widget doneButtonWidget({VoidCallback? onPressed}) {
    return GestureDetector(
      onTap: onPressed,
      child: ImageEditor.uiDelegate.buildDoneWidget(),
    );
  }

  ///撤消操作
  Widget unDoWidget({VoidCallback? onPressed}) {
    return GestureDetector(
      onTap: onPressed,
      child: ImageEditor.uiDelegate.buildUndoWidget(),
    );
  }

  ///忽略指针事件by [OperateType]
  Widget ignoreWidgetByType(OperateType type, Widget child) {
    return ValueListenableBuilder(
        valueListenable: realState?._panelController.operateType ?? ValueNotifier(OperateType.non),
        builder: (ctx, type, c) {
          return IgnorePointer(
            ignoring: type != OperateType.brush && type != OperateType.mosaic,
            child: child,
          );
        });
  }

  ///reset button
  Widget resetWidget({VoidCallback? onTap}) {
    return Padding(
      padding: EdgeInsets.only(top: 6, bottom: 6 , right: 16),
      child: ValueListenableBuilder<OperateType>(
        valueListenable: realState?._panelController.operateType ?? ValueNotifier(OperateType.non),
        builder: (ctx, value, child) {
          return Offstage(
            offstage: value != OperateType.rotated,
            child: GestureDetector(
              onTap: onTap,
              child: ImageEditorExtend.uiDelegate.resetWidget,
            ),);
        },
      ),
    );
  }

}

///文本画布
mixin TextCanvasBind<T extends StatefulWidget> on State<T> {
  late StateSetter textSetter;

  final List<FloatTextModel> textModels = [];

  void addText(FloatTextModel model) {
    textModels.add(model);
    refreshTextCanvas();
  }

  ///从画布中删除文本
  void deleteTextWidget(FloatTextModel target) {
    textModels.remove(target);
    refreshTextCanvas();
  }

  void toTextEditorPage() {
    realState?._panelController.hidePanel();
    Navigator.of(context).push(PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
          return TextEditorPage();
        }))
        .then((value) {
      realState?._panelController.showPanel();
      if (value is FloatTextModel) {
        addText(value);
      }
    });
  }

  void refreshTextCanvas() {
    textSetter.call(() {});
  }

  Widget buildTextCanvas() {
    return StatefulBuilder(builder: (tCtx, setter) {
      textSetter = setter;
      return Stack(
        alignment: Alignment.center,
        children: textModels
            .map<Widget>((e) => Positioned(
          child: _wrapWithGesture(
              FloatTextWidget(
                textModel: e,
              ),
              e),
          left: e.left,
          top: e.top,
        ))
            .toList(),
      );
    });
  }

  Widget _wrapWithGesture(Widget child, FloatTextModel model) {
    void pointerDetach(DragEndDetails? details) {
      if (details != null) {
        //触摸事件了
        realState?._panelController.releaseText(details, model, () {
          deleteTextWidget(model);
        });
      } else {
        //触摸事件取消
        realState?._panelController.doIdle();
      }
      model.isSelected = false;
      refreshTextCanvas();
      realState?._panelController.showPanel();
    }

    return GestureDetector(
      child: child,
      onPanStart: (_) {
        realState?._panelController.moveText(model);
      },
      onPanUpdate: (details) {
        model.isSelected = true;
        model.left += details.delta.dx;
        model.top += details.delta.dy;
        refreshTextCanvas();
        realState?._panelController.hidePanel();
      },
      onPanEnd: (d) {
        pointerDetach(d);
      },
      onPanCancel: () {
        pointerDetach(null);
      },
    );
  }
}

///控制器
class EditorPanelControllerBind {

  static const defaultTrashColor = Color(0x26ffffff);

  EditorPanelControllerBind() {
    colorSelected = ValueNotifier(brushColor.first.value);
  }

  Size? screenSize;

  ///take shot动作监听器
  /// *用于隐藏一些非相对ui。
  /// *例如，隐藏状态栏，隐藏底部栏
  ValueNotifier<bool> takeShot = ValueNotifier(false);

  ValueNotifier<bool> showTrashCan = ValueNotifier(false);

  ///trash background color
  ValueNotifier<Color> trashColor = ValueNotifier(defaultTrashColor);

  ValueNotifier<bool> showAppBar = ValueNotifier(true);

  ValueNotifier<bool> showBottomBar = ValueNotifier(true);

  ValueNotifier<OperateType> operateType = ValueNotifier(OperateType.non);

  ///是当前操作类型
  bool isCurrentOperateType(OperateType type) => type.index == operateType.value.index;

  /// is need to show second panel.
  ///  * in some operate type like drawing path, it need a 2nd panel for change color.
  bool show2ndPanel() => operateType.value == OperateType.brush || operateType.value == OperateType.mosaic;

  final List<Color> brushColor = const <Color>[
    Color(0xFFFA4D32),
    Color(0xFFFF7F1E),
    Color(0xFF2DA24A),
    Color(0xFFF2F2F2),
    Color(0xFF222222),
    Color(0xFF1F8BE5),
    Color(0xFF4E43DB),
  ];

  late ValueNotifier<int> colorSelected;

  void selectColor(Color color) {
    colorSelected.value = color.value;
  }

  ///开关操作类型
  void switchOperateType(OperateType type) {
    operateType.value = type;
  }


  ///移动物体
  /// * non:不移动。
  MoveStuff moveStuff = MoveStuff.non;

  ///垃圾桶的位置
  Offset trashCanPosition = Offset(111, (20 + window.padding.bottom));

  ///trash can size.
  final Size tcSize = Size(153, 77);

  ///The top and bottom panel's slide duration.
  final Duration panelDuration = const Duration(milliseconds: 300);

  ///隐藏底部和顶部(应用程序)栏。
  void hidePanel() {
    showAppBar.value = false;
    showBottomBar.value = false;
    switchTrashCan(true);
  }

  ///隐藏底部和顶部(应用程序)栏。
  void showPanel() {
    showAppBar.value = true;
    showBottomBar.value = true;
    switchTrashCan(false);
  }

  ///隐藏/显示垃圾桶。
  void switchTrashCan(bool show) {
    showTrashCan.value = show;
  }

  ///改变垃圾桶的颜色。
  void switchTrashCanColor(bool isInside) {
    trashColor.value = isInside ? Colors.red : defaultTrashColor;
  }

  ///move text.
  void moveText(FloatTextModel model) {
    moveStuff = MoveStuff.text;
    movingTarget = model;
  }

  ///release the moving-text.
  void releaseText(DragEndDetails details, FloatTextModel model, Function throwCall) {
    if(isThrowText(pointerUpPosition??Offset.zero, model)) {
      throwCall.call();
    }
    doIdle();
  }

  ///停止移动
  void doIdle() {
    movingTarget = null;
    pointerUpPosition = null;
    moveStuff = MoveStuff.non;
    switchTrashCanColor(false);
  }

  ///moving object.
  /// * must based on [BaseFloatModel].
  /// * most time it's used to find the [movingTarget] that who just realeased.
  BaseFloatModel? movingTarget;

  ///cache the target taht just released.
  Offset? pointerUpPosition;

  ///指针移动的回调
  void pointerMoving(PointerMoveEvent event) {
    pointerUpPosition = event.localPosition;
    switch(moveStuff) {
      case MoveStuff.non:
        break;
      case MoveStuff.text:
        if(movingTarget is FloatTextModel) {
          switchTrashCanColor(isThrowText(event.localPosition, movingTarget!));
        }
        break;
    }
  }

  ///决定文本是否被删除
  bool isThrowText(Offset pointer,BaseFloatModel target) {
    final Rect textR = Rect.fromCenter(center: pointer,
        width: target.floatSize?.width??1,
        height: target.floatSize?.height??1);
    final Rect tcR = Rect.fromLTWH(
        screenSize!.width - (trashCanPosition.dx*2),
        screenSize!.height - trashCanPosition.dy - tcSize.height,
        tcSize.width,
        tcSize.height);
    return textR.overlaps(tcR);
  }

}
