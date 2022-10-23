import 'package:firebase_firestore_dart/src/auth/credentials_provider.dart';
import 'package:firebase_firestore_dart/src/remote/grpc_metadata_provider.dart';
import 'package:firebase_firestore_dart/src/remote/remote_store.dart';
import 'package:firebase_firestore_dart/src/util/async_queue.dart';

/// FirestoreClient is a top-level class that constructs and owns all of the pieces of the client SDK
/// architecture.
class FirestoreClient {
  static final String tag = "FirestoreClient";

  final DatabaseInfo _databaseInfo;
  final CredentialsProvider<User> _authProvider;
  final CredentialsProvider<String> appCheckProvider;
  final AsyncQueue _asyncQueue;
  final BundleSerializer _bundleSerializer;
  final GrpcMetadataProvider _metadataProvider;

  final Persistence _persistence;
  final LocalStore _localStore;
  final RemoteStore _remoteStore;
  final SyncEngine _syncEngine;
  final EventManager _eventManager;
}
