import 'dart:async';

import 'package:path_provider/path_provider.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

/// {@template pocketbased.SembastAuthStore}
/// A pocketbase [AuthStore] that persists authentication data using sembast.
/// {@endtemplate}
class SembastAuthStore extends AuthStore {
  /// {@macro pocketbased.SembastAuthStore}
  SembastAuthStore({
    Database? db,
    StoreRef<String, dynamic>? store,
  }) : store = store ?? StoreRef("auth") {
    _initialized.complete(_init(db));
  }

  /// A reference to a sembast database.
  late final Database db;

  /// The sembast [StoreRef] to use for persisting auth data.
  ///
  /// Defaults to a [StoreRef] with the ID "auth".
  final StoreRef<String, dynamic> store;

  final Completer<void> _initialized = Completer();

  /// Whether this store is properly initialized.
  ///
  /// Await this before using the store to make sure it is populated.
  Future<void> get initialized => _initialized.future;

  @override
  void save(String newToken, dynamic newModel) {
    if (!_initialized.isCompleted) {
      throw StateError(
        "Tried to save credentials before SembastAuthStore was initialized",
      );
    }
    super.save(newToken, newModel);
    db.transaction(
      (transaction) async {
        await store.record('token').add(transaction, token);

        switch (newModel) {
          case final RecordModel model:
            await store.record('model').add(transaction, model.toJson());
          case final AdminModel model:
            await store.record('model').add(transaction, model.toJson());
        }
      },
    );
  }

  @override
  void clear() {
    if (!_initialized.isCompleted) {
      throw StateError(
        "Tried to clear credentials before SembastAuthStore was initialized",
      );
    }
    super.clear();
    store.delete(db);
  }

  Future<void> _init(Database? initialDb) async {
    await _initDatabase(initialDb);

    final token = await store.record('token').get(db);
    final model = await store.record('model').get(db);
    switch (token) {
      case final String token:
        super.save(token, _parseModel(model as Map<String, dynamic>?));
      case null:
        return;
      default:
        throw StateError("Read a token from the database that wasn't a string");
    }
  }

  Future<void> _initDatabase(Database? initialDb) async {
    if (initialDb != null) {
      db = initialDb;
      return;
    }

    final dir = await getApplicationDocumentsDirectory();
    await dir.create(recursive: true);
    final dbPath = "${dir.path}/database.db";
    db = await databaseFactoryIo.openDatabase(dbPath);
  }

  dynamic _parseModel(Map<String, dynamic>? rawModel) {
    if (rawModel == null) return null;
    if (rawModel.containsKey("collectionId") ||
        rawModel.containsKey("collectionName") ||
        rawModel.containsKey("verified") ||
        rawModel.containsKey("emailVisibility")) {
      return RecordModel.fromJson(rawModel);
    } else if (rawModel.containsKey("id")) {
      return AdminModel.fromJson(rawModel);
    }
  }
}
