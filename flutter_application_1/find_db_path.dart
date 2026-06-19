import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() async {
  sqfliteFfiInit();
  var databaseFactory = databaseFactoryFfi;
  String path = await databaseFactory.getDatabasesPath();
  print('Thư mục chứa Database là: $path');
}
