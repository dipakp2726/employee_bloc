import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:employee_repository/employee_repository.dart';
import 'package:equatable/equatable.dart';

part 'employee_overview_event.dart';
part 'employee_overview_state.dart';

class EmployeeOverviewBloc
    extends Bloc<EmployeeOverviewEvent, EmployeeOverviewState> {
  EmployeeOverviewBloc({
    required EmployeeRepository employeeRepository,
  })  : _employeeRepository = employeeRepository,
        super(EmployeeOverviewInitial()) {
    on<EmployeesOverviewSubscriptionRequested>(_onSubscriptionRequested);
    on<EmployeeOverviewEmployeeDeleted>(_onEmployeeDeleted);
  }

  final EmployeeRepository _employeeRepository;

  Future<void> _onSubscriptionRequested(
      EmployeesOverviewSubscriptionRequested event,
      Emitter<EmployeeOverviewState> emit) async {
    emit(EmployeeOverviewLoading());

    await emit.forEach<List<Employee>>(
      _employeeRepository.getEmployees(),
      onData: (employees) => EmployeeOverviewSuccess(employees: employees),
      onError: (_, __) => EmployeeOverviewFailure(),
    );
  }

  Future<void> _onEmployeeDeleted(EmployeeOverviewEmployeeDeleted event,
      Emitter<EmployeeOverviewState> emit) async {
    await _employeeRepository.deleteEmployee(event.employee.id);
  }
}
