import 'package:employee/edit_employee/edit_employee.dart';
import 'package:employee/employee_overview/employee_overview.dart';
import 'package:employee_repository/employee_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmployeeOverviewView extends StatelessWidget {
  const EmployeeOverviewView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Employee List'),
      ),
      body: BlocBuilder<EmployeeOverviewBloc, EmployeeOverviewState>(
        builder: (context, state) {
          return switch (state) {
            EmployeeOverviewInitial() => CircularProgressIndicator(),
            EmployeeOverviewLoading() => CircularProgressIndicator(),
            EmployeeOverviewFailure() => SizedBox(),
            EmployeeOverviewSuccess() => EmployeeList(
                employeeList: state.employees,
              ),
          };
        },
      ),
    );
  }
}

class EmployeeList extends StatelessWidget {
  const EmployeeList({super.key, required this.employeeList});

  final List<Employee> employeeList;

  @override
  Widget build(BuildContext context) {
    return CupertinoScrollbar(
      child: ListView(
        children: [
          for (final employee in employeeList)
            EmployeeListTile(
              employee: employee,
              onDismissed: (_) {
                context
                    .read<EmployeeOverviewBloc>()
                    .add(EmployeeOverviewEmployeeDeleted(employee));
              },
              onTap: () {
                Navigator.of(context).push(
                  EditEmployeePage.route(initialEmployee: employee),
                );
              },
            ),
        ],
      ),
    );
  }
}

class EmployeeListTile extends StatelessWidget {
  const EmployeeListTile(
      {super.key, required this.employee, this.onDismissed, this.onTap});

  final Employee employee;
  final DismissDirectionCallback? onDismissed;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final captionColor = theme.textTheme.bodySmall?.color;

    return Dismissible(
      key: Key('employeeListTile_dismissible_${employee.id}'),
      onDismissed: onDismissed,
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        color: theme.colorScheme.error,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: const Icon(
          Icons.delete,
          color: Color(0xAAFFFFFF),
        ),
      ),
      child: ListTile(
        onTap: onTap,
        title: Text(
          employee.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          employee.role,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
