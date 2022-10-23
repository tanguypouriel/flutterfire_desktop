
import 'package:firebase_firestore_dart/src/auth/credentials_provider.dart';
import 'package:firebase_firestore_dart/src/core/database_info.dart';
import 'package:firebase_firestore_dart/src/remote/grpc_call_provider.dart';
import 'package:firebase_firestore_dart/src/remote/grpc_metadata_provider.dart';
import 'package:firebase_firestore_dart/src/util/async_queue.dart';

/// Wrapper class around io.grpc.Channel that adds headers, exception handling and simplifies
/// invoking RPCs.
class FirestoreChannel {

  final AsyncQueue _asyncQueue;
  final CredentialsProvider<User> _authProvider;
  final CredentialsProvider<String> _appCheckProvider;
  final GrpcCallProvider _callProvider;
  final String resourcePrefixValue;
  final GrpcMetadataProvider _metadataProvider;

  FirestoreChannel(
    this._asyncQueue,
      String context,
      this._authProvider,
      this._appCheckProvider,
      DatabaseInfo databaseInfo,
      this._metadataProvider,
      ) {

  }
}
