
import 'package:firebase_core_dart/firebase_core_dart.dart';

import 'package:meta/meta.dart';

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