import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../Widgets/common/loading_dialog.dart';
import '../../../models/place.dart';
import '../../../services/api_service.dart';

class EditPlaceDialog extends StatefulWidget {
  final Place place;
  final Function(String) onSave;

  const EditPlaceDialog({
    super.key,
    required this.place,
    required this.onSave,
  });

  @override
  State<EditPlaceDialog> createState() => _EditPlaceDialogState();
}

class _EditPlaceDialogState extends State<EditPlaceDialog> {
  late TextEditingController _nameController;
  String? _selectedImagePath; // Added missing variable

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.place.name);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Place'),
      content: SingleChildScrollView( // Added for better mobile experience
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildNameField(),
            const SizedBox(height: 16),
            _buildImagePreview(),
            const SizedBox(height: 16),
            _buildUploadButton(),
          ],
        ),
      ),
      actions: _buildDialogActions(context),
    );
  }

  Widget _buildNameField() {
    return TextField(
      controller: _nameController,
      decoration: const InputDecoration(
        labelText: 'Place Name',
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildUploadButton() {
    return ElevatedButton.icon(
      onPressed: _handleImageUpload,
      icon: const Icon(Icons.upload),
      label: const Text(
        'Upload New Picture',
        style: TextStyle(color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _buildImagePreview() {
    if (_selectedImagePath == null && widget.place.imageUrl.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      width: 200,
      height: 150,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: _buildImageWidget(),
      ),
    );
  }

  Widget _buildImageWidget() {
    if (_selectedImagePath != null) {
      if (kIsWeb) {
        return Image.network(_selectedImagePath!, fit: BoxFit.cover);
      } else {
        return Image.file(File(_selectedImagePath!), fit: BoxFit.cover);
      }
    }
    return Image.network(
      widget.place.imageUrl,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return const Center(
          child: Icon(Icons.error_outline, color: Colors.red),
        );
      },
    );
  }

  List<Widget> _buildDialogActions(BuildContext context) {
    return [
      TextButton(
        onPressed: () => Navigator.of(context).pop(),
        child: const Text('Cancel'),
      ),
      ElevatedButton(
        onPressed: () {
          widget.onSave(_nameController.text);
          Navigator.of(context).pop();
        },
        child: const Text('Save'),
      ),
    ];
  }

   Future<void> _handleImageUpload() async {
    try {
      String? imagePath;
      
      if (kIsWeb) {
        imagePath = await _pickImageWeb();
      } else {
        imagePath = await _pickImageMobile();
      }

      if (imagePath != null) {
        LoadingDialog.show(context);

        final result = await ApiService.updatePlaceImage(
          placeId: widget.place.id,
          imagePath: imagePath,
        );

        if (mounted) {
          Navigator.pop(context); // Remove loading dialog

          if (result['success']) {
            setState(() {
              _selectedImagePath = imagePath;
              widget.place.updateImageUrl(result['imageUrl']); // Use the update method
            });
            _showSuccessMessage('Image updated successfully');
          } else {
            _showErrorMessage(result['message']);
          }
        }
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        _showErrorMessage('Failed to upload image. Please try again.');
      }
      print('Error uploading image: $e');
    }
  }

  Future<String?> _pickImageWeb() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result != null && result.files.single.bytes != null) {
        return 'data:image/jpeg;base64,${base64Encode(result.files.single.bytes!)}';
      }
    } catch (e) {
      print('Error picking web image: $e');
      _showErrorMessage('Failed to pick image. Please try again.');
    }
    return null;
  }

  Future<String?> _pickImageMobile() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      return image?.path;
    } catch (e) {
      print('Error picking mobile image: $e');
      _showErrorMessage('Failed to pick image. Please try again.');
    }
    return null;
  }

  void _showSuccessMessage(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _showErrorMessage(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
}