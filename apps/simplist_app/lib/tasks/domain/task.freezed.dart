// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'task.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Task {

 String get id; String get title; TaskStatus get status;@NullablePbDateConverter() DateTime? get completedAt; List<String> get tags; String? get description;@NullablePbDateConverter() DateTime? get deadline;@NullablePbDateConverter() DateTime? get scheduled; String? get parentId; List<Task> get subtasks; String? get priority;
/// Create a copy of Task
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskCopyWith<Task> get copyWith => _$TaskCopyWithImpl<Task>(this as Task, _$identity);

  /// Serializes this Task to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Task&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.status, status) || other.status == status)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&const DeepCollectionEquality().equals(other.tags, tags)&&(identical(other.description, description) || other.description == description)&&(identical(other.deadline, deadline) || other.deadline == deadline)&&(identical(other.scheduled, scheduled) || other.scheduled == scheduled)&&(identical(other.parentId, parentId) || other.parentId == parentId)&&const DeepCollectionEquality().equals(other.subtasks, subtasks)&&(identical(other.priority, priority) || other.priority == priority));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,status,completedAt,const DeepCollectionEquality().hash(tags),description,deadline,scheduled,parentId,const DeepCollectionEquality().hash(subtasks),priority);

@override
String toString() {
  return 'Task(id: $id, title: $title, status: $status, completedAt: $completedAt, tags: $tags, description: $description, deadline: $deadline, scheduled: $scheduled, parentId: $parentId, subtasks: $subtasks, priority: $priority)';
}


}

/// @nodoc
abstract mixin class $TaskCopyWith<$Res>  {
  factory $TaskCopyWith(Task value, $Res Function(Task) _then) = _$TaskCopyWithImpl;
@useResult
$Res call({
 String id, String title, TaskStatus status,@NullablePbDateConverter() DateTime? completedAt, List<String> tags, String? description,@NullablePbDateConverter() DateTime? deadline,@NullablePbDateConverter() DateTime? scheduled, String? parentId, List<Task> subtasks, String? priority
});




}
/// @nodoc
class _$TaskCopyWithImpl<$Res>
    implements $TaskCopyWith<$Res> {
  _$TaskCopyWithImpl(this._self, this._then);

  final Task _self;
  final $Res Function(Task) _then;

/// Create a copy of Task
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? status = null,Object? completedAt = freezed,Object? tags = null,Object? description = freezed,Object? deadline = freezed,Object? scheduled = freezed,Object? parentId = freezed,Object? subtasks = null,Object? priority = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TaskStatus,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,deadline: freezed == deadline ? _self.deadline : deadline // ignore: cast_nullable_to_non_nullable
as DateTime?,scheduled: freezed == scheduled ? _self.scheduled : scheduled // ignore: cast_nullable_to_non_nullable
as DateTime?,parentId: freezed == parentId ? _self.parentId : parentId // ignore: cast_nullable_to_non_nullable
as String?,subtasks: null == subtasks ? _self.subtasks : subtasks // ignore: cast_nullable_to_non_nullable
as List<Task>,priority: freezed == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Task].
extension TaskPatterns on Task {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Task value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Task() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Task value)  $default,){
final _that = this;
switch (_that) {
case _Task():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Task value)?  $default,){
final _that = this;
switch (_that) {
case _Task() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  TaskStatus status, @NullablePbDateConverter()  DateTime? completedAt,  List<String> tags,  String? description, @NullablePbDateConverter()  DateTime? deadline, @NullablePbDateConverter()  DateTime? scheduled,  String? parentId,  List<Task> subtasks,  String? priority)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Task() when $default != null:
return $default(_that.id,_that.title,_that.status,_that.completedAt,_that.tags,_that.description,_that.deadline,_that.scheduled,_that.parentId,_that.subtasks,_that.priority);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  TaskStatus status, @NullablePbDateConverter()  DateTime? completedAt,  List<String> tags,  String? description, @NullablePbDateConverter()  DateTime? deadline, @NullablePbDateConverter()  DateTime? scheduled,  String? parentId,  List<Task> subtasks,  String? priority)  $default,) {final _that = this;
switch (_that) {
case _Task():
return $default(_that.id,_that.title,_that.status,_that.completedAt,_that.tags,_that.description,_that.deadline,_that.scheduled,_that.parentId,_that.subtasks,_that.priority);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  TaskStatus status, @NullablePbDateConverter()  DateTime? completedAt,  List<String> tags,  String? description, @NullablePbDateConverter()  DateTime? deadline, @NullablePbDateConverter()  DateTime? scheduled,  String? parentId,  List<Task> subtasks,  String? priority)?  $default,) {final _that = this;
switch (_that) {
case _Task() when $default != null:
return $default(_that.id,_that.title,_that.status,_that.completedAt,_that.tags,_that.description,_that.deadline,_that.scheduled,_that.parentId,_that.subtasks,_that.priority);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Task extends Task {
  const _Task({required this.id, required this.title, this.status = TaskStatus.todo, @NullablePbDateConverter() this.completedAt, final  List<String> tags = const [], this.description, @NullablePbDateConverter() this.deadline, @NullablePbDateConverter() this.scheduled, this.parentId, final  List<Task> subtasks = const [], this.priority}): _tags = tags,_subtasks = subtasks,super._();
  factory _Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);

@override final  String id;
@override final  String title;
@override@JsonKey() final  TaskStatus status;
@override@NullablePbDateConverter() final  DateTime? completedAt;
 final  List<String> _tags;
@override@JsonKey() List<String> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tags);
}

