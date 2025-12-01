// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'project.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
Project _$ProjectFromJson(
  Map<String, dynamic> json
) {
        switch (json['runtimeType']) {
                  case 'create':
          return NewProject.fromJson(
            json
          );
                case 'default':
          return SavedProject.fromJson(
            json
          );
        
          default:
            throw CheckedFromJsonException(
  json,
  'runtimeType',
  'Project',
  'Invalid union type "${json['runtimeType']}"!'
);
        }
      
}

/// @nodoc
mixin _$Project {

 String get title; List<Task> get tasks; String? get author;
/// Create a copy of Project
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProjectCopyWith<Project> get copyWith => _$ProjectCopyWithImpl<Project>(this as Project, _$identity);

  /// Serializes this Project to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Project&&(identical(other.title, title) || other.title == title)&&const DeepCollectionEquality().equals(other.tasks, tasks)&&(identical(other.author, author) || other.author == author));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,const DeepCollectionEquality().hash(tasks),author);

@override
String toString() {
  return 'Project(title: $title, tasks: $tasks, author: $author)';
}


}

/// @nodoc
abstract mixin class $ProjectCopyWith<$Res>  {
  factory $ProjectCopyWith(Project value, $Res Function(Project) _then) = _$ProjectCopyWithImpl;
@useResult
$Res call({
 String title, List<Task> tasks, String? author
});




}
/// @nodoc
class _$ProjectCopyWithImpl<$Res>
    implements $ProjectCopyWith<$Res> {
  _$ProjectCopyWithImpl(this._self, this._then);

  final Project _self;
  final $Res Function(Project) _then;

/// Create a copy of Project
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? tasks = null,Object? author = freezed,}) {
  return _then(_self.copyWith(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,tasks: null == tasks ? _self.tasks : tasks // ignore: cast_nullable_to_non_nullable
as List<Task>,author: freezed == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Project].
extension ProjectPatterns on Project {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( SavedProject value)?  $default,{TResult Function( NewProject value)?  create,required TResult orElse(),}){
final _that = this;
switch (_that) {
case NewProject() when create != null:
return create(_that);case SavedProject() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( SavedProject value)  $default,{required TResult Function( NewProject value)  create,}){
final _that = this;
switch (_that) {
case NewProject():
return create(_that);case SavedProject():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( SavedProject value)?  $default,{TResult? Function( NewProject value)?  create,}){
final _that = this;
switch (_that) {
case NewProject() when create != null:
return create(_that);case SavedProject() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String fileName,  List<Task> tasks,  String? author)?  $default,{TResult Function( String title,  List<Task> tasks,  String? author)?  create,required TResult orElse(),}) {final _that = this;
switch (_that) {
case NewProject() when create != null:
return create(_that.title,_that.tasks,_that.author);case SavedProject() when $default != null:
return $default(_that.id,_that.title,_that.fileName,_that.tasks,_that.author);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String fileName,  List<Task> tasks,  String? author)  $default,{required TResult Function( String title,  List<Task> tasks,  String? author)  create,}) {final _that = this;
switch (_that) {
case NewProject():
return create(_that.title,_that.tasks,_that.author);case SavedProject():
return $default(_that.id,_that.title,_that.fileName,_that.tasks,_that.author);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String fileName,  List<Task> tasks,  String? author)?  $default,{TResult? Function( String title,  List<Task> tasks,  String? author)?  create,}) {final _that = this;
switch (_that) {
case NewProject() when create != null:
return create(_that.title,_that.tasks,_that.author);case SavedProject() when $default != null:
return $default(_that.id,_that.title,_that.fileName,_that.tasks,_that.author);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class NewProject extends Project {
  const NewProject({required this.title, final  List<Task> tasks = const [], this.author, final  String? $type}): _tasks = tasks,$type = $type ?? 'create',super._();
  factory NewProject.fromJson(Map<String, dynamic> json) => _$NewProjectFromJson(json);

@override final  String title;
 final  List<Task> _tasks;
@override@JsonKey() List<Task> get tasks {
  if (_tasks is EqualUnmodifiableListView) return _tasks;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tasks);
}

@override final  String? author;

@JsonKey(name: 'runtimeType')
final String $type;


/// Create a copy of Project
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NewProjectCopyWith<NewProject> get copyWith => _$NewProjectCopyWithImpl<NewProject>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NewProjectToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NewProject&&(identical(other.title, title) || other.title == title)&&const DeepCollectionEquality().equals(other._tasks, _tasks)&&(identical(other.author, author) || other.author == author));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,const DeepCollectionEquality().hash(_tasks),author);

@override
String toString() {
  return 'Project.create(title: $title, tasks: $tasks, author: $author)';
}


}

/// @nodoc
abstract mixin class $NewProjectCopyWith<$Res> implements $ProjectCopyWith<$Res> {
  factory $NewProjectCopyWith(NewProject value, $Res Function(NewProject) _then) = _$NewProjectCopyWithImpl;
@override @useResult
$Res call({
 String title, List<Task> tasks, String? author
});




}
/// @nodoc
class _$NewProjectCopyWithImpl<$Res>
    implements $NewProjectCopyWith<$Res> {
  _$NewProjectCopyWithImpl(this._self, this._then);

  final NewProject _self;
  final $Res Function(NewProject) _then;

/// Create a copy of Project
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? tasks = null,Object? author = freezed,}) {
  return _then(NewProject(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,tasks: null == tasks ? _self._tasks : tasks // ignore: cast_nullable_to_non_nullable
as List<Task>,author: freezed == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
@JsonSerializable()

class SavedProject extends Project {
  const SavedProject({required this.id, required this.title, required this.fileName, final  List<Task> tasks = const [], this.author, final  String? $type}): _tasks = tasks,$type = $type ?? 'default',super._();
  factory SavedProject.fromJson(Map<String, dynamic> json) => _$SavedProjectFromJson(json);

 final  String id;
@override final  String title;
 final  String fileName;
 final  List<Task> _tasks;
@override@JsonKey() List<Task> get tasks {
  if (_tasks is EqualUnmodifiableListView) return _tasks;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tasks);
}

@override final  String? author;

@JsonKey(name: 'runtimeType')
final String $type;


/// Create a copy of Project
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SavedProjectCopyWith<SavedProject> get copyWith => _$SavedProjectCopyWithImpl<SavedProject>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SavedProjectToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SavedProject&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.fileName, fileName) || other.fileName == fileName)&&const DeepCollectionEquality().equals(other._tasks, _tasks)&&(identical(other.author, author) || other.author == author));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,fileName,const DeepCollectionEquality().hash(_tasks),author);

@override
String toString() {
  return 'Project(id: $id, title: $title, fileName: $fileName, tasks: $tasks, author: $author)';
}


}

/// @nodoc
abstract mixin class $SavedProjectCopyWith<$Res> implements $ProjectCopyWith<$Res> {
  factory $SavedProjectCopyWith(SavedProject value, $Res Function(SavedProject) _then) = _$SavedProjectCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String fileName, List<Task> tasks, String? author
});




}
/// @nodoc
class _$SavedProjectCopyWithImpl<$Res>
    implements $SavedProjectCopyWith<$Res> {
  _$SavedProjectCopyWithImpl(this._self, this._then);

  final SavedProject _self;
  final $Res Function(SavedProject) _then;

/// Create a copy of Project
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? fileName = null,Object? tasks = null,Object? author = freezed,}) {
  return _then(SavedProject(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,fileName: null == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String,tasks: null == tasks ? _self._tasks : tasks // ignore: cast_nullable_to_non_nullable
as List<Task>,author: freezed == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
