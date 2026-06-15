class RoomType {
  final int? id;
  final String name;
  final double basePrice;
  final String description;

  RoomType({this.id, required this.name, required this.basePrice, this.description = ''});

  Map<String, dynamic> toMap() => {'id': id, 'name': name, 'base_price': basePrice, 'description': description};

  factory RoomType.fromMap(Map<String, dynamic> map) => RoomType(
    id: map['id'] as int?,
    name: map['name'] as String,
    basePrice: (map['base_price'] as num).toDouble(),
    description: map['description'] as String? ?? '',
  );
}
