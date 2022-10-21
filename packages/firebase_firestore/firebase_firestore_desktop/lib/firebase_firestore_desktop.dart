library firebase_firestore_desktop;

import 'dart:typed_data';

import 'package:cloud_firestore_platform_interface/cloud_firestore_platform_interface.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_dart/firebase_core_dart.dart' as firebase_dart;
import 'package:firebase_firestore_dart/firebase_firestore_dart.dart' as firestore_dart;

/// Desktop implementation of [FirebaseFirestorePlatform] for managing FirebaseFunctions.
class FirebaseFirestoreDesktop extends FirebaseFirestorePlatform {

  /// Constructs a FirebaseFunctionsDesktop.
  FirebaseFirestoreDesktop({
    required FirebaseApp? app,
  }) : super(appInstance: app);

  FirebaseFirestoreDesktop._()
      : _dartFirestore = null,
        super(appInstance: null);

  /// Called by PluginRegistry to register this plugin as the implementation for Desktop.
  static void registerWith() {
    FirebaseFirestorePlatform.instance = FirebaseFirestoreDesktop.instance;
  }

  /// Stub initializer to allow creating an instance without
  /// registering delegates or listeners.
  // ignore: prefer_constructors_over_static_methods
  static FirebaseFirestoreDesktop get instance {
    return FirebaseFirestoreDesktop._();
  }

  /// Instance of firestore from the dart package.
  firestore_dart.FirebaseFirestore? _dartFirestore;

  /// Lazily initialize [_dartFirestore] on first method call.
  firestore_dart.FirebaseFirestore get _delegate {
    return _dartFirestore ??= firestore_dart.FirebaseFirestore.instanceFor(
      app: firebase_dart.Firebase.app(app.name),
    );
  }

  @override
  FirebaseFirestorePlatform delegateFor({
    FirebaseApp? app,
  }) =>
      FirebaseFirestoreDesktop(app: app);

  /// useEmulator is used for web only. Native platforms use Firestore settings
  /// to initialize emulator.
  void useEmulator(String host, int port) {
    throw UnimplementedError('useEmulator() is not implemented');
  }

  /// Creates a write batch, used for performing multiple writes as a single
  /// atomic operation.
  ///
  /// Unlike transactions, write batches are persisted offline and therefore are
  /// preferable when you don’t need to condition your writes on read data.
  WriteBatchPlatform batch() {
    throw UnimplementedError('batch() is not implemented');
  }

  /// Clears any persisted data for the current instance.
  Future<void> clearPersistence() {
    throw UnimplementedError('clearPersistence() is not implemented');
  }

  /// Enable persistence of Firestore data. Web only.
  Future<void> enablePersistence(
      [PersistenceSettings? persistenceSettings]) async {
    throw UnimplementedError('enablePersistence() is not implemented');
  }

  /// Gets a [CollectionReferencePlatform] for the specified Firestore path.
  CollectionReferencePlatform collection(String collectionPath) {
    throw UnimplementedError('collection() is not implemented');
  }

  /// Gets a [QueryPlatform] for the specified collection group.
  QueryPlatform collectionGroup(String collectionPath) {
    throw UnimplementedError('collectionGroup() is not implemented');
  }

  /// Disables network usage for this instance. It can be re-enabled via
  /// [enableNetwork()]. While the network is disabled, any snapshot listeners or
  /// [get()] calls will return results from cache, and any write operations will
  /// be queued until the network is restored.
  Future<void> disableNetwork() {
    throw UnimplementedError('disableNetwork() is not implemented');
  }

  /// Gets a [DocumentReferencePlatform] for the specified Firestore path.
  DocumentReferencePlatform doc(String documentPath) {
    throw UnimplementedError('doc() is not implemented');
  }

  /// Re-enables use of the network for this Firestore instance after a prior
  /// call to [disableNetwork()].
  Future<void> enableNetwork() {
    throw UnimplementedError('enableNetwork() is not implemented');
  }

  /// Returns a [Steam] which is called each time all of the active listeners
  /// have been synchronised.
  Stream<void> snapshotsInSync() {
    throw UnimplementedError('snapshotsInSync() is not implemented');
  }

