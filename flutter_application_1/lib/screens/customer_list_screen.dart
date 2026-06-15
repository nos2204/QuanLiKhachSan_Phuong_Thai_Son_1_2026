import 'package:flutter/material.dart';
import '../main.dart';
import '../models/customer.dart';
import '../database/database_helper.dart';

class CustomerListScreen extends StatefulWidget {
  const CustomerListScreen({super.key});

  @override
  State<CustomerListScreen> createState() => _CustomerListScreenState();
}

class _CustomerListScreenState extends State<CustomerListScreen> {
  List<Customer> _customers = [];
  bool _isLoading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    List<Customer> customers;
    if (_searchQuery.isEmpty) {
      customers = await DatabaseHelper.instance.getAllCustomers();
    } else {
      customers = await DatabaseHelper.instance.searchCustomers(_searchQuery);
    }
    
    if (mounted) {
      setState(() {
        _customers = customers;
        _isLoading = false;
      });
    }
  }

  void _deleteCustomer(Customer customer) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: Text('Xóa khách hàng ${customer.fullName}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Navigator.pop(context);
              if (customer.id != null) {
                await DatabaseHelper.instance.deleteCustomer(customer.id!);
                _loadData();
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Đã xóa khách hàng')),
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

  void _showAddEditDialog(Customer? customer) {
    final isEditing = customer != null;
    final formKey = GlobalKey<FormState>();
    
    String name = isEditing ? customer.fullName : '';
    String phone = isEditing ? customer.phone : '';
    String idCard = isEditing ? customer.idCard : '';
    String email = isEditing ? customer.email : '';
    String address = isEditing ? customer.address : '';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEditing ? 'Sửa thông tin' : 'Thêm khách hàng'),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  initialValue: name,
                  decoration: const InputDecoration(labelText: 'Họ tên', border: OutlineInputBorder()),
                  validator: (v) => v!.isEmpty ? 'Vui lòng nhập họ tên' : null,
                  onSaved: (v) => name = v!,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: phone,
                  decoration: const InputDecoration(labelText: 'Số điện thoại', border: OutlineInputBorder()),
                  keyboardType: TextInputType.phone,
                  validator: (v) => v!.isEmpty ? 'Vui lòng nhập SĐT' : null,
                  onSaved: (v) => phone = v!,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: idCard,
                  decoration: const InputDecoration(labelText: 'CCCD/CMND', border: OutlineInputBorder()),
                  keyboardType: TextInputType.number,
                  validator: (v) => v!.isEmpty ? 'Vui lòng nhập CCCD' : null,
                  onSaved: (v) => idCard = v!,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: email,
                  decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
                  keyboardType: TextInputType.emailAddress,
                  onSaved: (v) => email = v ?? '',
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: address,
                  decoration: const InputDecoration(labelText: 'Địa chỉ', border: OutlineInputBorder()),
                  maxLines: 2,
                  onSaved: (v) => address = v ?? '',
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
                
                final newCustomer = Customer(
                  id: isEditing ? customer.id : null,
                  fullName: name,
                  phone: phone,
                  idCard: idCard,
                  email: email,
                  address: address,
                );

                try {
                  if (isEditing) {
                    await DatabaseHelper.instance.updateCustomer(newCustomer);
                  } else {
                    await DatabaseHelper.instance.insertCustomer(newCustomer);
                  }
                  
                  if (mounted) {
                    Navigator.pop(context);
                    _loadData();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(isEditing ? 'Đã cập nhật' : 'Đã thêm khách hàng')),
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Lỗi: CCCD hoặc SĐT có thể đã tồn tại.')),
                    );
                  }
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
        title: const Text('QUẢN LÝ KHÁCH HÀNG', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: AppTheme.darkBlue,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Tìm theo Tên, SĐT, CCCD...',
                prefixIcon: const Icon(Icons.search, color: AppTheme.darkBlue),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: AppTheme.bgGray,
              ),
              onChanged: (val) {
                _searchQuery = val;
                _loadData();
              },
            ),
          ),
          Expanded(
            child: _isLoading 
              ? const Center(child: CircularProgressIndicator(color: AppTheme.primaryGold))
              : RefreshIndicator(
                  onRefresh: _loadData,
                  color: AppTheme.primaryGold,
                  child: _customers.isEmpty
                    ? ListView(
                        children: [
                          SizedBox(height: MediaQuery.of(context).size.height * 0.3),
                          const Center(child: Text('Không tìm thấy khách hàng.', style: TextStyle(color: Colors.grey, fontSize: 16))),
                        ],
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: _customers.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final customer = _customers[index];
                          return Dismissible(
                            key: Key(customer.id.toString()),
                            background: Container(
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20),
                              color: Colors.red,
                              child: const Icon(Icons.delete, color: Colors.white),
                            ),
                            direction: DismissDirection.endToStart,
                            confirmDismiss: (direction) async {
                              bool confirm = false;
                              await showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Xác nhận xóa'),
                                  content: Text('Xóa khách hàng ${customer.fullName}?'),
                                  actions: [
                                    TextButton(onPressed: () => Navigator.pop(context), child: const Text('Hủy')),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                      onPressed: () { confirm = true; Navigator.pop(context); },
                                      child: const Text('Xóa', style: TextStyle(color: Colors.white)),
                                    ),
                                  ],
                                ),
                              );
                              return confirm;
                            },
                            onDismissed: (direction) async {
                              if (customer.id != null) {
                                await DatabaseHelper.instance.deleteCustomer(customer.id!);
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đã xóa khách hàng')));
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2)),
                                ],
                              ),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: AppTheme.darkBlue.withOpacity(0.1),
                                  child: Text(
                                    customer.fullName.isNotEmpty ? customer.fullName[0].toUpperCase() : '?',
                                    style: const TextStyle(color: AppTheme.darkBlue, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                title: Text(customer.fullName, style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.darkBlue)),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 4),
                                    Text('SĐT: ${customer.phone} - CCCD: ${customer.idCard}'),
                                    if (customer.email.isNotEmpty) Text('Email: ${customer.email}'),
                                  ],
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.grey),
                                  onPressed: () => _showAddEditDialog(customer),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.primaryGold,
        onPressed: () => _showAddEditDialog(null),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
