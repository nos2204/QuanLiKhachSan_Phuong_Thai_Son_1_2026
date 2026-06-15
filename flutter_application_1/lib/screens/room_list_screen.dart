import 'package:flutter/material.dart';
import '../main.dart';
import '../models/room.dart';
import '../models/room_type.dart';
import '../database/database_helper.dart';
import '../widgets/room_card.dart';

class RoomListScreen extends StatefulWidget {
  const RoomListScreen({super.key});

  @override
  State<RoomListScreen> createState() => _RoomListScreenState();
}

class _RoomListScreenState extends State<RoomListScreen> {
  List<Room> _rooms = [];
  List<RoomType> _roomTypes = [];
  String _selectedFilter = 'Tất cả';
  bool _isLoading = true;

  final List<String> _filters = ['Tất cả', 'Trống', 'Đang thuê', 'Bảo trì'];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final types = await DatabaseHelper.instance.getAllRoomTypes();
    List<Room> allRooms = await DatabaseHelper.instance.getAllRooms();
    
    if (_selectedFilter == 'Trống') {
      allRooms = allRooms.where((r) => r.status == RoomStatus.available).toList();
    } else if (_selectedFilter == 'Đang thuê') {
      allRooms = allRooms.where((r) => r.status == RoomStatus.occupied).toList();
    } else if (_selectedFilter == 'Bảo trì') {
      allRooms = allRooms.where((r) => r.status == RoomStatus.maintenance).toList();
    }

    if (mounted) {
      setState(() {
        _roomTypes = types;
        _rooms = allRooms;
        _isLoading = false;
      });
    }
  }

  void _deleteRoom(Room room) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: Text('Bạn có chắc chắn muốn xóa phòng ${room.roomNumber} không?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Navigator.pop(context);
              if (room.id != null) {
                await DatabaseHelper.instance.deleteRoom(room.id!);
                _loadData();
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Đã xóa phòng')),
                  );
                }
              }
            },
            child: const Text('Xóa', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showAddEditDialog(Room? room) {
    final isEditing = room != null;
    final formKey = GlobalKey<FormState>();
    
    String number = isEditing ? room.roomNumber : '';
    int? typeId = isEditing ? room.roomTypeId : (_roomTypes.isNotEmpty ? _roomTypes.first.id : null);
    int floor = isEditing ? room.floor : 1;
    RoomStatus status = isEditing ? room.status : RoomStatus.available;
    String desc = isEditing ? room.description : '';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEditing ? 'Sửa phòng ${room.roomNumber}' : 'Thêm phòng mới'),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  initialValue: number,
                  decoration: const InputDecoration(labelText: 'Số phòng', border: OutlineInputBorder()),
                  validator: (v) => v!.isEmpty ? 'Vui lòng nhập số phòng' : null,
                  onSaved: (v) => number = v!,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<int>(
                  value: typeId,
                  decoration: const InputDecoration(labelText: 'Loại phòng', border: OutlineInputBorder()),
                  items: _roomTypes.map((t) => DropdownMenuItem(value: t.id, child: Text(t.name))).toList(),
                  onChanged: (v) => typeId = v,
                  validator: (v) => v == null ? 'Chọn loại phòng' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: floor.toString(),
                  decoration: const InputDecoration(labelText: 'Tầng', border: OutlineInputBorder()),
                  keyboardType: TextInputType.number,
                  validator: (v) => v!.isEmpty ? 'Nhập tầng' : null,
                  onSaved: (v) => floor = int.tryParse(v!) ?? 1,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<RoomStatus>(
                  value: status,
                  decoration: const InputDecoration(labelText: 'Trạng thái', border: OutlineInputBorder()),
                  items: RoomStatus.values.map((s) {
                    String label = 'Trống';
                    if (s == RoomStatus.occupied) label = 'Đang thuê';
                    if (s == RoomStatus.maintenance) label = 'Bảo trì';
                    return DropdownMenuItem(value: s, child: Text(label));
                  }).toList(),
                  onChanged: (v) => status = v!,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: desc,
                  decoration: const InputDecoration(labelText: 'Ghi chú', border: OutlineInputBorder()),
                  maxLines: 2,
                  onSaved: (v) => desc = v ?? '',
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Hủy')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.darkBlue),
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                formKey.currentState!.save();
                
                final newRoom = Room(
                  id: isEditing ? room.id : null,
                  roomNumber: number,
                  roomTypeId: typeId!,
                  floor: floor,
                  status: status,
                  description: desc,
                );

                if (isEditing) {
                  await DatabaseHelper.instance.updateRoom(newRoom);
                } else {
                  await DatabaseHelper.instance.insertRoom(newRoom);
                }
                
                if (mounted) {
                  Navigator.pop(context);
                  _loadData();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(isEditing ? 'Đã cập nhật' : 'Đã thêm phòng')),
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
        title: const Text('QUẢN LÝ PHÒNG', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: AppTheme.darkBlue,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          DropdownButton<String>(
            value: _selectedFilter,
            dropdownColor: AppTheme.darkBlue,
            icon: const Icon(Icons.filter_list, color: Colors.white),
            underline: const SizedBox(),
            style: const TextStyle(color: Colors.white, fontSize: 16),
            onChanged: (newValue) {
              if (newValue != null) {
                setState(() => _selectedFilter = newValue);
                _loadData();
              }
            },
            items: _filters.map((f) => DropdownMenuItem(value: f, child: Text(f))).toList(),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator(color: AppTheme.primaryGold))
        : RefreshIndicator(
            onRefresh: _loadData,
            color: AppTheme.primaryGold,
            child: _rooms.isEmpty
              ? ListView(
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.3),
                    const Center(child: Text('Không có phòng nào.', style: TextStyle(color: Colors.grey, fontSize: 16))),
                  ],
                )
              : GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.85,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: _rooms.length,
                  itemBuilder: (context, index) {
                    final room = _rooms[index];
                    return RoomCard(
                      room: room,
                      onEdit: () => _showAddEditDialog(room),
                      onDelete: () => _deleteRoom(room),
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
