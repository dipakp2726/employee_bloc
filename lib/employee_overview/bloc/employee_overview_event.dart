part of 'employee_overview_bloc.dart';

sealed class EmployeeOverviewEvent extends Equatable {
  const EmployeeOverviewEvent();

  @override
  List<Object> get props => [];
}

final class EmployeesOverviewSubscriptionRequested
    extends EmployeeOverviewEvent {
  const EmployeesOverviewSubscriptionRequested();
}

final class EmployeeOverviewEmployeeDeleted extends EmployeeOverviewEvent {
  const EmployeeOverviewEmployeeDeleted(this.employee);

  final Employee employee;

  @override
  List<Object> get props => [employee];
}
