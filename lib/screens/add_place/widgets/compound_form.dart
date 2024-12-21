import 'package:flutter/material.dart';
import '../../../Widgets/common/custom_container.dart';
import '../../../services/api_service.dart';

import '../../../widgets/common/loading_overlay.dart';
import '../../dashboard/dashboard_screen.dart';
import 'custom_submit_button.dart';
import 'custom_text_field.dart';
import 'file_upload_field.dart';
import 'form_header.dart';

class CompoundForm extends StatefulWidget {
  final bool isDesktop;

  const CompoundForm({
    super.key,
    required this.isDesktop,
  });

  @override
  State<CompoundForm> createState() => _CompoundFormState();
}

class _CompoundFormState extends State<CompoundForm> {
  final TextEditingController _compoundNameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  String? _placeImage;
  bool _isLoading = false;

  @override
  void dispose() {
    _compoundNameController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomContainer(
          isDesktop: widget.isDesktop,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const FormHeader(),
              const SizedBox(height: 20),
              CustomTextField(
                label: 'Compound Name',
                hintText: 'Enter the Compound name',
                controller: _compoundNameController,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Location',
                hintText: 'Enter the Compound location',
                controller: _locationController,
              ),
              const SizedBox(height: 16),
              FileUploadField(
                label: 'Upload Picture of Compound',
                imageUrl: _placeImage,
                onImagePicked: (String? imageUrl) {
                  setState(() {
                    _placeImage = imageUrl;
                  });
                },
              ),
              const SizedBox(height: 30),
              CustomSubmitButton(
                onPressed: _handleSubmit,
                isLoading: _isLoading,
              ),
            ],
          ),
        ),
        if (_isLoading) const LoadingOverlay(),
      ],
    );
  }

Future<void> _handleSubmit() async {
    if (!_validateForm()) return;

    setState(() => _isLoading = true);

    try {
      final result = await ApiService.addCompound(
        compoundName: _compoundNameController.text,
        compoundLocation: _locationController.text,
        imagePath: _placeImage!,
      );

      setState(() => _isLoading = false);

      if (result['success']) {
        _showSuccessDialog();
      } else {
        _showErrorDialog(result['message']);
      }
    } catch (e) {
      setState(() => _isLoading = false);
      _showErrorDialog('An error occurred while submitting the form. Please try again.');
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Success'),
        content: const Text('Compound added successfully!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context, true); // Return true to indicate success
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

void _showErrorDialog(String message) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Error'),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('OK'),
        ),
      ],
    ),
  );
}

bool _validateForm() {
  if (_compoundNameController.text.isEmpty ||
      _locationController.text.isEmpty ||
      _placeImage == null) {
    _showErrorDialog('Please fill all required fields and select an image');
    return false;
  }
  return true;
}
}