class Invoice {
  final int? id;
  final int bookingId;
  final double totalAmount;
  final String paymentMethod;
  final String paidAt;
  final String createdAt;
  // Joined fields
  final String? customerName;
  final String? roomNumber;
  final String? checkInDate;
  final String? checkOutDate;

  Invoice({
    this.id,
    required this.bookingId,
    required this.totalAmount,
    this.paymentMethod = 'cash',
    String? paidAt,
    String? createdAt,
    this.customerName,
    this.roomNumber,
    this.checkInDate,
    this.checkOutDate,
  }) : paidAt = paidAt ?? DateTime.now().toIso8601String(),
       createdAt = createdAt ?? DateTime.now().toIso8601String();

  Map<String, dynamic> toMap() => {
    'id': id,
    'booking_id': bookingId,
    'total_amount': totalAmount,
    'payment_method': paymentMethod,
    'paid_at': paidAt,
    'created_at': createdAt,
  };

  factory Invoice.fromMap(Map<String, dynamic> map) => Invoice(
    id: map['id'] as int?,
    bookingId: map['booking_id'] as int,
    totalAmount: (map['total_amount'] as num).toDouble(),
    paymentMethod: map['payment_method'] as String? ?? 'cash',
    paidAt: map['paid_at'] as String? ?? '',
    createdAt: map['created_at'] as String? ?? '',
    customerName: map['customer_name'] as String?,
    roomNumber: map['room_number'] as String?,
    checkInDate: map['check_in_date'] as String?,
    checkOutDate: map['check_out_date'] as String?,
  );

  String get paymentMethodText {
    switch (paymentMethod) {
      case 'cash': return 'Tiền mặt';
      case 'card': return 'Thẻ';
      case 'transfer': return 'Chuyển khoản';
      default: return paymentMethod;
    }
  }
}
