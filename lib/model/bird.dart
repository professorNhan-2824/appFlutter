class Bird {
  final String id;
  final String species;
  final String description;
  final String imageUrl;
  // Thêm các trường khác mà API của bạn trả về

  Bird({
    required this.id,
    required this.species,
    required this.description,
    required this.imageUrl,
  });

  factory Bird.fromJson(Map<String, dynamic> json) {
    return Bird(
      id: json['_id'] ?? '',
      species: json['species'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      // Thêm các trường khác
    );
  }
}
// Archilochus colubris