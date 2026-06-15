class Customer {
  final int? id;
  final String fullName;
  final String phone;
  final String idCard;
  final String email;
  final String address;
  final String createdAt;

  Customer({
    this.id,
    required this.fullName,
    required this.phone,
    required this.idCard,
    this.email = '',
    this.address = '',
    String? createdAt,
  }) : createdAt = createdAt ?? DateTime.now().toIso8601String();

  Map<String, dynamic> toMap() => {
    'id': id,
    'full_name': fullName,
    'phone': phone,
    'id_card': idCard,
    'email': email,
    'address': address,
    'created_at': createdAt,
  };

  factory Customer.fromMap(Map<String, dynamic> map) => Customer(
    id: map['id'] as int?,
    fullName: map['full_name'] as String,
    phone: map['phone'] as String,
    idCard: map['id_card'] as String,
    email: map['email'] as String? ?? '',
    address: map['address'] as String? ?? '',
    createdAt: map['created_at'] as String? ?? DateTime.now().toIso8601String(),
  );

  Customer copyWith({int? id, String? fullName, String? phone, String? idCard, String? email, String? address}) => Customer(
    id: id ?? this.id,
    fullName: fullName ?? this.fullName,
    phone: phone ?? this.phone,
    idCard: idCard ?? this.idCard,
    email: email ?? this.email,
    address: address ?? this.address,
    createdAt: createdAt,
  );
}
