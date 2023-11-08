import 'package:flutter/material.dart';
import 'package:local_storage_employee_api/local_storage_employee_api.dart';

import 'bootstrap.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final employeeApi = LocalStorageEmployeeApi(
    plugin: await SharedPreferences.getInstance(),
  );

  bootstrap(employeeApi: employeeApi);
}
