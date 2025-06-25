class WasteType {
  final String id;
  final String name;
  final String image;
  final int pointsPerKg;

  WasteType({
    required this.id,
    required this.name,
    required this.image,
    required this.pointsPerKg,
  });

  factory WasteType.fromJson(Map<String, dynamic> json) {
    return WasteType(
      id: json['id_sampah'],
      name: json['nama_sampah'],
      pointsPerKg: json['bobot_poin'],
      image: json['foto'] ?? '', // Handle jika foto null
    );
  }
}