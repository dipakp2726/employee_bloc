import 'package:employee_api/employee_api.dart';

/// {@template employee_repository}
/// A repository that handles employee related requests.
/// {@endtemplate}
class EmployeeRepository {
  /// {@macro employee_repository}
  const EmployeeRepository({
    required EmployeeApi employeeApi,
  }) : _employeeApi = employeeApi;

  final EmployeeApi _employeeApi;

  /// Provides a [Stream] of all employees.
  Stream<List<Employee>> getEmployees() => _employeeApi.getEmployees();

  /// Saves a [Employee].
  ///
  /// If a [Employee] with the same id already exists, it will be replaced.
  Future<void> saveEmployee(Employee employee) =>
      _employeeApi.saveEmployee(employee);

  /// Deletes the `employee` with the given id.
  ///
  /// If no `employee` with the given id exists, a [EmployeeNotFoundException]
  /// error is thrown.
  Future<void> deleteEmployee(String id) => _employeeApi.deleteEmployee(id);
}
