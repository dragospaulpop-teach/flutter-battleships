import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ImageCapturer {
  static Future<File?> captureImage(String source) async {
    final ImagePicker picker = ImagePicker();

    final XFile? image = await picker.pickImage(
        source: source == "camera" ? ImageSource.camera : ImageSource.gallery);
    if (image != null) {
      return File(image.path);
    }

    return null;
  }
}
