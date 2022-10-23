import 'package:firebase_firestore_dart/src/auth/credentials_provider.dart';
import 'package:firebase_firestore_dart/src/core/database_info.dart';
import 'package:firebase_firestore_dart/src/remote/firestore_channel.dart';
import 'package:firebase_firestore_dart/src/remote/grpc_metadata_provider.dart';
import 'package:firebase_firestore_dart/src/remote/remote_serializer.dart';
import 'package:firebase_firestore_dart/src/util/async_queue.dart';

/// Datastore represents a proxy for the remote server, hiding details of the RPC layer. It:
///
/// <ul>
///   <li>Manages connections to the server
///   <li>Authenticates to the server
///   <li>Manages threading and keeps higher-level code running on the worker queue
///   <li>Serializes internal model objects to and from protocol buffers
/// </ul>
///
/// <p>The Datastore is generally not responsible for understanding the higher-level protocol
/// involved in actually making changes or reading data, and is otherwise stateless.
class Datastore {

  /// Error message to surface when Firestore fails to establish an SSL connection. A failed SSL
  /// connection likely indicates that the developer needs to provide an updated OpenSSL stack as
  /// part of their app's dependencies.
  static final String sslDependencyErrorMessage =
      "The Cloud Firestore client failed to establish a secure connection."
      " This is likely a problem with your app, rather than with Cloud Firestore"
      " itself. See https://bit.ly/2XFpdma for instructions on how to enable TLS"
      " on Android 4.x devices.";

  /// Set of lowercase, white-listed headers for logging purposes.
  static final Set<String> whiteListedHeaders = {
    "date",
    "x-google-backends",
    "x-google-netmon-label",
    "x-google-service",
    "x-google-gfe-request-trace",
  };

  final DatabaseInfo _databaseInfo;
  final RemoteSerializer _serializer;
  final AsyncQueue _workerQueue;

  final FirestoreChannel _channel;

  Datastore(this._databaseInfo,
      this._workerQueue,
      CredentialsProvider<User> authProvider,
      CredentialsProvider<String> appCheckProvider,
      String context, // TODO
      GrpcMetadataProvider metadataProvider,)
      :
        _channel = FirestoreChannel(
            _workerQueue, context, authProvider, appCheckProvider,
            _databaseInfo, metadataProvider),
        _serializer = RemoteSerializer(_databaseInfo.databaseId);

  AsyncQueue get workerQueue => _workerQueue;

  DatabaseInfo get databaseInfo => _databaseInfo;
  
}
