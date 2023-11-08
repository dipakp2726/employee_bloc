import 'package:employee_repository/employee_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../employee_overview.dart';
import 'employee_overview_view.dart';

class EmployeeOverviewPage extends StatelessWidget {
  const EmployeeOverviewPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EmployeeOverviewBloc(
        employeeRepository: context.read<EmployeeRepository>(),
      )..add(const EmployeesOverviewSubscriptionRequested()),
      child: const EmployeeOverviewView(),
    );
  }
}
