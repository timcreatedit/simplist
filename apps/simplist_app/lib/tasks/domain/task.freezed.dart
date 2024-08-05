// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'task.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Task _$TaskFromJson(Map<String, dynamic> json) {
  return _Task.fromJson(json);
}

/// @nodoc
mixin _$Task {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  DateTime get created => throw _privateConstructorUsedError;
  DateTime get updated => throw _privateConstructorUsedError;
  ScheduleType get scheduled => throw _privateConstructorUsedError;
  @NullablePbDateConverter()
  DateTime? get completedOn => throw _privateConstructorUsedError;
  @NullablePbDateConverter()
  DateTime? get scheduledOn => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TaskCopyWith<Task> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TaskCopyWith<$Res> {
  factory $TaskCopyWith(Task value, $Res Function(Task) then) =
      _$TaskCopyWithImpl<$Res, Task>;
  @useResult
  $Res call(
      {String id,
      String title,
      DateTime created,
      DateTime updated,
      ScheduleType scheduled,
      @NullablePbDateConverter() DateTime? completedOn,
      @NullablePbDateConverter() DateTime? scheduledOn});
}

/// @nodoc
class _$TaskCopyWithImpl<$Res, $Val extends Task>
    implements $TaskCopyWith<$Res> {
  _$TaskCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? created = null,
    Object? updated = null,
    Object? scheduled = null,
    Object? completedOn = freezed,
    Object? scheduledOn = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      created: null == created
          ? _value.created
          : created // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updated: null == updated
          ? _value.updated
          : updated // ignore: cast_nullable_to_non_nullable
              as DateTime,
      scheduled: null == scheduled
          ? _value.scheduled
          : scheduled // ignore: cast_nullable_to_non_nullable
              as ScheduleType,
      completedOn: freezed == completedOn
          ? _value.completedOn
          : completedOn // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      scheduledOn: freezed == scheduledOn
          ? _value.scheduledOn
          : scheduledOn // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TaskImplCopyWith<$Res> implements $TaskCopyWith<$Res> {
  factory _$$TaskImplCopyWith(
          _$TaskImpl value, $Res Function(_$TaskImpl) then) =
      __$$TaskImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      DateTime created,
      DateTime updated,
      ScheduleType scheduled,
      @NullablePbDateConverter() DateTime? completedOn,
      @NullablePbDateConverter() DateTime? scheduledOn});
}

/// @nodoc
class __$$TaskImplCopyWithImpl<$Res>
    extends _$TaskCopyWithImpl<$Res, _$TaskImpl>
    implements _$$TaskImplCopyWith<$Res> {
  __$$TaskImplCopyWithImpl(_$TaskImpl _value, $Res Function(_$TaskImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? created = null,
    Object? updated = null,
    Object? scheduled = null,
    Object? completedOn = freezed,
    Object? scheduledOn = freezed,
  }) {
    return _then(_$TaskImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      created: null == created
          ? _value.created
          : created // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updated: null == updated
          ? _value.updated
          : updated // ignore: cast_nullable_to_non_nullable
              as DateTime,
      scheduled: null == scheduled
          ? _value.scheduled
          : scheduled // ignore: cast_nullable_to_non_nullable
              as ScheduleType,
      completedOn: freezed == completedOn
          ? _value.completedOn
          : completedOn // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      scheduledOn: freezed == scheduledOn
          ? _value.scheduledOn
          : scheduledOn // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TaskImpl extends _Task {
  const _$TaskImpl(
      {required this.id,
      required this.title,
      required this.created,
      required this.updated,
      this.scheduled = ScheduleType.none,
      @NullablePbDateConverter() this.completedOn,
      @NullablePbDateConverter() this.scheduledOn})
      : super._();

  factory _$TaskImpl.fromJson(Map<String, dynamic> json) =>
      _$$TaskImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final DateTime created;
  @override
  final DateTime updated;
  @override
  @JsonKey()
  final ScheduleType scheduled;
  @override
  @NullablePbDateConverter()
  final DateTime? completedOn;
  @override
  @NullablePbDateConverter()
  final DateTime? scheduledOn;

  @override
  String toString() {
    return 'Task(id: $id, title: $title, created: $created, updated: $updated, scheduled: $scheduled, completedOn: $completedOn, scheduledOn: $scheduledOn)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TaskImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.created, created) || other.created == created) &&
            (identical(other.updated, updated) || other.updated == updated) &&
            (identical(other.scheduled, scheduled) ||
                other.scheduled == scheduled) &&
            (identical(other.completedOn, completedOn) ||
                other.completedOn == completedOn) &&
            (identical(other.scheduledOn, scheduledOn) ||
                other.scheduledOn == scheduledOn));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, title, created, updated,
      scheduled, completedOn, scheduledOn);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TaskImplCopyWith<_$TaskImpl> get copyWith =>
      __$$TaskImplCopyWithImpl<_$TaskImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TaskImplToJson(
      this,
    );
  }
}

abstract class _Task extends Task {
  const factory _Task(
      {required final String id,
      required final String title,
      required final DateTime created,
      required final DateTime updated,
      final ScheduleType scheduled,
      @NullablePbDateConverter() final DateTime? completedOn,
      @NullablePbDateConverter() final DateTime? scheduledOn}) = _$TaskImpl;
  const _Task._() : super._();

  factory _Task.fromJson(Map<String, dynamic> json) = _$TaskImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  DateTime get created;
  @override
  DateTime get updated;
  @override
  ScheduleType get scheduled;
  @override
  @NullablePbDateConverter()
  DateTime? get completedOn;
  @override
  @NullablePbDateConverter()
  DateTime? get scheduledOn;
  @override
  @JsonKey(ignore: true)
  _$$TaskImplCopyWith<_$TaskImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
