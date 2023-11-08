part of 'edit_employee_bloc.dart';

sealed class EditEmployeeEvent extends Equatable {
  const EditEmployeeEvent();

  @override
  List<Object> get props => [];
}

final class EditEmployeeNameChanged extends EditEmployeeEvent {
  const EditEmployeeNameChanged(this.name);

  final String name;

  @override
  List<Object> get props => [name];
}

final class EditEmployeeRoleChanged extends EditEmployeeEvent {
  const EditEmployeeRoleChanged(this.role);

  final String role;

  @override
  List<Object> get props => [role];
}

final class EditEmployeeStartDateChanged extends EditEmployeeEvent {
  const EditEmployeeStartDateChanged(this.startDate);

  final DateTime startDate;

  @override
  List<Object> get props => [startDate];
}

final class EditEmployeeEndDateChanged extends EditEmployeeEvent {
  const EditEmployeeEndDateChanged(this.endDate);

  final DateTime endDate;

  @override
  List<Object> get props => [endDate];
}



final class EditEmployeeSubmitted extends EditEmployeeEvent {
  const EditEmployeeSubmitted();
}