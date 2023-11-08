import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

import 'json_map.dart';

part 'employee.g.dart';


/// A single `employee` item.
@immutable
@JsonSerializable()
class Employee extends Equatable {
  /// {@macro todo_item}
  Employee({
    required this.name,
    String? id,
    required this.role,
    required this.startDate,
     this.endDate,
  })  : assert(
          id == null || id.isNotEmpty,
          'id must either be null or not empty',
        ),
        id = id ?? const Uuid().v4();

  /// The unique identifier of the `employee`.
  ///
  /// Cannot be empty.
  final String id;

  /// The name of the `employee`.
  final String name;

  /// The role of the `employee`.

  final String role;

  /// The start date of the `employee`.
  final DateTime startDate;

  /// The end date of the `employee`.
  final DateTime? endDate;

  /// Returns a copy of this `todo` with the given values updated.
  ///
  /// {@macro todo_item}
  Employee copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return Employee(
      id: id ?? this.id,
      name: title ?? this.name,
      role: description ?? this.role,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }

  /// Deserializes the given [JsonMap] into a [Employee].
  static Employee fromJson(JsonMap json) => _$EmployeeFromJson(json);

  /// Converts this [Employee] into a [JsonMap].
  JsonMap toJson() => _$EmployeeToJson(this);

  @override
  List<Object?> get props => [id, name, role, startDate, endDate];
}
