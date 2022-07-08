import 'package:permission_handler/permission_handler.dart';
import 'package:scet_check/components/generalduty/toast_widget.dart';

///请求获取权限
class PermissionManage{

  ///调用全部
  static all() async {
    await storage();
    await camera();
    await photos();
    await location();
    // var stor = await storage();
    // if(stor){
    //   var came = await camera();
    //   if(came){
    //     var photo = await  photos();
    //     if(photo){
    //       var locat = await location();
    //       if(!locat){
    //         refuse();
    //       }
    //     }else{
    //       refuse();
    //     }
    //   }else{
    //     refuse();
    //   }
    // }else{
    //   refuse();
    // }
  }

  ///拒绝权限后再次请求
  static refuse(){
    Future.delayed(Duration(seconds:1)).then((value) => {
      all()
    });
  }
  ///获取储存权限
  static storage() async {
    PermissionStatus storageStatus = await Permission.storage.status;
    if (storageStatus != PermissionStatus.granted) {
      storageStatus = await Permission.storage.request();
      if (storageStatus != PermissionStatus.granted) {
         ToastWidget.showToastMsg('无法存储文件，请先授权！');
      }
    }
  }

  ///获取电话权限
  static phone() async {
    PermissionStatus storageStatus = await Permission.phone.status;
    if (storageStatus != PermissionStatus.granted) {
      storageStatus = await Permission.storage.request();
      if (storageStatus != PermissionStatus.granted) {
        ToastWidget.showToastMsg('无法调用联系人，请先授权！');
      }
    }
  }

  ///获取相机权限
  static camera() async {
    PermissionStatus storageStatus = await Permission.camera.status;
    if (storageStatus != PermissionStatus.granted) {
      storageStatus = await Permission.camera.request();
      if (storageStatus != PermissionStatus.granted) {
        ToastWidget.showToastMsg('无法调用相机，请先授权！');
      }
    }
  }
  ///获取图片权限
  static photos() async {
    PermissionStatus storageStatus = await Permission.photos.status;
    if (storageStatus != PermissionStatus.granted) {
      storageStatus = await Permission.photos.request();
      if (storageStatus != PermissionStatus.granted) {
        ToastWidget.showToastMsg('无法调用图片，请先授权！');
      }
    }
  }

  ///获取位置权限
  static location() async {
    PermissionStatus storageStatus = await Permission.location.status;
    if (storageStatus != PermissionStatus.granted) {
      storageStatus = await Permission.location.request();
      if (storageStatus != PermissionStatus.granted) {
        ToastWidget.showToastMsg('无法获取位置，请先授权！');
      }
    }
  }
}