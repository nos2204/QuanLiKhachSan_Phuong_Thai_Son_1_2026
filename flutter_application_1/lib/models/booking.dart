enum BookingStatus { booked, checkedIn, checkedOut, cancelled }

class Booking {
  final int? id;
  final int customerId;
  final int roomId;
  final String checkInDate;
  final String checkOutDate;
  final BookingStatus status;
  final double totalAmount;
  final String note;
  final String createdAt;
  // Joined fields
  final String? customerName;
  final String? customerPhone;
  final String? customerIdCard;
  final String? roomNumber;
  final String? roomTypeName;
  final double? roomPrice;

  Booking({
    this.id,
    required this.customerId,
    required this.roomId,
    required this.checkInDate,
    required this.checkOutDate,
    this.status = BookingStatus.booked,
    required this.totalAmount,
    this.note = '',
    String? createdAt,
    this.customerName,
    this.customerPhone,
    this.customerIdCard,
    this.roomNumber,
    this.roomTypeName,
    this.roomPrice,
  }) : createdAt = createdAt ?? DateTime.now().toIso8601String();

  Map<String, dynamic> toMap() => {
    'id': id,
    'customer_id': customerId,
    'room_id': roomId,
    'check_in_date': checkInDate,
    'check_out_date': checkOutDate,
    'status': status.name,
    'total_amount': totalAmount,
    'note': note,
    'created_at': createdAt,
  };

  factory Booking.fromMap(Map<String, dynamic> map) => Booking(
    id: map['id'] as int?,
    customerId: map['customer_id'] as int,
    roomId: map['room_id'] as int,
    checkInDate: map['check_in_date'] as String,
    checkOutDate: map['check_out_date'] as String,
    status: BookingStatus.values.firstWhere((e) => e.name == map['status'], orElse: () => BookingStatus.booked),
    totalAmount: (map['total_amount'] as num).toDouble(),
    note: map['note'] as String? ?? '',
    createdAt: map['created_at'] as String? ?? DateTime.now().toIso8601String(),
    customerName: map['customer_name'] as String?,
    customerPhone: map['customer_phone'] as String?,
    customerIdCard: map['customer_id_card'] as String?,
    roomNumber: map['room_number'] as String?,
    roomTypeName: map['type_name'] as String?,
    roomPrice: (map['base_price'] as num?)?.toDouble(),
  );

  Booking copyWith({int? id, int? customerId, int? roomId, String? checkInDate, String? checkOutDate, BookingStatus? status, double? totalAmount, String? note}) => Booking(
    id: id ?? this.id,
    customerId: customerId ?? this.customerId,
    roomId: roomId ?? this.roomId,
    checkInDate: checkInDate ?? this.checkInDate,
    checkOutDate: checkOutDate ?? this.checkOutDate,
    status: status ?? this.status,
    totalAmount: totalAmount ?? this.totalAmount,
    note: note ?? this.note,
    createdAt: createdAt,
    customerName: customerName,
    customerPhone: customerPhone,
    customerIdCard: customerIdCard,
    roomNumber: roomNumber,
    roomTypeName: roomTypeName,
    roomPrice: roomPrice,
  );

  String get statusText {
    switch (status) {
      case BookingStatus.booked: return 'Đã đặt';
      case BookingStatus.checkedIn: return 'Đang ở';
      case BookingStatus.checkedOut: return 'Đã trả';
      case BookingStatus.cancelled: return 'Đã hủy';
    }
  }
}
