import 'dart:convert';

enum ChangeEntityType { room, roomType, customer }

enum ChangeAction { create, update, delete }

enum ChangeRequestStatus { pending, approved, rejected }

String changeEntityTypeToDb(ChangeEntityType type) {
  switch (type) {
    case ChangeEntityType.room:
      return 'room';
    case ChangeEntityType.roomType:
      return 'room_type';
    case ChangeEntityType.customer:
      return 'customer';
  }
}

ChangeEntityType changeEntityTypeFromDb(String value) {
  switch (value) {
    case 'room_type':
      return ChangeEntityType.roomType;
    case 'customer':
      return ChangeEntityType.customer;
    case 'room':
    default:
      return ChangeEntityType.room;
  }
}

class ChangeRequest {
  final int? id;
  final ChangeEntityType entityType;
  final ChangeAction action;
  final int? entityId;
  final String payload;
  final int requestedBy;
  final ChangeRequestStatus status;
  final String note;
  final String adminNote;
  final String createdAt;
  final String? resolvedAt;
  final String? requesterName;
  final String? requesterUsername;

  ChangeRequest({
    this.id,
    required this.entityType,
    required this.action,
    this.entityId,
    required this.payload,
    required this.requestedBy,
    this.status = ChangeRequestStatus.pending,
    this.note = '',
    this.adminNote = '',
    String? createdAt,
    this.resolvedAt,
    this.requesterName,
    this.requesterUsername,
  }) : createdAt = createdAt ?? DateTime.now().toIso8601String();

  Map<String, dynamic> get payloadMap {
    if (payload.isEmpty) return {};
    final decoded = jsonDecode(payload);
    if (decoded is Map<String, dynamic>) return decoded;
    return {};
  }

  bool get isPending => status == ChangeRequestStatus.pending;

  String get entityText {
    switch (entityType) {
      case ChangeEntityType.room:
        return 'Phong';
      case ChangeEntityType.roomType:
        return 'Loai phong';
      case ChangeEntityType.customer:
        return 'Khach hang';
    }
  }

  String get actionText {
    switch (action) {
      case ChangeAction.create:
        return 'Them';
      case ChangeAction.update:
        return 'Sua';
      case ChangeAction.delete:
        return 'Xoa';
    }
  }

  String get statusText {
    switch (status) {
      case ChangeRequestStatus.pending:
        return 'Cho duyet';
      case ChangeRequestStatus.approved:
        return 'Da duyet';
      case ChangeRequestStatus.rejected:
        return 'Tu choi';
    }
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'entity_type': changeEntityTypeToDb(entityType),
    'action': action.name,
    'entity_id': entityId,
    'payload': payload,
    'requested_by': requestedBy,
    'status': status.name,
    'note': note,
    'admin_note': adminNote,
    'created_at': createdAt,
    'resolved_at': resolvedAt,
  };

  factory ChangeRequest.fromMap(Map<String, dynamic> map) => ChangeRequest(
    id: map['id'] as int?,
    entityType: changeEntityTypeFromDb(map['entity_type'] as String),
    action: ChangeAction.values.firstWhere(
      (action) => action.name == map['action'],
      orElse: () => ChangeAction.update,
    ),
    entityId: map['entity_id'] as int?,
    payload: map['payload'] as String? ?? '{}',
    requestedBy: map['requested_by'] as int,
    status: ChangeRequestStatus.values.firstWhere(
      (status) => status.name == map['status'],
      orElse: () => ChangeRequestStatus.pending,
    ),
    note: map['note'] as String? ?? '',
    adminNote: map['admin_note'] as String? ?? '',
    createdAt: map['created_at'] as String? ?? DateTime.now().toIso8601String(),
    resolvedAt: map['resolved_at'] as String?,
    requesterName: map['requester_name'] as String?,
    requesterUsername: map['requester_username'] as String?,
  );
}
