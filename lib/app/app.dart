import 'package:employee/employee_overview/employee_overview.dart';
import 'package:employee_repository/employee_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class App extends StatelessWidget {
  const App({required this.employeesRepository, super.key});

  final EmployeeRepository employeesRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: employeesRepository,
      child: const AppView(),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.light,
      home: const EmployeeOverviewPage(),
    );
  }
}

class AppTheme {
  static ThemeData get light {
    var inputBorder = OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey.shade300, width: 2),
    );
    return ThemeData(
      appBarTheme: const AppBarTheme(
        color: Color(0xFF13B9FF),
      ),
      colorScheme: ColorScheme.fromSwatch(
        accentColor: const Color(0xFF13B9FF),

      ),

      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
      ),
      inputDecorationTheme: InputDecorationTheme(
          border: inputBorder,
          enabledBorder: inputBorder,
          focusedBorder: inputBorder,
          prefixIconColor: Color(0xFF13B9FF)),
    );
  }
}

final secondaryColor = Color(0xFFEDF8FF);
