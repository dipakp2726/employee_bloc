import 'package:employee_repository/employee_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../edit_employee.dart';
import 'edit_employee_view.dart';

class EditEmployeePage extends StatelessWidget {
  const EditEmployeePage({
    Key? key,
  }) : super(key: key);

  static Route<void> route({Employee? initialEmployee}) {
    return MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) => BlocProvider(
        create: (context) => EditEmployeeBloc(
          employeeRepository: context.read<EmployeeRepository>(),
          initialEmployee: initialEmployee,
        ),
        child: const EditEmployeePage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EditEmployeeBloc, EditEmployeeState>(
      listenWhen: (previous, current) =>
          previous.status != current.status &&
          current.status == EditEmployeeStatus.success,
      listener: (context, state) => Navigator.of(context).pop(),
      child: const EditEmployeeView(),
    );
  }
}
