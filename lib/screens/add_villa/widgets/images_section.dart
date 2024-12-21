import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../services/image_picker_service.dart';

class ImagesSection extends StatelessWidget {
  final List<String> images;
  final Function(List<String>) onChanged;

  const ImagesSection({
    super.key,
    required this.images,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Villa Pictures',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ...images.map((image) => _buildImagePreview(image)),
            _buildAddButton(context),
          ],
        ),
      ],
    );
  }

  Widget _buildImagePreview(String image) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: kIsWeb
              ? Image.network(image, height: 80, width: 80, fit: BoxFit.cover)
              : Image.file(File(image), height: 80, width: 80, fit: BoxFit.cover),
        ),
        Positioned(
          right: 0,
          top: 0,
          child: GestureDetector(
            onTap: () => onChanged(images.where((i) => i != image).toList()),
            child: const CircleAvatar(
              radius: 12,
              backgroundColor: Colors.red,
              child: Icon(Icons.close, color: Colors.white, size: 16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAddButton(BuildContext context) {
    return GestureDetector(
      onTap: () => _pickImage(context),
      child: Container(
        height: 80,
        width: 80,
        decoration: BoxDecoration(
          color: Colors.blueAccent.withOpacity(0.1),
          border: Border.all(color: Colors.blueAccent),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(Icons.add_a_photo, color: Colors.blueAccent),
      ),
    );
  }

  Future<void> _pickImage(BuildContext context) async {
    final imagePath = await ImagePickerService.pickImage();
    if (imagePath != null) {
      onChanged([...images, imagePath]);
    }
  }
}