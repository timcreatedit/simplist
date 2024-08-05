import 'package:freezed_annotation/freezed_annotation.dart';

class NullablePbDateConverter extends JsonConverter<DateTime?, String> {
  const NullablePbDateConverter();

  @override
  DateTime? fromJson(String json) {
    if (json.isEmpty) return null;
    return DateTime.tryParse(json.replaceAll(" ", "T"));
  }

  @override
  String toJson(DateTime? object) {
    return object?.toIso8601String().replaceAll("T", " ") ?? "";
  }
}

class PbDateConverter extends JsonConverter<DateTime, String> {
  const PbDateConverter();

  @override
  DateTime fromJson(String json) {
    return DateTime.parse(json.replaceAll(" ", "T"));
  }

  @override
  String toJson(DateTime object) {
    return object.toIso8601String().replaceAll("T", " ");
  }
}
