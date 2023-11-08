part of 'edit_employee_bloc.dart';

enum EditEmployeeStatus { initial, loading, success, failure }

extension EditEmployeeStatusX on EditEmployeeStatus {
  bool get isLoadingOrSuccess => [
    EditEmployeeStatus.loading,
    EditEmployeeStatus.success,
  ].contains(this);
}

class EditEmployeeState extends Equatable {
  const EditEmployeeState({
    this.status = EditEmployeeStatus.initial,
     this.initialEmployee,
    this.name = '',
    this.role = '',
    this.startDate,
    this.endDate,
  });

  final EditEmployeeStatus status;
  final Employee? initialEmployee;
  final String name;
  final String role;
  final DateTime? startDate;
  final DateTime? endDate;

  bool get isNewEmployee => initialEmployee == null;

  EditEmployeeState copyWith({
    EditEmployeeStatus? status,
    Employee? initialEmployee,
    String? name,
    String? role,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return EditEmployeeState(
      status: status ?? this.status,
      initialEmployee: initialEmployee ?? this.initialEmployee,
      name: name ?? this.name,
      role: role ?? this.role,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }

  @override
  List<Object?> get props => [
        status,
        initialEmployee,
        name,
        role,
        startDate,
        endDate,
      ];
}
