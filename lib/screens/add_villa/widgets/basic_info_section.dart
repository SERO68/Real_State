import 'package:dashboard/models/villa.dart';
import 'package:flutter/material.dart';

import '../../../Widgets/custom_text_field.dart';
class BasicInfoSection extends StatelessWidget {
  final Function(String, String) onChanged;
  final Villa? initialData;

  const BasicInfoSection({
    super.key,
    required this.onChanged,
    this.initialData,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextField(
          label: 'Villa Name',
          hintText: 'Enter villa name',
          initialValue: initialData?.unitName,
          onChanged: (value) => onChanged('unitName', value),
        ),
        const SizedBox(height: 16),
        CustomTextField(
          label: 'Main Feature',
          hintText: 'Enter main feature',
          initialValue: initialData?.unitMainFeature,
          onChanged: (value) => onChanged('unitMainFeature', value),
        ),
        const SizedBox(height: 16),
        CustomTextField(
          label: 'Type',
          hintText: 'Enter villa type',
          initialValue: initialData?.typeName,
          onChanged: (value) => onChanged('typeName', value),
        ),
        const SizedBox(height: 16),
        CustomTextField(
          label: 'Price',
          hintText: 'Enter price per night',
          initialValue: initialData?.price.toString(),
          onChanged: (value) => onChanged('price', value),
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }
}