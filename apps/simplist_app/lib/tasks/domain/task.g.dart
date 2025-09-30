// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Task _$TaskFromJson(Map<String, dynamic> json) => _Task(
  id: json['id'] as String,
  title: json['title'] as String,
  status:
      $enumDecodeNullable(_$TaskStatusEnumMap, json['status']) ??
      TaskStatus.todo,
  completedAt: _$JsonConverterFromJson<String, DateTime?>(
    json['completedAt'],
    const NullablePbDateConverter().fromJson,
  ),
  tags:
      (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  description: json['description'] as String?,
  deadline: _$JsonConverterFromJson<String, DateTime?>(
    json['deadline'],
    const NullablePbDateConverter().fromJson,
  ),
  scheduled: _$JsonConverterFromJson<String, DateTime?>(
    json['scheduled'],
    const NullablePbDateConverter().fromJson,
  ),
  parentId: json['parentId'] as String?,
  subtasks:
      (json['subtasks'] as List<dynamic>?)
          ?.map((e) => Task.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  priority: json['priority'] as String?,
);

Map<String, dynamic> _$TaskToJson(_Task instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'status': _$TaskStatusEnumMap[instance.status]!,
  'completedAt': const NullablePbDateConverter().toJson(instance.completedAt),
  'tags': instance.tags,
  'description': instance.description,
  'deadline': const NullablePbDateConverter().toJson(instance.deadline),
  'scheduled': const NullablePbDateConverter().toJson(instance.scheduled),
  'parentId': instance.parentId,
  'subtasks': instance.subtasks,
  'priority': instance.priority,
};

const _$TaskStatusEnumMap = {TaskStatus.todo: 'TODO', TaskStatus.done: 'DONE'};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);
