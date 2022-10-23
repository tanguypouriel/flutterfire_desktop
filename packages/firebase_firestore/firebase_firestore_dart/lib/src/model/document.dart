import '../../generated/google/firestore/v1/document.pb.dart' as pb;
import 'document_key.dart';
import 'field_path.dart';
import 'snapshot_version.dart';

/// Represents a document in Firestore with a key, version, data and whether the data has local
/// mutations applied to it.
abstract class Document {
  // TODO KEY_COMPARATOR

  /// The key for this document
  DocumentKey get key;

  /// Returns the version of this document if it exists or a version at which this document was
  /// guaranteed to not exist.
  SnapshotVersion get version;

  /// Returns the timestamp at which this document was read from the remote server. Returns
  /// `SnapshotVersion.NONE` for documents created by the user.
  SnapshotVersion get readTime;

  /// Returns whether this document is valid (i.e. it is an entry in the RemoteDocumentCache, was
  /// created by a mutation or read from the backend).
  bool get isValidDocument;

  /// Returns whether the document exists and its data is known at the current version. */
  bool get isFoundDocument;

  /// Returns whether the document is known to not exist at the current version. */
  bool get isNoDocument;

  /// Returns whether the document exists and its data is unknown at the current version. */
  bool get isUnknownDocument;

  /// Returns the underlying data of this document. Returns an empty value if no data exists. */
  Map<String, Object> getData();

  /// Returns the data of the given path. Returns null if no data exists. */
  pb.Value? getField(FieldPath path);

  /// Returns whether local mutations were applied via the mutation queue. */
  bool get hasLocalMutations;

  /// Returns whether mutations were applied based on a write acknowledgment. */
  bool get hasCommittedMutations;

  /// Whether this document has a local mutation applied that has not yet been acknowledged by Watch.
  bool hasPendingWrites();

  /// Creates a mutable copy of this document. */
  MutableDocument mutableCopy();
}
