// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Project _$ProjectFromJson(Map<String, dynamic> json) => _Project(
  id: json['id'] as String,
  title: json['title'] as String,
  tasks: (json['tasks'] as List<dynamic>)
      .map((e) => Task.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$ProjectToJson(_Project instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'tasks': instance.tasks,
};
