import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ImageCapturer {
  static Future<File?> captureImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      return File(image.path);
    }

    return null;
  }
}