  /// Loads a Firestore bundle into the local cache. Returns a [LoadBundleTask]
  /// which notifies callers with progress updates, and completion or error events.
  LoadBundleTaskPlatform loadBundle(Uint8List bundle) {
    throw UnimplementedError('loadBundle() is not implemented');
  }

  /// Reads a Firestore Query which has been loaded using [loadBundle()]
  Future<QuerySnapshotPlatform> namedQueryGet(
      String name, {
        GetOptions options = const GetOptions(),
      }) {
    throw UnimplementedError('namedQueryGet() is not implemented');
  }

  /// Executes the given [TransactionHandler] and then attempts to commit the
  /// changes applied within an atomic transaction.
  ///
  /// In the [TransactionHandler], a set of reads and writes can be performed
  /// atomically using the [MethodChannelTransaction] object passed to the [TransactionHandler].
  /// After the [TransactionHandler] is run, Firestore will attempt to apply the
  /// changes to the server. If any of the data read has been modified outside
  /// of this transaction since being read, then the transaction will be
  /// retried by executing the provided [TransactionHandler] again. If the transaction still
  /// fails after 5 retries, then the transaction will fail.
  ///
  /// The [TransactionHandler] may be executed multiple times, it should be able
  /// to handle multiple executions.
  ///
  /// Data accessed with the transaction will not reflect local changes that
  /// have not been committed. For this reason, it is required that all
  /// reads are performed before any writes. Transactions must be performed
  /// while online. Otherwise, reads will fail, and the final commit will fail.
  ///
  /// By default transactions are limited to 5 seconds of execution time. This
  /// timeout can be adjusted by setting the [timeout] parameter.
  ///
  /// By default transactions will retry 5 times. You can change the number of attemps
  /// with [maxAttempts]. Attempts should be at least 1.
  Future<T?> runTransaction<T>(TransactionHandler<T> transactionHandler,
      {Duration timeout = const Duration(seconds: 30), int maxAttempts = 5}) {
    throw UnimplementedError('runTransaction() is not implemented');
  }

  /// Get the current [Settings] for this [FirebaseFirestorePlatform] instance.
  Settings get settings {
    throw UnimplementedError('settings getter is not implemented');
  }

  /// Specifies custom settings to be used to configure this [FirebaseFirestorePlatform] instance.
  ///
  /// You must set these before invoking any other methods on this [FirebaseFirestorePlatform] instance.
  set settings(Settings settings) {
    throw UnimplementedError('settings setter is not implemented');
  }

  /// Terminates this [FirebaseFirestorePlatform] instance.
  ///
  /// After calling [terminate()] only the [clearPersistence()] method may be used.
  /// Any other method will throw a [FirebaseException].
  ///
  /// Termination does not cancel any pending writes, and any promises that are
  /// awaiting a response from the server will not be resolved. If you have
  /// persistence enabled, the next time you start this instance, it will resume
  ///  sending these writes to the server.
  ///
  /// Note: Under normal circumstances, calling [terminate()] is not required.
  /// This method is useful only when you want to force this instance to release
  /// all of its resources or in combination with [clearPersistence()] to ensure
  /// that all local state is destroyed between test runs.
  Future<void> terminate() {
    throw UnimplementedError('terminate() is not implemented');
  }

  /// Waits until all currently pending writes for the active user have been
  /// acknowledged by the backend.
  ///
  /// The returned [Future] resolves immediately if there are no outstanding writes.
  /// Otherwise, the [Promise] waits for all previously issued writes (including
  /// those written in a previous app session), but it does not wait for writes
  /// that were added after the method is called. If you want to wait for
  /// additional writes, call [waitForPendingWrites()] again.
  ///
  /// Any outstanding [waitForPendingWrites()] calls are rejected during user changes.
  Future<void> waitForPendingWrites() {
    throw UnimplementedError('waitForPendingWrites() is not implemented');
  }

  @override
  //ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) =>
      other is FirebaseFirestorePlatform && other.app.name == app.name;

  @override
  //ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode => toString().hashCode;

  @override
  String toString() => '$FirebaseFirestorePlatform(app: ${app.name})';

}