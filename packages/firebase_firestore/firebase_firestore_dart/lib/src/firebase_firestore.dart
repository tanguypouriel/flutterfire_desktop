
import 'package:firebase_core_dart/firebase_core_dart.dart';

import 'package:meta/meta.dart';

/// Represents a Cloud Firestore database and is the entry point for all Cloud Firestore operations.
///
/// <p><b>Subclassing Note</b>: Cloud Firestore classes are not meant to be subclassed except for use
/// in test mocks. Subclassing is not supported in production code and new SDK releases may break
/// code that does so.
class FirebaseFirestore {

  @visibleForTesting
  FirebaseFirestore({required this.app});

  /// Gets the [FirebaseFirestore] instance for the given [app] and [region].
  factory FirebaseFirestore.instanceFor({
    required FirebaseApp app,
  }) {
    final _app = app ?? Firebase.app();
    if (_instances[_app] == null) {
      _instances[_app] = FirebaseFirestore(app: _app);
    }
    return _instances[_app]!;
  }

  static final Map<FirebaseApp, FirebaseFirestore> _instances = {};

  /// The [FirebaseApp] instance used to create this [FirebaseFunctions] instance.
  final FirebaseApp app;

  static FirebaseFirestore get instance {
    return FirebaseFirestore(app: Firebase.app());
  }

}