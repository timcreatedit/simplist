// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TaskImpl _$$TaskImplFromJson(Map<String, dynamic> json) => _$TaskImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      created: DateTime.parse(json['created'] as String),
      updated: DateTime.parse(json['updated'] as String),
      scheduled:
          $enumDecodeNullable(_$ScheduleTypeEnumMap, json['scheduled']) ??
              ScheduleType.none,
      completedOn: _$JsonConverterFromJson<String, DateTime?>(
          json['completedOn'], const NullablePbDateConverter().fromJson),
      scheduledOn: _$JsonConverterFromJson<String, DateTime?>(
          json['scheduledOn'], const NullablePbDateConverter().fromJson),
    );

Map<String, dynamic> _$$TaskImplToJson(_$TaskImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'created': instance.created.toIso8601String(),
      'updated': instance.updated.toIso8601String(),
      'scheduled': _$ScheduleTypeEnumMap[instance.scheduled]!,
      'completedOn':
          const NullablePbDateConverter().toJson(instance.completedOn),
      'scheduledOn':
          const NullablePbDateConverter().toJson(instance.scheduledOn),
    };

const _$ScheduleTypeEnumMap = {
  ScheduleType.none: 'none',
  ScheduleType.today: 'today',
  ScheduleType.on: 'on',
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) =>
    json == null ? null : fromJson(json as Json);
