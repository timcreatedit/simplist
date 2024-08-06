import 'package:pocketbase/pocketbase.dart';
import 'package:rxdart/streams.dart';
import 'package:rxdart/subjects.dart';

/// An extension that allows watching a collection with a stream.
extension CollectionWatchExtension on RecordService {
  /// Subscribes to [topic] events on this collection and returns a Stream
  /// that automatically unsubscribes when not listened to anymore.
  Stream<RecordSubscriptionEvent> watchEvents(String topic) {
    late final BehaviorSubject<RecordSubscriptionEvent> subject;

    void subscribe() {
      this.subscribe(
        topic,
        (e) => subject.add(e),
      );
    }

    void unsubscribe() {
      this.unsubscribe(topic);
    }

    subject = BehaviorSubject(
      onListen: subscribe,
      onCancel: unsubscribe,
    );

    return subject.stream;
  }

  /// The watching equivalent of [getFullList].
  ///
  /// Always emits the current list first and then emits a new list on every
  /// change.
  Stream<List<RecordModel>> watchFullList({
    int batch = 500,
    String? expand,
    String? filter,
    String? sort,
    String? fields,
    Map<String, dynamic> query = const {},
    Map<String, String> headers = const {},
  }) {
    Future<List<RecordModel>> get() {
      return getFullList(
        batch: batch,
        expand: expand,
        filter: filter,
        sort: sort,
        fields: fields,
        query: query,
        headers: headers,
      );
    }

    return Stream.fromFuture(get()).concatWith([
      watchEvents('*').asyncMap((_) => get()),
    ]);
  }

  /// The watching equivalent of [getOne].
  ///
  /// Always emits the current element first and subscribes to updates.
  Stream<RecordModel> watchOne(
    String id, {
    String? expand,
    String? fields,
    Map<String, dynamic> query = const {},
    Map<String, String> headers = const {},
  }) {
    Future<RecordModel> get() {
      return getOne(
        id,
        expand: expand,
        fields: fields,
        query: query,
        headers: headers,
      );
    }

    return Stream.fromFuture(get()).concatWith([
      watchEvents(id).asyncMap((_) => get()),
    ]);
  }
}
