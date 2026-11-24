import 'package:freezed_annotation/freezed_annotation.dart';

/// D13: simpanan memakai UTC supaya pindah zona waktu tidak menggeser waktu pet.
class UtcDateTimeConverter extends JsonConverter<DateTime, String> {
  const UtcDateTimeConverter();

  @override
  DateTime fromJson(String json) => DateTime.parse(json).toLocal();

  @override
  String toJson(DateTime object) => object.toUtc().toIso8601String();
}
