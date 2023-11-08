import 'package:employee/edit_employee/edit_employee.dart';
import 'package:employee/employee_overview/employee_overview.dart';
import 'package:employee/utils/date_extension.dart';
import 'package:employee_repository/employee_repository.dart';
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
            EmployeeOverviewSuccess() => EmployeeView(
                employeeList: state.employees,
              ),
          };
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, EditEmployeePage.route());
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}

class EmployeeView extends StatelessWidget {
  const EmployeeView({super.key, required this.employeeList});

  final List<Employee> employeeList;

  @override
  Widget build(BuildContext context) {
    if (employeeList.isEmpty) {
      return Center(
        child: Image.asset('assets/not_found.png'),
      );
    }

    final currentEmployees =
        employeeList.where((e) => e.endDate == null).toList();
    final previousEmployees =
        employeeList.where((e) => e.endDate != null).toList();

    final theme =Theme.of(context);

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                _HeaderWidget(title: 'Current Employees'),
                _EmployeeList(employeeList: currentEmployees),
                _HeaderWidget(title: 'Previous Employees'),
                _EmployeeList(employeeList: previousEmployees),
              ],
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 36),
          color: Colors.grey.shade100,
          width: double.infinity,
          child: Text(
            'Swipe left to delete',
            style: theme.textTheme.bodyMedium!.copyWith(
              color: Colors.grey,

            ),
          ),
        ),
      ],
    );
  }
}

class _EmployeeList extends StatelessWidget {
  const _EmployeeList({
    required this.employeeList,
  });

  final List<Employee> employeeList;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        final employee = employeeList[index];
        return EmployeeListTile(
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
        );
      },
      separatorBuilder: (context, index) => Divider(),
      itemCount: employeeList.length,
    );
  }
}

class _HeaderWidget extends StatelessWidget {
  const _HeaderWidget({
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.all(16),
      color: Colors.grey.shade100,
      width: double.infinity,
      child: Text(
        title,
        style: theme.textTheme.bodyLarge!.copyWith(
          color: theme.primaryColor,
          fontWeight: FontWeight.w500,
        ),
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

    final isCurrentEmployee = employee.endDate == null;

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
          style: Theme.of(context).textTheme.bodyLarge,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                employee.role,
                maxLines: 1,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: Colors.grey),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              isCurrentEmployee
                  ? 'From ${employee.startDate.toDateOnly}'
                  : '${employee.startDate.toDateOnly} - ${employee.endDate?.toDateOnly}',
              maxLines: 1,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: Colors.grey),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