@override final  String? description;
@override@NullablePbDateConverter() final  DateTime? deadline;
@override@NullablePbDateConverter() final  DateTime? scheduled;
@override final  String? parentId;
 final  List<Task> _subtasks;
@override@JsonKey() List<Task> get subtasks {
  if (_subtasks is EqualUnmodifiableListView) return _subtasks;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_subtasks);
}

@override final  String? priority;

/// Create a copy of Task
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TaskCopyWith<_Task> get copyWith => __$TaskCopyWithImpl<_Task>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TaskToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Task&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.status, status) || other.status == status)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&const DeepCollectionEquality().equals(other._tags, _tags)&&(identical(other.description, description) || other.description == description)&&(identical(other.deadline, deadline) || other.deadline == deadline)&&(identical(other.scheduled, scheduled) || other.scheduled == scheduled)&&(identical(other.parentId, parentId) || other.parentId == parentId)&&const DeepCollectionEquality().equals(other._subtasks, _subtasks)&&(identical(other.priority, priority) || other.priority == priority));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,status,completedAt,const DeepCollectionEquality().hash(_tags),description,deadline,scheduled,parentId,const DeepCollectionEquality().hash(_subtasks),priority);

@override
String toString() {
  return 'Task(id: $id, title: $title, status: $status, completedAt: $completedAt, tags: $tags, description: $description, deadline: $deadline, scheduled: $scheduled, parentId: $parentId, subtasks: $subtasks, priority: $priority)';
}


}

/// @nodoc
abstract mixin class _$TaskCopyWith<$Res> implements $TaskCopyWith<$Res> {
  factory _$TaskCopyWith(_Task value, $Res Function(_Task) _then) = __$TaskCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, TaskStatus status,@NullablePbDateConverter() DateTime? completedAt, List<String> tags, String? description,@NullablePbDateConverter() DateTime? deadline,@NullablePbDateConverter() DateTime? scheduled, String? parentId, List<Task> subtasks, String? priority
});




}
/// @nodoc
class __$TaskCopyWithImpl<$Res>
    implements _$TaskCopyWith<$Res> {
  __$TaskCopyWithImpl(this._self, this._then);

  final _Task _self;
  final $Res Function(_Task) _then;

/// Create a copy of Task
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? status = null,Object? completedAt = freezed,Object? tags = null,Object? description = freezed,Object? deadline = freezed,Object? scheduled = freezed,Object? parentId = freezed,Object? subtasks = null,Object? priority = freezed,}) {
  return _then(_Task(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TaskStatus,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,deadline: freezed == deadline ? _self.deadline : deadline // ignore: cast_nullable_to_non_nullable
as DateTime?,scheduled: freezed == scheduled ? _self.scheduled : scheduled // ignore: cast_nullable_to_non_nullable
as DateTime?,parentId: freezed == parentId ? _self.parentId : parentId // ignore: cast_nullable_to_non_nullable
as String?,subtasks: null == subtasks ? _self._subtasks : subtasks // ignore: cast_nullable_to_non_nullable
as List<Task>,priority: freezed == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
