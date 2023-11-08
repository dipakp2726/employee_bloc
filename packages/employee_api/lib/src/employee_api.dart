

import 'package:employee_api/src/models/models.dart';

/// {@template employee_api}
/// The interface and models for an API providing access to employee
/// {@endtemplate}
abstract class EmployeeApi {
  /// {@macro employee_api}
  const EmployeeApi();

  /// Provides a [Stream] of all employee.
  Stream<List<Employee>> getEmployees();

  /// Saves a [Employee].
  ///
  /// If a [Employee] with the same id already exists, it will be replaced.
  Future<void> saveEmployee(Employee employee);

  /// Deletes the `employee` with the given id.
  ///
  /// If no `employee` with the given id exists, a [EmployeeNotFoundException] error is
  /// thrown.
  Future<void> deleteEmployee(String id);

}

/// Error thrown when a [Employee] with a given id is not found.
class EmployeeNotFoundException implements Exception {}