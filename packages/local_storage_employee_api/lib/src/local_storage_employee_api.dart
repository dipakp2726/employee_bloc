import 'dart:convert';

import 'package:employee_api/employee_api.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// {@template local_storage_employee_api}
/// A Flutter implementation of the EmployeeApi that uses local storage.
/// {@endtemplate}
class LocalStorageEmployeeApi extends EmployeeApi {
  /// {@macro local_storage_employee_api}
  LocalStorageEmployeeApi({
    required SharedPreferences plugin,
  }) : _plugin = plugin {
    _init();
  }

  final SharedPreferences _plugin;

  final _employeeStreamController =
      BehaviorSubject<List<Employee>>.seeded(const []);

  @visibleForTesting
  static const kEmployeeCollectionKey = '__employee_collection_key__';

  String? _getValue(String key) => _plugin.getString(key);

  Future<void> _setValue(String key, String value) =>
      _plugin.setString(key, value);

  void _init() {
    final employeeJson = _getValue(kEmployeeCollectionKey);
    if (employeeJson != null) {
      final employees = List<Map<dynamic, dynamic>>.from(
        json.decode(employeeJson) as List,
      )
          .map((jsonMap) =>
              Employee.fromJson(Map<String, dynamic>.from(jsonMap)))
          .toList();
      _employeeStreamController.add(employees);
    } else {
      _employeeStreamController.add(const []);
    }
  }

  @override
  Stream<List<Employee>> getEmployees() =>
      _employeeStreamController.asBroadcastStream();

  @override
  Future<void> saveEmployee(Employee employee) {
    final employees = [..._employeeStreamController.value];
    final index = employees.indexWhere((t) => t.id == employee.id);
    if (index >= 0) {
      employees[index] = employee;
    } else {
      employees.add(employee);
    }

    _employeeStreamController.add(employees);
    return _setValue(kEmployeeCollectionKey, json.encode(employees));
  }

  @override
  Future<void> deleteEmployee(String id) {
    final employees = [..._employeeStreamController.value];
    final todoIndex = employees.indexWhere((t) => t.id == id);
    if (todoIndex == -1) {
      throw EmployeeNotFoundException();
    } else {
      employees.removeAt(todoIndex);
      _employeeStreamController.add(employees);
      return _setValue(kEmployeeCollectionKey, json.encode(employees));
    }
  }
}
