import 'dart:typed_data';
import 'package:image/image.dart' as img;

class ImageCompression {
  static Future<Uint8List?> compressImage(
    Uint8List input, {
    int maxWidth = 1920,
    int maxHeight = 1080,
    int quality = 85,
  }) async {
    try {
      // Decode image
      final originalImage = img.decodeImage(input);
      if (originalImage == null) return null;

      // Calculate new dimensions while maintaining aspect ratio
      double ratio = originalImage.width / originalImage.height;
      int targetWidth = originalImage.width;
      int targetHeight = originalImage.height;

      if (targetWidth > maxWidth) {
        targetWidth = maxWidth;
        targetHeight = (maxWidth / ratio).round();
      }

      if (targetHeight > maxHeight) {
        targetHeight = maxHeight;
        targetWidth = (maxHeight * ratio).round();
      }

      // Create a resized copy of the image
      final resizedImage = img.copyResize(
        originalImage,
        width: targetWidth,
        height: targetHeight,
        interpolation: img.Interpolation.linear,
      );

      // Encode the image as JPEG with the specified quality
      final compressedData = img.encodeJpg(resizedImage, quality: quality);

      return Uint8List.fromList(compressedData);
    } catch (e) {
      print('Error compressing image: $e');
      return null;
    }
  }

  static Future<Uint8List?> compressImageFile(
    Uint8List input, {
    CompressFormat format = CompressFormat.jpeg,
    int quality = 85,
  }) async {
    try {
      // Decode image
      final originalImage = img.decodeImage(input);
      if (originalImage == null) return null;

      // Encode based on format
      switch (format) {
        case CompressFormat.jpeg:
          return Uint8List.fromList(
            img.encodeJpg(originalImage, quality: quality),
          );
        case CompressFormat.png:
          return Uint8List.fromList(img.encodePng(originalImage));
        case CompressFormat.webp:
          return Uint8List.fromList(
            img.encodePng(originalImage),
          );
      }
    } catch (e) {
      print('Error compressing image file: $e');
      return null;
    }
  }

  static Future<Uint8List?> resizeImage(
    Uint8List input, {
    required int width,
    required int height,
    bool maintainAspectRatio = true,
  }) async {
    try {
      // Decode image
      final originalImage = img.decodeImage(input);
      if (originalImage == null) return null;

      if (maintainAspectRatio) {
        // Calculate dimensions maintaining aspect ratio
        final ratio = originalImage.width / originalImage.height;
        if (width / height > ratio) {
          width = (height * ratio).round();
        } else {
          height = (width / ratio).round();
        }
      }

      // Resize image
      final resizedImage = img.copyResize(
        originalImage,
        width: width,
        height: height,
        interpolation: img.Interpolation.linear,
      );

      // Encode as PNG (lossless)
      return Uint8List.fromList(img.encodePng(resizedImage));
    } catch (e) {
      print('Error resizing image: $e');
      return null;
    }
  }
}

enum CompressFormat {
  jpeg,
  png,
  webp,
}

// Extension methods for easy use
extension ImageCompressionExtension on Uint8List {
  Future<Uint8List?> compress({
    int maxWidth = 1920,
    int maxHeight = 1080,
    int quality = 85,
  }) {
    return ImageCompression.compressImage(
      this,
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      quality: quality,
    );
  }

  Future<Uint8List?> resize({
    required int width,
    required int height,
    bool maintainAspectRatio = true,
  }) {
    return ImageCompression.resizeImage(
      this,
      width: width,
      height: height,
      maintainAspectRatio: maintainAspectRatio,
    );
  }
}