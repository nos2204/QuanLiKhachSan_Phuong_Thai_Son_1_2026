import 'package:flutter/material.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:excel/excel.dart';
import '../database/database_helper.dart';
import '../main.dart';
import '../models/app_user.dart';

class EmployeeAccountScreen extends StatefulWidget {
  const EmployeeAccountScreen({super.key});

  @override
  State<EmployeeAccountScreen> createState() => _EmployeeAccountScreenState();
}

class _EmployeeAccountScreenState extends State<EmployeeAccountScreen> {
  List<AppUser> _employees = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final employees = await DatabaseHelper.instance.getEmployeeUsers();
    if (mounted) {
      setState(() {
        _employees = employees;
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteEmployee(AppUser employee) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: Text('Xóa tài khoản ${employee.fullName}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Xóa', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirmed != true || employee.id == null) return;
    await DatabaseHelper.instance.deleteEmployeeUser(employee.id!);
    await _loadData();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã xóa tài khoản nhân viên.')),
      );
    }
  }

  Future<void> _importFromExcel() async {
    try {
      FilePickerResult? result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx', 'xls'],
      );

      if (result != null && result.files.single.path != null) {
        setState(() => _isLoading = true);
        var bytes = File(result.files.single.path!).readAsBytesSync();
        var excel = Excel.decodeBytes(bytes);

        int importedCount = 0;
        int failedCount = 0;

        for (var table in excel.tables.keys) {
          var rows = excel.tables[table]?.rows;
          if (rows == null) continue;

          bool isFirstRow = true;
          for (var row in rows) {
            if (isFirstRow) {
              isFirstRow = false;
              continue;
            }

            if (row.length >= 3) {
              String fullName = row[0]?.value?.toString() ?? '';
              String username = row[1]?.value?.toString() ?? '';
              String password = row[2]?.value?.toString() ?? '';

              if (fullName.isNotEmpty &&
                  username.isNotEmpty &&
                  password.isNotEmpty) {
                try {
                  await DatabaseHelper.instance.insertEmployeeUser(
                    username: username,
                    password: password,
                    fullName: fullName,
                  );
                  importedCount++;
                } catch (e) {
                  failedCount++;
                }
              }
            }
          }
        }
        await _loadData();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Đã nhập $importedCount nhân viên. Thất bại: $failedCount.',
              ),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Lỗi khi đọc file Excel.')),
        );
      }
    }
  }

  void _showAddEditDialog(AppUser? employee) {
    final isEditing = employee != null;
    final formKey = GlobalKey<FormState>();
    String fullName = employee?.fullName ?? '';
    String username = employee?.username ?? '';
    String password = '';
    bool isActive = employee?.isActive ?? true;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(isEditing ? 'Sửa nhân viên' : 'Thêm nhân viên'),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    initialValue: fullName,
                    decoration: const InputDecoration(
                      labelText: 'Họ tên',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => value == null || value.trim().isEmpty
                        ? 'Nhập họ tên'
                        : null,
                    onSaved: (value) => fullName = value!.trim(),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    initialValue: username,
                    decoration: const InputDecoration(
                      labelText: 'Tên đăng nhập',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => value == null || value.trim().isEmpty
                        ? 'Nhập tên đăng nhập'
                        : null,
                    onSaved: (value) => username = value!.trim(),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: isEditing
                          ? 'Mật khẩu mới (bỏ trống nếu giữ nguyên)'
                          : 'Mật khẩu',
                      border: const OutlineInputBorder(),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (!isEditing && (value == null || value.isEmpty)) {
                        return 'Nhập mật khẩu';
                      }
                      return null;
                    },
                    onSaved: (value) => password = value ?? '',
                  ),
                  if (isEditing) ...[
                    const SizedBox(height: 8),
                    SwitchListTile(
                      value: isActive,
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Tài khoản đang hoạt động'),
                      onChanged: (value) =>
                          setDialogState(() => isActive = value),
                    ),
                  ],
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
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.darkBlue,
              ),
              onPressed: () async {
                if (!formKey.currentState!.validate()) return;
                formKey.currentState!.save();

                try {
                  if (isEditing) {
                    final updated = employee.copyWith(
                      username: username,
                      fullName: fullName,
                      isActive: isActive,
                    );
                    await DatabaseHelper.instance.updateEmployeeUser(
                      updated,
                      password: password.isEmpty ? null : password,
                    );
                  } else {
                    await DatabaseHelper.instance.insertEmployeeUser(
                      username: username,
                      password: password,
                      fullName: fullName,
                    );
                  }

                  if (mounted) {
                    Navigator.pop(context);
                    await _loadData();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          isEditing
                              ? 'Đã cập nhật nhân viên.'
                              : 'Đã thêm nhân viên.',
                        ),
                      ),
                    );
                  }
                } catch (_) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Tên đăng nhập đã tồn tại.'),
                      ),
                    );
                  }
                }
              },
              child: const Text('Lưu', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgGray,
      appBar: AppBar(
        title: const Text(
          'TÀI KHOẢN NHÂN VIÊN',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: AppTheme.darkBlue,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.file_upload),
            tooltip: 'Nhập từ Excel',
            onPressed: _importFromExcel,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppTheme.primaryGold),
            )
          : RefreshIndicator(
              color: AppTheme.primaryGold,
              onRefresh: _loadData,
              child: _employees.isEmpty
                  ? ListView(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.3,
                        ),
                        const Center(
                          child: Text(
                            'Chưa có tài khoản nhân viên.',
                            style: TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                        ),
                      ],
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: _employees.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final employee = _employees[index];
                        return Container(
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
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: employee.isActive
                                  ? AppTheme.darkBlue.withOpacity(0.1)
                                  : Colors.grey.withOpacity(0.18),
                              child: Icon(
                                employee.isActive
                                    ? Icons.badge_outlined
                                    : Icons.lock_outline,
                                color: employee.isActive
                                    ? AppTheme.darkBlue
                                    : Colors.grey,
                              ),
                            ),
                            title: Text(
                              employee.fullName,
                              style: const TextStyle(
                                color: AppTheme.darkBlue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              '${employee.username} - ${employee.isActive ? 'Đang hoạt động' : 'Đã khóa'}',
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.blue,
                                  ),
                                  onPressed: () => _showAddEditDialog(employee),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete_outline,
                                    color: Colors.red,
                                  ),
                                  onPressed: () => _deleteEmployee(employee),
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
