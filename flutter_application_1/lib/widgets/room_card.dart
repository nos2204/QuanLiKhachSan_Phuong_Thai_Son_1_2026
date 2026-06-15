import 'package:flutter/material.dart';
import '../main.dart';
import '../models/room.dart';

class RoomCard extends StatelessWidget {
  final Room room;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const RoomCard({super.key, required this.room, this.onTap, this.onEdit, this.onDelete});

  Color get _statusColor {
    switch (room.status) {
      case RoomStatus.available: return const Color(0xFF4CAF50);
      case RoomStatus.occupied: return const Color(0xFFE53935);
      case RoomStatus.maintenance: return const Color(0xFFFF9800);
    }
  }

  IconData get _statusIcon {
    switch (room.status) {
      case RoomStatus.available: return Icons.check_circle;
      case RoomStatus.occupied: return Icons.person;
      case RoomStatus.maintenance: return Icons.build;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _statusColor.withOpacity(0.3)),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: _statusColor.withOpacity(0.1),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(14),
                  topRight: Radius.circular(14),
                ),
              ),
              child: Row(
                children: [
                  Icon(_statusIcon, size: 16, color: _statusColor),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(room.statusText, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: _statusColor)),
                  ),
                  if (onEdit != null)
                    InkWell(onTap: onEdit, child: Icon(Icons.edit, size: 16, color: Colors.grey[500])),
                  if (onDelete != null) ...[
                    const SizedBox(width: 8),
                    InkWell(onTap: onDelete, child: const Icon(Icons.delete_outline, size: 16, color: Colors.redAccent)),
                  ],
                ],
              ),
            ),
            // Room info
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(room.roomNumber, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.darkBlue)),
                  const SizedBox(height: 4),
                  Text(room.roomTypeName ?? 'N/A', style: TextStyle(fontSize: 13, color: Colors.grey[600])),
                  const SizedBox(height: 4),
                  Text('Tầng ${room.floor}', style: TextStyle(fontSize: 12, color: Colors.grey[500])),
                  const SizedBox(height: 8),
                  if (room.roomTypePrice != null)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryGold.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${_formatVND(room.roomTypePrice!.toInt())}/đêm',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.primaryGold),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatVND(int amount) {
    final s = amount.toString();
    final buf = StringBuffer();
    int count = 0;
    for (int i = s.length - 1; i >= 0; i--) {
      if (count > 0 && count % 3 == 0) buf.write('.');
      buf.write(s[i]);
      count++;
    }
    return '${buf.toString().split('').reversed.join()}đ';
  }
}
