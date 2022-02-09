import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:scet_check/api/request.dart';
import 'package:scet_check/components/toast_widget.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

class SaveUtil {
  // isAsset本地图片   默认网络图片
  static Future<void> saveImage(String imageUrl, {bool isAsset: false}) async {
    try {
      if (imageUrl == null) {
        ToastWidget.showToastMsg('保存失败，图片地址不存在！');
      }

      // 权限检测
      PermissionStatus storageStatus = await Permission.storage.status;
      if (storageStatus != PermissionStatus.granted) {
        storageStatus = await Permission.storage.request();
        if (storageStatus != PermissionStatus.granted) {
          ToastWidget.showToastMsg('无法存储图片，请先授权！');
        }
      }

      // 保存的图片数据
      Uint8List imageBytes;
      if (isAsset == true) {
        ByteData bytes = await rootBundle.load(imageUrl);
        imageBytes = bytes.buffer.asUint8List();
      } else {
        // 保存网络图片
        imageBytes = await Request().getbytes(imageUrl);
      }

      // 保存图片
      final result = await ImageGallerySaver.saveImage(imageBytes);
      if (result['isSuccess']) {
        ToastWidget.showToastMsg('保存图片成功！');
      } else {
        ToastWidget.showToastMsg('保存图片失败！');
      }

    } catch (e) {
      print(e.toString());
    }
  }
}