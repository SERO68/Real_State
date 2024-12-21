class Place {
  final String id;
  late final String name;
  final String location;
  final List<Unit> units;
    String imageUrl;
  final List<PlaceImage> images;
  final List<String> unitsType;

  Place({
    required this.id,
    required this.name,
    required this.location,
    this.units = const [],
    required this.imageUrl,
    this.images = const [],
    this.unitsType = const [],
  });

  void updateImageUrl(String newUrl) {
    imageUrl = newUrl;
  }

factory Place.fromJson(Map<String, dynamic> json) {
    // Debug print to verify incoming data
    
    // Construct the image URL
    String imageUrl = json['main_Image_path'] != null 
        ? 'http://realstateapi.runasp.net/${json['main_Image_path'].replaceAll('\\', '/')}' 
        : 'assets/images/placeholder.jpg';
    
    
    return Place(
      id: json['compoundId'].toString(),
      name: json['compoundName'] ?? '',
      location: '', // Since it's not in the API response, using empty string
      imageUrl: imageUrl,
      units: [], // Empty list since it's not in this API response
      images: [], // Empty list since it's not in this API response
      unitsType: [], // Empty list since it's not in this API response
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
    };
  }

  @override
  String toString() {
    return 'Place{id: $id, name: $name, imageUrl: $imageUrl}';
  }
}

class PlaceImage {
  final int imageId;
  final String imagePath;
  final DateTime uploadedAt;
  final int compoundId;
  final int? unitId;

  PlaceImage({
    required this.imageId,
    required this.imagePath,
    required this.uploadedAt,
    required this.compoundId,
    this.unitId,
  });

  factory PlaceImage.fromJson(Map<String, dynamic> json) {
    return PlaceImage(
      imageId: json['imageId'] ?? 0,
      imagePath: json['imagePath'] ?? '',
      uploadedAt: DateTime.parse(json['uploadedAt']),
      compoundId: json['compoundId'] ?? 0,
      unitId: json['unitId'],
    );
  }
}

class Unit {
  final int id;
  final String name;
  final String description;
  final double price;
  final List<String> images;
  // Add other unit properties as needed

  Unit({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.images = const [],
  });

  factory Unit.fromJson(Map<String, dynamic> json) {
    return Unit(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0,
      images: List<String>.from(json['images'] ?? []),
    );
  }
}