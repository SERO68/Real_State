import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerHelper {
  static Future<String?> pickSingleImage() async {
    if (kIsWeb) {
      return await _pickWebImage();
    } else {
      return await _pickMobileImage();
    }
  }

  static Future<String?> _pickWebImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null && result.files.single.bytes != null) {
      return 'data:image/png;base64,${base64Encode(result.files.single.bytes!)}';
    }
    return null;
  }

  static Future<String?> _pickMobileImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    return pickedFile?.path;
  }
}