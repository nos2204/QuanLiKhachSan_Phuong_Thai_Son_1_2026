import 'package:flutter/material.dart';
import '../main.dart';
import '../models/customer.dart';
import '../models/room.dart';
import '../models/booking.dart';
import '../database/database_helper.dart';

// Man hinh Form tao Don dat phong moi
class BookingFormScreen extends StatefulWidget {
  const BookingFormScreen({super.key});

  @override
  State<BookingFormScreen> createState() => _BookingFormScreenState();
}

class _BookingFormScreenState extends State<BookingFormScreen> {
  // Bien quan ly buoc hien tai cua form Stepper
  int _currentStep = 0;
  
  // Buoc 1: Thong tin khach hang
  List<Customer> _customers = [];
  Customer? _selectedCustomer;
  bool _isNewCustomer = false;
  final _customerFormKey = GlobalKey<FormState>();
  String _newCustName = '';
  String _newCustPhone = '';
  String _newCustIdCard = '';

  // Buoc 2: Chon phong
  List<Room> _availableRooms = [];
  Room? _selectedRoom;

  // Buoc 3: Thoi gian nhan/tra phong
  DateTime _checkInDate = DateTime.now();
  DateTime _checkOutDate = DateTime.now().add(const Duration(days: 1));
  
  // Buoc 4: Ghi chu
  final TextEditingController _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final customers = await DatabaseHelper.instance.getAllCustomers();
    final rooms = await DatabaseHelper.instance.getAvailableRooms();
    if (mounted) {
      setState(() {
        _customers = customers;
        _availableRooms = rooms;
      });
    }
  }

  // Tinh tong so dem luu tru
  int get _nights {
    final diff = _checkOutDate.difference(_checkInDate).inDays;
    return diff > 0 ? diff : 1;
  }

  // Tinh tong tien du kien
  double get _totalAmount {
    if (_selectedRoom == null || _selectedRoom!.roomTypePrice == null) return 0;
    return _selectedRoom!.roomTypePrice! * _nights;
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

  // Ham xu ly Submit dat phong
  Future<void> _submitBooking() async {
    if (_selectedRoom == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Vui lòng chọn phòng!')));
      return;
    }

    int customerId;
    if (_isNewCustomer) {
      if (!_customerFormKey.currentState!.validate()) return;
      _customerFormKey.currentState!.save();
      final newCustomer = Customer(fullName: _newCustName, phone: _newCustPhone, idCard: _newCustIdCard);
      customerId = await DatabaseHelper.instance.insertCustomer(newCustomer);
    } else {
      if (_selectedCustomer == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Vui lòng chọn khách hàng!')));
        return;
      }
      customerId = _selectedCustomer!.id!;
    }

    final booking = Booking(
      customerId: customerId,
      roomId: _selectedRoom!.id!,
      checkInDate: _checkInDate.toIso8601String().substring(0, 10),
      checkOutDate: _checkOutDate.toIso8601String().substring(0, 10),
      status: BookingStatus.booked,
      totalAmount: _totalAmount,
      note: _noteController.text,
    );

    await DatabaseHelper.instance.insertBooking(booking);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đặt phòng thành công!'), backgroundColor: Colors.green));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgGray,
      appBar: AppBar(
        title: const Text('ĐẶT PHÒNG MỚI', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: AppTheme.darkBlue,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stepper(
        currentStep: _currentStep,
        onStepContinue: () {
          if (_currentStep < 3) {
            setState(() => _currentStep += 1);
          } else {
            _submitBooking();
          }
        },
        onStepCancel: () {
          if (_currentStep > 0) {
            setState(() => _currentStep -= 1);
          }
        },
        controlsBuilder: (context, details) {
          final isLastStep = _currentStep == 3;
          return Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isLastStep ? AppTheme.primaryGold : AppTheme.darkBlue,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: details.onStepContinue,
                    child: Text(isLastStep ? 'XÁC NHẬN ĐẶT PHÒNG' : 'Tiếp tục', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
                if (_currentStep > 0) ...[
                  const SizedBox(width: 16),
                  TextButton(
                    onPressed: details.onStepCancel,
                    child: const Text('Quay lại', style: TextStyle(color: Colors.grey)),
                  ),
                ]
              ],
            ),
          );
        },
        steps: [
          Step(
            title: const Text('Khách hàng'),
            isActive: _currentStep >= 0,
            content: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: RadioListTile<bool>(
                        title: const Text('Khách cũ'),
                        value: false,
                        groupValue: _isNewCustomer,
                        onChanged: (v) => setState(() => _isNewCustomer = v!),
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<bool>(
                        title: const Text('Khách mới'),
                        value: true,
                        groupValue: _isNewCustomer,
                        onChanged: (v) => setState(() => _isNewCustomer = v!),
                      ),
                    ),
                  ],
                ),
                if (!_isNewCustomer)
                  DropdownButtonFormField<Customer>(
                    decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Chọn khách hàng'),
                    value: _selectedCustomer,
                    items: _customers.map((c) => DropdownMenuItem(value: c, child: Text('${c.fullName} - ${c.phone}'))).toList(),
                    onChanged: (v) => setState(() => _selectedCustomer = v),
                  )
                else
                  Form(
                    key: _customerFormKey,
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: const InputDecoration(labelText: 'Họ tên', border: OutlineInputBorder()),
                          validator: (v) => v!.isEmpty ? 'Nhập họ tên' : null,
                          onSaved: (v) => _newCustName = v!,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          decoration: const InputDecoration(labelText: 'Số điện thoại', border: OutlineInputBorder()),
                          keyboardType: TextInputType.phone,
                          validator: (v) => v!.isEmpty ? 'Nhập SĐT' : null,
                          onSaved: (v) => _newCustPhone = v!,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          decoration: const InputDecoration(labelText: 'CCCD/CMND', border: OutlineInputBorder()),
                          keyboardType: TextInputType.number,
                          validator: (v) => v!.isEmpty ? 'Nhập CCCD' : null,
                          onSaved: (v) => _newCustIdCard = v!,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          Step(
            title: const Text('Chọn phòng'),
            isActive: _currentStep >= 1,
            content: _availableRooms.isEmpty
                ? const Text('Không có phòng trống nào.')
                : GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 2.5,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: _availableRooms.length,
                    itemBuilder: (context, index) {
                      final room = _availableRooms[index];
                      final isSelected = _selectedRoom == room;
                      return InkWell(
                        onTap: () => setState(() => _selectedRoom = room),
                        child: Container(
                          decoration: BoxDecoration(
                            color: isSelected ? AppTheme.darkBlue.withOpacity(0.1) : Colors.white,
                            border: Border.all(color: isSelected ? AppTheme.darkBlue : Colors.grey[300]!, width: isSelected ? 2 : 1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(room.roomNumber, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: isSelected ? AppTheme.darkBlue : Colors.black)),
                              Text(room.roomTypeName ?? '', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          Step(
            title: const Text('Thời gian & Chi phí'),
            isActive: _currentStep >= 2,
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: _checkInDate,
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(const Duration(days: 365)),
                          );
                          if (date != null) {
                            setState(() {
                              _checkInDate = date;
                              if (_checkOutDate.isBefore(_checkInDate)) {
                                _checkOutDate = _checkInDate.add(const Duration(days: 1));
                              }
                            });
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(8)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Nhận phòng', style: TextStyle(color: Colors.grey, fontSize: 12)),
                              Text('${_checkInDate.day}/${_checkInDate.month}/${_checkInDate.year}', style: const TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: _checkOutDate,
                            firstDate: _checkInDate.add(const Duration(days: 1)),
                            lastDate: DateTime.now().add(const Duration(days: 365)),
                          );
                          if (date != null) {
                            setState(() => _checkOutDate = date);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(8)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Trả phòng', style: TextStyle(color: Colors.grey, fontSize: 12)),
                              Text('${_checkOutDate.day}/${_checkOutDate.month}/${_checkOutDate.year}', style: const TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                if (_selectedRoom != null)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: AppTheme.cream, borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Tạm tính', style: TextStyle(fontWeight: FontWeight.bold)),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('$_nights đêm × ${_formatVND(_selectedRoom!.roomTypePrice!.toInt())}'),
                            Text(_formatVND(_totalAmount.toInt()), style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryGold, fontSize: 18)),
                          ],
                        ),
                      ],
                    ),
                  )
                else
                  const Text('Vui lòng chọn phòng ở bước trước.', style: TextStyle(color: Colors.red)),
              ],
            ),
          ),
          Step(
            title: const Text('Ghi chú'),
            isActive: _currentStep >= 3,
            content: TextField(
              controller: _noteController,
              decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'Nhập ghi chú (nếu có)...'),
              maxLines: 3,
            ),
          ),
        ],
      ),
    );
  }
}
