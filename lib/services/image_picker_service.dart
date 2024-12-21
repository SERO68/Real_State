import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import '../utils/file_helper.dart';

class ImagePickerService {
  static Future<String?> pickImage() async {
    try {
      if (kIsWeb) {
        return await _pickImageWeb();
      } else {
        return await _pickImageMobile();
      }
    } catch (e) {
      print('Error picking image: $e');
      return null;
    }
  }

  static Future<String?> _pickImageWeb() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result != null && result.files.single.bytes != null) {
        // Convert the image to base64 for web
        final bytes = result.files.single.bytes!;
        final fileName = result.files.single.name;
        final mimeType = FileHelper.getMimeType(fileName);
        
        return 'data:$mimeType;base64,${base64Encode(bytes)}';
      }
    } catch (e) {
      print('Error picking web image: $e');
    }
    return null;
  }

  static Future<String?> _pickImageMobile() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        // For mobile, we can use the file path
        return image.path;
      }
    } catch (e) {
      print('Error picking mobile image: $e');
    }
    return null;
  }

  static Future<List<String>> pickMultipleImages() async {
    try {
      if (kIsWeb) {
        return await _pickMultipleImagesWeb();
      } else {
        return await _pickMultipleImagesMobile();
      }
    } catch (e) {
      print('Error picking multiple images: $e');
      return [];
    }
  }

  static Future<List<String>> _pickMultipleImagesWeb() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: true,
      );

      if (result != null) {
        return result.files
            .where((file) => file.bytes != null)
            .map((file) {
              final mimeType = FileHelper.getMimeType(file.name);
              return 'data:$mimeType;base64,${base64Encode(file.bytes!)}';
            })
            .toList();
      }
    } catch (e) {
      print('Error picking multiple web images: $e');
    }
    return [];
  }

  static Future<List<String>> _pickMultipleImagesMobile() async {
    try {
      final ImagePicker picker = ImagePicker();
      final List<XFile> images = await picker.pickMultiImage(
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      return images.map((image) => image.path).toList();
    } catch (e) {
      print('Error picking multiple mobile images: $e');
      return [];
    }
  }
}