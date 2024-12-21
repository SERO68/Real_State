import 'package:dashboard/models/villa.dart';

class VillaFormData {
  String unitName = '';
  String unitMainFeature = '';
  String typeName = '';
  List<Overview> overviews = [];
  List<String> room = [];
  double price = 0.0;
  List<String> images = []; // Add this line


  Map<String, dynamic> toJson() {
    return {
      'unitName': unitName,
      'unitMainFeature': unitMainFeature,
      'typeName': typeName,
      'overviews': overviews.map((o) => o.toJson()).toList(),
      'room': room,
      'price': price,
    };
  }
}
