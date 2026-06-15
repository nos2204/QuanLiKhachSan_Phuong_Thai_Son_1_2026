enum RoomStatus { available, occupied, maintenance }

class Room {
  final int? id;
  final String roomNumber;
  final int roomTypeId;
  final int floor;
  final RoomStatus status;
  final String description;
  // Optional joined fields
  final String? roomTypeName;
  final double? roomTypePrice;

  Room({
    this.id,
    required this.roomNumber,
    required this.roomTypeId,
    required this.floor,
    this.status = RoomStatus.available,
    this.description = '',
    this.roomTypeName,
    this.roomTypePrice,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'room_number': roomNumber,
    'room_type_id': roomTypeId,
    'floor': floor,
    'status': status.name,
    'description': description,
  };

  factory Room.fromMap(Map<String, dynamic> map) => Room(
    id: map['id'] as int?,
    roomNumber: map['room_number'] as String,
    roomTypeId: map['room_type_id'] as int,
    floor: map['floor'] as int,
    status: RoomStatus.values.firstWhere((e) => e.name == map['status'], orElse: () => RoomStatus.available),
    description: map['description'] as String? ?? '',
    roomTypeName: map['type_name'] as String?,
    roomTypePrice: (map['base_price'] as num?)?.toDouble(),
  );

  Room copyWith({int? id, String? roomNumber, int? roomTypeId, int? floor, RoomStatus? status, String? description, String? roomTypeName, double? roomTypePrice}) => Room(
    id: id ?? this.id,
    roomNumber: roomNumber ?? this.roomNumber,
    roomTypeId: roomTypeId ?? this.roomTypeId,
    floor: floor ?? this.floor,
    status: status ?? this.status,
    description: description ?? this.description,
    roomTypeName: roomTypeName ?? this.roomTypeName,
    roomTypePrice: roomTypePrice ?? this.roomTypePrice,
  );

  String get statusText {
    switch (status) {
      case RoomStatus.available: return 'Trống';
      case RoomStatus.occupied: return 'Đang thuê';
      case RoomStatus.maintenance: return 'Bảo trì';
    }
  }
}
