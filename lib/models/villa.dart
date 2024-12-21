class Villa {
  String unitName;
  String unitMainFeature;
  String typeName;
  List<Overview> overviews;
  List<String> room;
  double price;
  // Additional fields for GET response
  int? unitID;
  String? imageUrlPath;
  int? numberOfReview;

  Villa({
    required this.unitName,
    required this.unitMainFeature,
    required this.typeName,
    required this.overviews,
    required this.room,
    required this.price,
    this.unitID,
    this.imageUrlPath,
    this.numberOfReview,
  });

  factory Villa.fromJson(Map<String, dynamic> json) {
    return Villa(
       unitID: json['unitID'] is String 
          ? int.tryParse(json['unitID']) 
          : json['unitID'],
      unitName: json['unitName'] ?? '',
      unitMainFeature: json['unitMainFeature'] ?? '',
      typeName: json['typeName'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      imageUrlPath: json['imageUrlPath'],
      numberOfReview: json['numberOfReview'],
      overviews: json['overviews'] != null 
          ? List<Overview>.from(
              json['overviews'].map((x) => Overview.fromJson(x)))
          : [],
      room: json['room'] != null 
          ? List<String>.from(json['room'])
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'unitName': unitName,
      'unitMainFeature': unitMainFeature,
      'typeName': typeName,
      'overviews': overviews.map((x) => x.toJson()).toList(),
      'room': room,
      'price': price,
    };
  }

  // For debugging
  @override
  String toString() {
    return 'Villa{unitName: $unitName, unitMainFeature: $unitMainFeature, typeName: $typeName, price: $price, rooms: $room}';
  }
}

class Overview {
  String iconName;
  String description;

  Overview({
    required this.iconName,
    required this.description,
  });

  factory Overview.fromJson(Map<String, dynamic> json) {
    return Overview(
      iconName: json['iconName'] ?? '',
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'iconName': iconName,
      'description': description,
    };
  }

  @override
  String toString() {
    return 'Overview{iconName: $iconName, description: $description}';
  }
}

