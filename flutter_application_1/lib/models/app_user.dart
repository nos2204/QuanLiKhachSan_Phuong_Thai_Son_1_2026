enum AppUserRole { admin, staff }

class AppUser {
  final int? id;
  final String username;
  final String fullName;
  final AppUserRole role;
  final bool isActive;
  final String createdAt;

  AppUser({
    this.id,
    required this.username,
    required this.fullName,
    required this.role,
    this.isActive = true,
    String? createdAt,
  }) : createdAt = createdAt ?? DateTime.now().toIso8601String();

  bool get isAdmin => role == AppUserRole.admin;
  bool get isStaff => role == AppUserRole.staff;

  String get roleText {
    switch (role) {
      case AppUserRole.admin:
        return 'Admin';
      case AppUserRole.staff:
        return 'Nhan vien';
    }
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'username': username,
    'full_name': fullName,
    'role': role.name,
    'is_active': isActive ? 1 : 0,
    'created_at': createdAt,
  };

  factory AppUser.fromMap(Map<String, dynamic> map) => AppUser(
    id: map['id'] as int?,
    username: map['username'] as String,
    fullName: map['full_name'] as String,
    role: AppUserRole.values.firstWhere(
      (role) => role.name == map['role'],
      orElse: () => AppUserRole.staff,
    ),
    isActive: (map['is_active'] as int? ?? 1) == 1,
    createdAt: map['created_at'] as String? ?? DateTime.now().toIso8601String(),
  );

  AppUser copyWith({
    int? id,
    String? username,
    String? fullName,
    AppUserRole? role,
    bool? isActive,
  }) => AppUser(
    id: id ?? this.id,
    username: username ?? this.username,
    fullName: fullName ?? this.fullName,
    role: role ?? this.role,
    isActive: isActive ?? this.isActive,
    createdAt: createdAt,
  );
}
