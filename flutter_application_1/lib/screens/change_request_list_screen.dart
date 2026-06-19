import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../main.dart';
import '../models/app_user.dart';
import '../models/change_request.dart';

class ChangeRequestListScreen extends StatefulWidget {
  final AppUser currentUser;

  const ChangeRequestListScreen({super.key, required this.currentUser});

  @override
  State<ChangeRequestListScreen> createState() =>
      _ChangeRequestListScreenState();
}

class _ChangeRequestListScreenState extends State<ChangeRequestListScreen> {
  List<ChangeRequest> _requests = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final requests = await DatabaseHelper.instance.getChangeRequests(
      requestedBy: widget.currentUser.isAdmin ? null : widget.currentUser.id,
    );
    if (mounted) {
      setState(() {
        _requests = requests;
        _isLoading = false;
      });
    }
  }

  Color _statusColor(ChangeRequestStatus status) {
    switch (status) {
      case ChangeRequestStatus.pending:
        return Colors.orange;
      case ChangeRequestStatus.approved:
        return Colors.green;
      case ChangeRequestStatus.rejected:
        return Colors.red;
    }
  }

  String _payloadLine(ChangeRequest request) {
    if (request.action == ChangeAction.delete) {
      return 'Mã dữ liệu: ${request.entityId ?? 'N/A'}';
    }

    final payload = request.payloadMap;
    switch (request.entityType) {
      case ChangeEntityType.room:
        return 'Phòng ${payload['room_number'] ?? ''} - Tầng ${payload['floor'] ?? ''}';
      case ChangeEntityType.roomType:
        return '${payload['name'] ?? ''} - Giá ${payload['base_price'] ?? ''}';
      case ChangeEntityType.customer:
        return '${payload['full_name'] ?? ''} - ${payload['phone'] ?? ''}';
    }
  }

  Future<void> _approve(ChangeRequest request) async {
    try {
      await DatabaseHelper.instance.approveChangeRequest(
        request.id!,
        widget.currentUser.id!,
      );
      await _loadData();
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Đã duyệt đề xuất.')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString().replaceAll('Exception: ', ''))),
        );
      }
    }
  }

  Future<void> _reject(ChangeRequest request) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Từ chối đề xuất'),
        content: const Text('Bạn có chắc muốn từ chối đề xuất này?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Từ chối', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirmed != true || request.id == null) return;
    await DatabaseHelper.instance.rejectChangeRequest(request.id!);
    await _loadData();
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Đã từ chối đề xuất.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isAdmin = widget.currentUser.isAdmin;

    return Scaffold(
      backgroundColor: AppTheme.bgGray,
      appBar: AppBar(
        title: Text(
          isAdmin ? 'DUYỆT ĐỀ XUẤT' : 'ĐỀ XUẤT CỦA TÔI',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppTheme.darkBlue,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppTheme.primaryGold),
            )
          : RefreshIndicator(
              color: AppTheme.primaryGold,
              onRefresh: _loadData,
              child: _requests.isEmpty
                  ? ListView(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.3,
                        ),
                        const Center(
                          child: Text(
                            'Chưa có đề xuất nào.',
                            style: TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                        ),
                      ],
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: _requests.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final request = _requests[index];
                        final statusColor = _statusColor(request.status);
                        return Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: statusColor.withOpacity(0.12),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Icon(
                                      request.action == ChangeAction.delete
                                          ? Icons.delete_outline
                                          : request.action ==
                                                ChangeAction.create
                                          ? Icons.add
                                          : Icons.edit,
                                      color: statusColor,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${request.actionText} ${request.entityText}',
                                          style: const TextStyle(
                                            color: AppTheme.darkBlue,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          _payloadLine(request),
                                          style: TextStyle(
                                            color: Colors.grey[700],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: statusColor.withOpacity(0.12),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      request.statusText,
                                      style: TextStyle(
                                        color: statusColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Người gửi: ${request.requesterName ?? request.requesterUsername ?? 'N/A'}',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                              if (request.note.isNotEmpty) ...[
                                const SizedBox(height: 6),
                                Text(
                                  'Ghi chú: ${request.note}',
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                              ],
                              if (isAdmin && request.isPending) ...[
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Expanded(
                                      child: OutlinedButton.icon(
                                        onPressed: () => _reject(request),
                                        icon: const Icon(Icons.close),
                                        label: const Text('Từ chối'),
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor: Colors.red,
                                          side: const BorderSide(
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: ElevatedButton.icon(
                                        onPressed: () => _approve(request),
                                        icon: const Icon(
                                          Icons.check,
                                          color: Colors.white,
                                        ),
                                        label: const Text(
                                          'Duyệt',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.green,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        );
                      },
                    ),
            ),
    );
  }
}
