import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:employee_repository/employee_repository.dart';
import 'package:equatable/equatable.dart';

part 'edit_employee_event.dart';
part 'edit_employee_state.dart';

class EditEmployeeBloc extends Bloc<EditEmployeeEvent, EditEmployeeState> {
  EditEmployeeBloc({
    required EmployeeRepository employeeRepository,
    Employee? initialEmployee,
  })  : _employeeRepository = employeeRepository,
        super(EditEmployeeState(
          initialEmployee: initialEmployee,
          startDate: initialEmployee?.startDate,
          endDate: initialEmployee?.endDate,
          name: initialEmployee?.name ?? '',
          role: initialEmployee?.role ?? '',
        )) {
    on<EditEmployeeNameChanged>(_onNameChanged);
    on<EditEmployeeRoleChanged>(_onRoleChanged);
    on<EditEmployeeStartDateChanged>(_onStartDateChanged);
    on<EditEmployeeEndDateChanged>(_onEndDateChanged);
    on<EditEmployeeSubmitted>(_onSubmitted);
    on<EditEmployeeDeleted>(_onDeleted);
  }

  final EmployeeRepository _employeeRepository;

  void _onNameChanged(
      EditEmployeeNameChanged event, Emitter<EditEmployeeState> emit) {
    emit(state.copyWith(name: event.name));
  }

  void _onRoleChanged(
      EditEmployeeRoleChanged event, Emitter<EditEmployeeState> emit) {
    emit(state.copyWith(role: event.role));
  }

  void _onStartDateChanged(
      EditEmployeeStartDateChanged event, Emitter<EditEmployeeState> emit) {
    emit(state.copyWith(startDate: event.startDate));
  }

  void _onEndDateChanged(
      EditEmployeeEndDateChanged event, Emitter<EditEmployeeState> emit) {
    emit(state.copyWith(endDate: event.endDate));
  }

  Future<void> _onSubmitted(
      EditEmployeeSubmitted event, Emitter<EditEmployeeState> emit) async {
    emit(state.copyWith(status: EditEmployeeStatus.loading));
    final employee = (state.initialEmployee ??
            Employee(name: '', role: '', startDate: DateTime.now()))
        .copyWith(
      title: state.name,
      description: state.role,
      startDate: state.startDate,
      endDate: state.endDate,
    );

    try {
      await _employeeRepository.saveEmployee(employee);
      emit(state.copyWith(status: EditEmployeeStatus.success));
    } catch (e) {
      emit(state.copyWith(status: EditEmployeeStatus.failure));
    }
  }

  Future<void> _onDeleted(
      EditEmployeeDeleted event, Emitter<EditEmployeeState> emit) async {
    assert(state.initialEmployee != null, 'initial employee must be non null');
    await _employeeRepository.deleteEmployee(state.initialEmployee!.id);
  }
}
