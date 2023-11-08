import 'package:employee/app/app.dart';
import 'package:employee/utils/date_extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../edit_employee.dart';

class EditEmployeeView extends StatelessWidget {
  const EditEmployeeView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Employee Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _NameField(),
            _RoleField(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 19.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: _StartDateField(),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Icon(
                      Icons.arrow_forward,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  Expanded(
                    child: _EndDateField(),
                  ),
                ],
              ),
            ),
            Spacer(),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _CancelButton(),
                _SaveButton(),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class _CancelButton extends StatelessWidget {
  const _CancelButton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: secondaryColor,
            foregroundColor: Colors.blue,
          ),
          child: Text('Cancel')),
    );
  }
}

class _SaveButton extends StatelessWidget {
  const _SaveButton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ElevatedButton(
        onPressed: () {
          String? error;

          final state = context.read<EditEmployeeBloc>().state;

          if (state.name.isEmpty) {
            error = 'Please enter name';
          } else if (state.role.isEmpty) {
            error = 'Please select role';
          } else if (state.startDate == null) {
            error = 'Please enter joining date';
          }

          if (error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(error),
              ),
            );
            return;
          }
          context.read<EditEmployeeBloc>().add(EditEmployeeSubmitted());
        },
        child: Text('Save'),
      ),
    );
  }
}

class _NameField extends StatelessWidget {
  const _NameField();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<EditEmployeeBloc>().state;
    final hintText = state.initialEmployee?.name ?? 'Name';

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        key: const Key('editEmployeeView_name_textFormField'),
        initialValue: state.name,
        decoration: InputDecoration(
            enabled: !state.status.isLoadingOrSuccess,
            hintText: hintText,
            prefixIcon: Icon(Icons.person)),
        inputFormatters: [
          LengthLimitingTextInputFormatter(50),
          FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\s]')),
        ],
        onChanged: (value) {
          context.read<EditEmployeeBloc>().add(EditEmployeeNameChanged(value));
        },
      ),
    );
  }
}

class _RoleField extends StatelessWidget {
  const _RoleField();

  final List<String> _roles = const <String>[
    'Product Designer',
    'Flutter Developer',
    'QA Tester',
    'Product Owner',
  ];

  @override
  Widget build(BuildContext context) {
    final state = context.watch<EditEmployeeBloc>().state;
    final hintText = state.initialEmployee?.role ?? 'Role';

    return TextFormField(
      key: const Key('editEmployeeView_role_textFormField'),
      controller: TextEditingController()..text = state.role,
      decoration: InputDecoration(
          enabled: !state.status.isLoadingOrSuccess,
          hintText: hintText,
          prefixIcon: Icon(
            Icons.shopping_bag_outlined,
          ),
          suffixIcon: Icon(
            Icons.arrow_drop_down,
          )),
      readOnly: true,
      inputFormatters: [
        LengthLimitingTextInputFormatter(50),
        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\s]')),
      ],
      onTap: () async {
        final role = await _showDialog(
          context: context,
          child: Material(
            child: ListView.separated(
              padding: EdgeInsets.only(bottom: 16),
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.all(4.0),
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context, _roles[index]);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _roles[index],
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ],
                  ),
                ),
              ),
              separatorBuilder: (context, index) => Divider(
                endIndent: 4,
                indent: 4,
              ),
              itemCount: _roles.length,
            ),
          ),
        );

        if (role != null) {
          context.read<EditEmployeeBloc>().add(EditEmployeeRoleChanged(role));
        }
      },
      onChanged: (value) {},
    );
  }

  // This shows a CupertinoModalPopup with a reasonable fixed height which hosts CupertinoPicker.
  Future<String?> _showDialog({
    required BuildContext context,
    required Widget child,
  }) async {
    return await showCupertinoModalPopup<String?>(
      context: context,
      builder: (BuildContext context) => Container(
        height: MediaQuery.sizeOf(context).height * .25,
        padding: const EdgeInsets.only(top: 12.0),
        // The Bottom margin is provided to align the popup above the system navigation bar.
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        // Provide a background color for the popup.
        color: CupertinoColors.systemBackground.resolveFrom(context),
        // Use a SafeArea widget to avoid system overlaps.
        child: SafeArea(
          top: false,
          child: child,
        ),
      ),
    );
  }
}

class _StartDateField extends StatelessWidget {
  const _StartDateField();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<EditEmployeeBloc>().state;
    final hintText =
        state.initialEmployee?.startDate.toDateOnly ?? 'Select Date';

    return TextFormField(
      key: const Key('editEmployeeView_startDate_textFormField'),
      controller: TextEditingController()
        ..text = state.startDate?.toDateOnly ?? '',
      decoration: InputDecoration(
        enabled: !state.status.isLoadingOrSuccess,
        hintText: hintText,
        prefixIcon: Icon(Icons.calendar_month),
      ),
      readOnly: true,
      onTap: () async {
        DateTime? pickedDate = state.startDate;

        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: pickedDate ?? DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime.now(),
        );
        if (picked != null && picked != state.startDate)
          context
              .read<EditEmployeeBloc>()
              .add(EditEmployeeStartDateChanged(picked));
      },
    );
  }
}

class _EndDateField extends StatefulWidget {
  const _EndDateField();

  @override
  State<_EndDateField> createState() => _EndDateFieldState();
}

class _EndDateFieldState extends State<_EndDateField> {
  @override
  Widget build(BuildContext context) {
    final state = context.watch<EditEmployeeBloc>().state;
    final hintText = state.initialEmployee?.endDate?.toDateOnly ?? '';

    return TextFormField(
      key: const Key('editEmployeeView_endDate_textFormField'),
      controller: TextEditingController()
        ..text = state.endDate?.toDateOnly ?? 'No Date',
      decoration: InputDecoration(
        enabled: !state.status.isLoadingOrSuccess,
        hintText: hintText,
        prefixIcon: Icon(Icons.calendar_month),
      ),
      readOnly: true,
      onTap: () async {
        DateTime? pickedDate = state.endDate;

        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: pickedDate ?? DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        );

        if (picked != null && picked != state.endDate)
          context
              .read<EditEmployeeBloc>()
              .add(EditEmployeeEndDateChanged(picked));
      },
    );
  }
}
