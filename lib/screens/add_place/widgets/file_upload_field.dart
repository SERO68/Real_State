import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class FileUploadField extends StatelessWidget {
  final String label;
  final String? imageUrl;
  final Function(String?) onImagePicked;

  const FileUploadField({
    super.key,
    required this.label,
    required this.imageUrl,
    required this.onImagePicked,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () async {
            try {
              final result = await FilePicker.platform.pickFiles(
                type: FileType.image,
                allowMultiple: false,
              );

              if (result != null) {
                if (kIsWeb) {
                  final bytes = result.files.first.bytes!;
                  final base64Image = 'data:image/jpeg;base64,${base64Encode(bytes)}';
                  onImagePicked(base64Image);
                } else {
                  onImagePicked(result.files.first.path);
                }
              }
            } catch (e) {
              print('Error picking image: $e');
            }
          },
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: _buildPreview(),
          ),
        ),
      ],
    );
  }

  Widget _buildPreview() {
    if (imageUrl == null) {
      return const Center(
        child: Icon(Icons.add_a_photo, size: 40, color: Colors.grey),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: kIsWeb
          ? Image.network(
              imageUrl!,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Center(
                  child: Icon(Icons.error, color: Colors.red),
                );
              },
            )
          : Image.file(
              File(imageUrl!),
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Center(
                  child: Icon(Icons.error, color: Colors.red),
                );
              },
            ),
    );
  }
}