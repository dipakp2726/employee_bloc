part of 'employee_overview_bloc.dart';

sealed class EmployeeOverviewState extends Equatable {
  const EmployeeOverviewState();

  @override
  List<Object> get props => [];
}

class EmployeeOverviewInitial extends EmployeeOverviewState {}

class EmployeeOverviewLoading extends EmployeeOverviewState {}

class EmployeeOverviewSuccess extends EmployeeOverviewState {
  const EmployeeOverviewSuccess({
    required this.employees,
  });

  final List<Employee> employees;

  @override
  List<Object> get props => [employees];
}

class EmployeeOverviewFailure extends EmployeeOverviewState {}
