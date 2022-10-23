
import 'package:firebase_firestore_dart/src/model/snapshot_version.dart';

import '../../../generated/google/firestore/v1/document.pb.dart' as document_pb;

/// The result of applying a mutation to the server. This is a model of the WriteResult proto
/// message.
///
/// <p>Note that MutationResult does not name which document was mutated. The association is implied
/// positionally: for each entry in the array of Mutations, there's a corresponding entry in the
/// array of MutationResults.
class MutationResult {

  final SnapshotVersion _version;
  final List<document_pb.Value> _transformResults;

  MutationResult(this._version, this._transformResults);

  /// The version at which the mutation was committed.
  ///
  /// <ul>
  ///   <li>For most operations, this is the updateTime in the WriteResult.
  ///   <li>For deletes, it is the commitTime of the WriteResponse (because deletes are not stored
  ///       and have no updateTime).
  /// </ul>
  ///
  /// <p>Note that these versions can be different: No-op writes will not change the updateTime even
  /// though the commitTime advances.
  SnapshotVersion get version => _version;

  /// The resulting fields returned from the backend after a mutation containing field transforms has
  /// been committed. Contains one Value for each FieldTransform that was in the mutation.
  ///
  /// <p>Returns an empty list if the mutation did not contain any field transforms.
  List<document_pb.Value> get transformResults => _transformResults;

}