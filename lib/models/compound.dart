class Compound {
  final String name;
  final String imageUrl;

  Compound({
    required this.name,
    required this.imageUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'imageUrl': imageUrl,
    };
  }

  factory Compound.fromJson(Map<String, dynamic> json) {
    return Compound(
      name: json['name'] as String,
      imageUrl: json['imageUrl'] as String,
    );
  }
}