import 'package:firebase_firestore_dart/src/model/database_id.dart';

/// Contains info about host, project id and database
class DatabaseInfo {
  final DatabaseId _databaseId;
  final String _persistenceKey;
  final String _host;
  final bool _sslEnabled;

  /// Constructs a new DatabaseInfo.
  ///
  /// [_databaseId] - The Google Cloud Project ID and database naming the Firestore instance.
  /// [_persistenceKey] - A unique identifier for this Firestore's local storage. Usually derived
  ///     from FirebaseApp.name.
  /// [_host] - The hostname of the backend.
  /// [_sslEnabled] - Whether to use SSL when connecting.
  DatabaseInfo(
    this._databaseId,
    this._persistenceKey,
    this._host,
    this._sslEnabled,
  );

  DatabaseId get databaseId => _databaseId;

  String get persistenceKey => _persistenceKey;

  String get host => _host;

  bool get isSslEnabled => _sslEnabled;
}
