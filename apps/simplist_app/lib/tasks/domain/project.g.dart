// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NewProject _$NewProjectFromJson(Map<String, dynamic> json) => NewProject(
  title: json['title'] as String,
  tasks:
      (json['tasks'] as List<dynamic>?)
          ?.map((e) => Task.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  author: json['author'] as String?,
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$NewProjectToJson(NewProject instance) =>
    <String, dynamic>{
      'title': instance.title,
      'tasks': instance.tasks,
      'author': instance.author,
      'runtimeType': instance.$type,
    };

SavedProject _$SavedProjectFromJson(Map<String, dynamic> json) => SavedProject(
  id: json['id'] as String,
  title: json['title'] as String,
  fileName: json['fileName'] as String,
  tasks:
      (json['tasks'] as List<dynamic>?)
          ?.map((e) => Task.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  author: json['author'] as String?,
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$SavedProjectToJson(SavedProject instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'fileName': instance.fileName,
      'tasks': instance.tasks,
      'author': instance.author,
      'runtimeType': instance.$type,
    };
