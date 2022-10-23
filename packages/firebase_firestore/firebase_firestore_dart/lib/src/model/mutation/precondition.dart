import 'package:firebase_firestore_dart/src/model/mutable_document.dart';
import 'package:firebase_firestore_dart/src/model/snapshot_version.dart';

/// Encodes a precondition for a mutation. This follows the model that the backend accepts with the
/// special case of an explicit "empty" precondition (meaning no precondition).
class Precondition {
  static final Precondition none = Precondition._(null, null);

  /// If set, preconditions a mutation based on the last updateTime.
  final SnapshotVersion? _updateTime;

  /// If set, preconditions a mutation based on whether the document exists.
  final bool? _exists;

  Precondition._(this._updateTime, this._exists)
      : assert(
          _updateTime == null || _exists == null,
          "Precondition can specify \"exists\" or \"updateTime\" but not both",
        );

  /// Creates a new Precondition with an exists flag.
  factory Precondition.exists(bool exists) => Precondition._(null, exists);

  /// Creates a new Precondition based on a version a document exists at.
  factory Precondition.updateTime(SnapshotVersion version) =>
      Precondition._(version, null);

  /// Returns whether this Precondition is empty
  bool get isNone => _updateTime == null && _exists == null;

  SnapshotVersion? get updateTime => _updateTime;

  bool? get exists => _exists;

  /// Returns true if the preconditions is valid for the given document (or null if no document is
  /// available).
  bool isValidFor(MutableDocument doc) {
    if (_updateTime != null) {
      return doc.isFoundDocument && doc.version == _updateTime;
    } else if (_exists != null) {
      return _exists == doc.isFoundDocument;
    } else {
      assert(isNone, "Precondition should be empty");
      return true;
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Precondition &&
          runtimeType == other.runtimeType &&
          _updateTime == other.updateTime &&
          _exists == other.exists;

  @override
  int get hashCode {
    int result = _updateTime != null ? _updateTime.hashCode : 0;
    result = 31 * result + (_exists != null ? _exists.hashCode : 0);
    return result;
  }

  @override
  String toString() {
    if (isNone) {
      return "Precondition{<none>}";
    } else if (_updateTime != null) {
      return "Precondition{updateTime= $_updateTime}";
    } else if (_exists != null) {
      return "Precondition{exists= $_exists}";
    } else {
      throw Exception("Invalid Precondition");
    }
  }
}
