import 'package:dashboard/models/villa.dart';
import 'package:dashboard/screens/add_villa/widgets/basic_info_section.dart';
import 'package:dashboard/screens/add_villa/widgets/overview_section.dart';
import 'package:dashboard/screens/add_villa/widgets/roomsection.dart';
import 'package:dashboard/services/api_service.dart';
import 'package:flutter/material.dart';

import '../../../models/villa_form_data.dart';
import 'images_section.dart';
class VillaForm extends StatefulWidget {
  final Function(Map<String, dynamic>) onAddVilla;
  final Villa? initialVilla;
  final String compoundId;
  final String compoundName;
  final bool isEditing;

  const VillaForm({
    super.key,
    required this.onAddVilla,
    required this.compoundId,
    required this.compoundName,
    this.initialVilla,
    this.isEditing = false,
  });

  @override
  State<VillaForm> createState() => _VillaFormState();
}

class _VillaFormState extends State<VillaForm> {
  final _formData = VillaFormData();
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialVilla != null) {
      _formData.unitName = widget.initialVilla!.unitName;
      _formData.unitMainFeature = widget.initialVilla!.unitMainFeature;
      _formData.typeName = widget.initialVilla!.typeName;
      _formData.overviews = List.from(widget.initialVilla!.overviews);
      _formData.room = List.from(widget.initialVilla!.room);
      _formData.price = widget.initialVilla!.price;
      if (widget.initialVilla!.imageUrlPath != null) {
        _formData.images = [widget.initialVilla!.imageUrlPath!];
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          widget.isEditing ? 'Edit Villa Details' : 'Add Villa Details',
          style: Theme.of(context).textTheme.headlineMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        BasicInfoSection(
          initialData: widget.initialVilla,
          onChanged: (field, value) {
            setState(() {
              switch (field) {
                case 'unitName':
                  _formData.unitName = value;
                  break;
                case 'unitMainFeature':
                  _formData.unitMainFeature = value;
                  break;
                case 'typeName':
                  _formData.typeName = value;
                  break;
                case 'price':
                  _formData.price = double.tryParse(value) ?? 0.0;
                  break;
              }
            });
          },
        ),
        const SizedBox(height: 16),
        if (widget.isEditing) ...[
          ImagesSection(
            images: _formData.images,
            onChanged: (images) {
              setState(() => _formData.images = images);
            },
          ),
          if (_isUploading)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: LinearProgressIndicator(),
            ),
        ],
        const SizedBox(height: 16),
        OverviewsSection(
          overviews: _formData.overviews,
          onChanged: (overviews) {
            setState(() => _formData.overviews = overviews);
          },
        ),
        const SizedBox(height: 16),
        RoomsSection(
          rooms: _formData.room,
          onChanged: (rooms) {
            setState(() => _formData.room = rooms);
          },
        ),
        const SizedBox(height: 30),
        _buildSubmitButton(),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return InkWell(
      onTap: _handleSubmit,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Colors.green, Colors.lightGreenAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.greenAccent.withOpacity(0.4),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Center(
          child: Text(
            widget.isEditing ? 'Update Villa' : 'Add Villa',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }

 Future<void> _handleSubmit() async {
  if (_validateForm()) {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      final villaData = {
        'unitName': _formData.unitName,
        'unitMainFeature': _formData.unitMainFeature,
        'typeName': _formData.typeName,
        'overviews': _formData.overviews.map((overview) => {
          'iconName': overview.iconName,
          'description': overview.description,
        }).toList(),
        'room': _formData.room,
        'price': _formData.price,
      };

      if (widget.isEditing && widget.initialVilla?.unitID != null) {
        // Handle editing mode
        setState(() => _isUploading = true);

        if (_formData.images.isNotEmpty) {
          print('Uploading images for unit ID: ${widget.initialVilla!.unitID}');
          
          final imageResult = await ApiService.uploadUnitImages(
            unitId: widget.initialVilla!.unitID.toString(),
            imagePaths: _formData.images.where((path) => 
              !path.startsWith('http') && !path.startsWith('https')
            ).toList(),
          );

          print('Image upload result: $imageResult');

          if (!imageResult['success']) {
            throw Exception(imageResult['message']);
          }
        }

        setState(() => _isUploading = false);

        if (context.mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Villa updated successfully'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context, villaData);
        }
      } else {
        // Handle adding new villa
        final result = await ApiService.addVilla(
          compoundId: widget.compoundId,
          villaData: villaData,
        );

        if (result['success']) {
          // Get the unit ID from the response
          String responseData = result['data'].toString();
          // Extract unit ID from response if possible
          RegExp regExp = RegExp(r'unitID: (\d+)');
          Match? match = regExp.firstMatch(responseData);
          
          if (match != null && _formData.images.isNotEmpty) {
            String unitId = match.group(1)!;
            print('Extracted Unit ID: $unitId');
            
            final imageResult = await ApiService.uploadUnitImages(
              unitId: unitId,
              imagePaths: _formData.images,
            );

            print('Image upload result: $imageResult');

            if (!imageResult['success']) {
              throw Exception('Failed to upload images: ${imageResult['message']}');
            }
          }

          widget.onAddVilla(villaData);
          
          if (context.mounted) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Villa added successfully'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context, villaData);
          }
        } else {
          if (context.mounted) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(result['message'] ?? 'Failed to add villa'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      }
    } catch (e) {
      print('Error in _handleSubmit: $e');
      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

bool _validateForm() {
  if (_formData.unitName.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please enter villa name'),
        backgroundColor: Colors.red,
      ),
    );
    return false;
  }

  if (_formData.unitMainFeature.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please enter main feature'),
        backgroundColor: Colors.red,
      ),
    );
    return false;
  }

  if (_formData.typeName.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please enter villa type'),
        backgroundColor: Colors.red,
      ),
    );
    return false;
  }

  if (_formData.price <= 0) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please enter a valid price'),
        backgroundColor: Colors.red,
      ),
    );
    return false;
  }

  if (_formData.overviews.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please add at least one overview'),
        backgroundColor: Colors.red,
      ),
    );
    return false;
  }

  if (_formData.room.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please add at least one room'),
        backgroundColor: Colors.red,
      ),
    );
    return false;
  }

  return true;
}


}