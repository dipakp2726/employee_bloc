// ignore_for_file: prefer_const_constructors
import 'package:test/test.dart';
import 'package:employee_repository/employee_repository.dart';

void main() {
  group('EmployeeRepository', () {
    test('can be instantiated', () {
      expect(EmployeeRepository(), isNotNull);
    });
  });
}
