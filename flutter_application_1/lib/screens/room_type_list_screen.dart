import 'package:flutter/material.dart';
import '../main.dart';
import '../models/app_user.dart';
import '../models/change_request.dart';
import '../models/room_type.dart';
import '../database/database_helper.dart';

class RoomTypeListScreen extends StatefulWidget {
  final AppUser currentUser;

  const RoomTypeListScreen({super.key, required this.currentUser});

  @override
  State<RoomTypeListScreen> createState() => _RoomTypeListScreenState();
}

class _RoomTypeListScreenState extends State<RoomTypeListScreen> {
  List<RoomType> _roomTypes = [];
  bool _isLoading = true;

  bool get _isAdmin => widget.currentUser.isAdmin;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final types = await DatabaseHelper.instance.getAllRoomTypes();
    if (mounted) {
      setState(() {
        _roomTypes = types;
        _isLoading = false;
      });
    }
  }

  Future<void> _submitRoomTypeChange(RoomType type, bool isEditing) async {
    if (_isAdmin) {
      if (isEditing) {
        await DatabaseHelper.instance.updateRoomType(type);
      } else {
        await DatabaseHelper.instance.insertRoomType(type);
      }
      return;
    }

    await DatabaseHelper.instance.createChangeRequest(
      entityType: ChangeEntityType.roomType,
      action: isEditing ? ChangeAction.update : ChangeAction.create,
      entityId: isEditing ? type.id : null,
      payload: type.toMap(),
      requestedBy: widget.currentUser.id!,
      note: isEditing ? 'Đề xuất sửa loại phòng' : 'Đề xuất thêm loại phòng',
    );
  }

  String _formatVND(double amount) {
    final s = amount.toInt().toString();
    final buf = StringBuffer();
    int count = 0;
    for (int i = s.length - 1; i >= 0; i--) {
      if (count > 0 && count % 3 == 0) buf.write('.');
      buf.write(s[i]);
      count++;
    }
    return '${buf.toString().split('').reversed.join()}đ';
  }

  void _deleteRoomType(RoomType type) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: Text(
          'Bạn có chắc chắn muốn xóa loại phòng ${type.name} không?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Navigator.pop(context);
              if (type.id != null) {
                try {
                  if (_isAdmin) {
                    await DatabaseHelper.instance.deleteRoomType(type.id!);
                  } else {
                    await DatabaseHelper.instance.createChangeRequest(
                      entityType: ChangeEntityType.roomType,
                      action: ChangeAction.delete,
                      entityId: type.id,
                      payload: type.toMap(),
                      requestedBy: widget.currentUser.id!,
                      note: 'Đề xuất xóa loại phòng ${type.name}',
                    );
                  }
                  _loadData();
                  if (!_isAdmin) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Đã gửi đề xuất xóa loại phòng'),
                      ),
                    );
                    return;
                  }
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Đã xóa loại phòng')),
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          e.toString().replaceAll('Exception: ', ''),
                        ),
                      ),
                    );
                  }
                }
              }
            },
            child: const Text('Xóa', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showAddEditDialog(RoomType? type) {
    final isEditing = type != null;
    final formKey = GlobalKey<FormState>();

    String name = isEditing ? type.name : '';
    String priceStr = isEditing ? type.basePrice.toInt().toString() : '';
    String desc = isEditing ? type.description : '';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEditing ? 'Sửa loại phòng' : 'Thêm loại phòng mới'),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  initialValue: name,
                  decoration: const InputDecoration(
                    labelText: 'Tên loại phòng',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => v == null || v.isEmpty
                      ? 'Vui lòng nhập tên loại phòng'
                      : null,
                  onSaved: (v) => name = v!,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: priceStr,
                  decoration: const InputDecoration(
                    labelText: 'Giá cơ bản (VNĐ)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (v) {
                    if (v == null || v.isEmpty)
                      return 'Vui lòng nhập giá phòng';
                    if (double.tryParse(v) == null)
                      return 'Giá phòng không hợp lệ';
                    return null;
                  },
                  onSaved: (v) => priceStr = v!,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: desc,
                  decoration: const InputDecoration(
                    labelText: 'Mô tả',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                  onSaved: (v) => desc = v ?? '',
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.darkBlue),
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                formKey.currentState!.save();

                final newType = RoomType(
                  id: isEditing ? type.id : null,
                  name: name,
                  basePrice: double.parse(priceStr),
                  description: desc,
                );

                await _submitRoomTypeChange(newType, isEditing);

                if (mounted) {
                  Navigator.pop(context);
                  _loadData();
                  if (!_isAdmin) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Đã gửi đề xuất cho admin duyệt'),
                      ),
                    );
                    return;
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        isEditing ? 'Đã cập nhật' : 'Đã thêm loại phòng',
                      ),
                    ),
                  );
                }
              }
            },
            child: const Text('Lưu', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgGray,
      appBar: AppBar(
        title: const Text(
          'LOẠI PHÒNG & GIÁ',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: AppTheme.darkBlue,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppTheme.primaryGold),
            )
          : RefreshIndicator(
              onRefresh: _loadData,
              color: AppTheme.primaryGold,
              child: _roomTypes.isEmpty
                  ? ListView(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.3,
                        ),
                        const Center(
                          child: Text(
                            'Chưa có loại phòng nào.',
                            style: TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                        ),
                      ],
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: _roomTypes.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final type = _roomTypes[index];
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            title: Row(
                              children: [
                                Text(
                                  type.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: AppTheme.darkBlue,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  _formatVND(type.basePrice),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: AppTheme.primaryGold,
                                  ),
                                ),
                              ],
                            ),
                            subtitle: type.description.isNotEmpty
                                ? Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Text(
                                      type.description,
                                      style: TextStyle(color: Colors.grey[700]),
                                    ),
                                  )
                                : null,
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.blue,
                                  ),
                                  onPressed: () => _showAddEditDialog(type),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () => _deleteRoomType(type),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.primaryGold,
        onPressed: () => _showAddEditDialog(null),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
