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

      if (widget.isEditing) {
        // Handle editing mode
       if (_formData.images.isNotEmpty) {
  setState(() => _isUploading = true);
  
  try {
    final imageResult = await ApiService.uploadUnitImages(
      unitId:  widget.initialVilla!.unitID.toString(),
      imagePaths: _formData.images,
    );

    if (!imageResult['success']) {
      throw Exception(imageResult['message']);
    }
    if (imageResult['success']) {
  // Refresh the villa data
  final updatedVillaData = await ApiService.getCompoundUnits(widget.compoundId);
  if (updatedVillaData['success']) {
    // Find the updated villa
    final units = updatedVillaData['data']['units'] as List;
    final updatedUnit = units.firstWhere(
      (unit) => unit['unitID'].toString() == widget.initialVilla!.unitID.toString(),
      orElse: () => null,
    );
    if (updatedUnit != null) {
      setState(() {
        // Update the villa data with new image path
        villaData['imageUrlPath'] = updatedUnit['imageUrlPath'];
      });
    }
  }
}


    // Log successful upload
    print('Images uploaded successfully: ${imageResult['results']}');
    
  } catch (e) {
    print('Error uploading images: $e');
    throw Exception('Failed to upload images: $e');
  } finally {
    setState(() => _isUploading = false);
  }
}
      } else {
        // Handle adding new villa
        final result = await ApiService.addVilla(
          compoundId: widget.compoundId,
          villaData: villaData,
        );

        if (result['success'] && result['data'] != null) {
          final unitId = result['data']['unitID']?.toString();
          
          if (unitId != null && _formData.images.isNotEmpty) {
            setState(() => _isUploading = true);
            
            final imageResult = await ApiService.uploadUnitImages(
              unitId: unitId,
              imagePaths: _formData.images,
            );

            if (!imageResult['success']) {
              throw Exception('Failed to upload images: ${imageResult['message']}');
            }
            
            setState(() => _isUploading = false);
          }
        } else {
          throw Exception('Failed to add villa: ${result['message']}');
        }
      }

      if (context.mounted) {
        Navigator.pop(context); // Close loading dialog
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Villa operation completed successfully'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, villaData);
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