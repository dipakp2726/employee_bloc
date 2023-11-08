import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:employee/app/app_bloc_observer.dart';
import 'package:employee_api/employee_api.dart';
import 'package:employee_repository/employee_repository.dart';
import 'package:flutter/widgets.dart';

import 'app/app.dart';

void bootstrap({required EmployeeApi employeeApi}) {
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  Bloc.observer = const AppBlocObserver();

  final employeesRepository = EmployeeRepository(employeeApi: employeeApi);

  runZonedGuarded(
    () => runApp(App(employeesRepository: employeesRepository)),
    (error, stackTrace) => log(error.toString(), stackTrace: stackTrace),
  );
}
