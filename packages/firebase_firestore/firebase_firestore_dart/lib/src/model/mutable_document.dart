import 'package:firebase_firestore_dart/generated/google/firestore/v1/document.pb.dart'
    as document_pb;
import 'package:firebase_firestore_dart/src/model/document.dart';
import 'package:firebase_firestore_dart/src/model/document_key.dart';
import 'package:firebase_firestore_dart/src/model/field_path.dart';
import 'package:firebase_firestore_dart/src/model/object_value.dart';
import 'package:firebase_firestore_dart/src/model/snapshot_version.dart';

/// Represents a document in Firestore with a key, version, data and whether it has local mutations
/// applied to it.
///
/// <p>Documents can transition between states via [convertToFoundDocument],
/// [convertToNoDocument] and [convertToUnknownDocument]. If a document does not transition to
/// one of these states even after all mutations have been applied, [isValidDocument] returns
/// false and the document should be removed from all views.
class MutableDocument implements Document {
  final DocumentKey _key;
  _DocumentType _documentType;
  SnapshotVersion _version;
  SnapshotVersion _readTime;
  ObjectValue _value;
  _DocumentState _documentState;

  MutableDocument._(this._key, this._documentType, this._version, this._value,
      this._documentState,
      [SnapshotVersion? readTime])
      : _readTime = readTime ?? SnapshotVersion.none;

  /// Creates a document with no known version or data, but which can serve as base document for
  /// mutations.
  factory MutableDocument.newInvalidDocument(DocumentKey documentKey) =>
      MutableDocument._(
        documentKey,
        _DocumentType.invalid,
        SnapshotVersion.none,
        ObjectValue(),
        _DocumentState.synced,
      );

  /// Creates a new document that is known to exist with the given data at the given version.
  factory MutableDocument.newFoundDocument(DocumentKey documentKey,
          SnapshotVersion version, ObjectValue value) =>
      MutableDocument._(
        documentKey,
        _DocumentType.foundDocument,
        version,
        value,
        _DocumentState.synced,
      );

  /// Creates a new document that is known to not exist at the given version.
  factory MutableDocument.newNoDocument(
          DocumentKey documentKey, SnapshotVersion version) =>
      MutableDocument._(
        documentKey,
        _DocumentType.noDocument,
        version,
        ObjectValue(),
        _DocumentState.synced,
      );

  /// Creates a new document that is known to exist at the given version but whose data is not known
  /// (e.g. a document that was updated without a known base document).
  factory MutableDocument.newUnknownDocument(
          DocumentKey documentKey, SnapshotVersion version) =>
      MutableDocument._(
        documentKey,
        _DocumentType.unknownDocument,
        version,
        ObjectValue(),
        _DocumentState.hasCommittedMutations,
      );

  /// Changes the document type to indicate that it exists and that its version and data are known.
  MutableDocument convertToFoundDocument(
      SnapshotVersion version, ObjectValue value) {
    _version = version;
    _documentType = _DocumentType.foundDocument;
    _value = value;
    _documentState = _DocumentState.synced;
    return this;
  }

  /// Changes the document type to indicate that it doesn't exist at the given version. */
  MutableDocument convertToNoDocument(SnapshotVersion version) {
    _version = version;
    _documentType = _DocumentType.noDocument;
    _value = ObjectValue();
    _documentState = _DocumentState.synced;
    return this;
  }

  /// Changes the document type to indicate that it exists at a given version but that its data is
  /// not known (e.g. a document that was updated without a known base document).
  MutableDocument convertToUnknownDocument(SnapshotVersion version) {
    _version = version;
    _documentType = _DocumentType.unknownDocument;
    _value = ObjectValue();
    _documentState = _DocumentState.hasCommittedMutations;
    return this;
  }

  MutableDocument setHasCommittedMutations() =>
      this.._documentState = _DocumentState.hasCommittedMutations;

  MutableDocument setHasLocalMutations() => this
    .._documentState = _DocumentState.hasLocalMutations
    .._version = SnapshotVersion.none;

  MutableDocument setReadTime(SnapshotVersion readTime) =>
      this.._readTime = readTime;

  @override
  ObjectValue get data => _value;

  @override
  document_pb.Value? getField(FieldPath path) => _value.get(path);

  @override
  bool get hasCommittedMutations =>
      _documentState == _DocumentState.hasCommittedMutations;

  @override
  bool get hasLocalMutations =>
      _documentState == _DocumentState.hasLocalMutations;

  @override
  bool hasPendingWrites() => hasCommittedMutations || hasLocalMutations;

  @override
  bool get isFoundDocument => _documentType == _DocumentType.foundDocument;

  @override
  bool get isNoDocument => _documentType == _DocumentType.noDocument;

  @override
  bool get isUnknownDocument => _documentType == _DocumentType.unknownDocument;

  @override
  bool get isValidDocument => _documentType != _DocumentType.invalid;

  @override
  DocumentKey get key => _key;

  @override
  SnapshotVersion get readTime => _readTime;

  @override
  SnapshotVersion get version => _version;

  @override
  MutableDocument mutableCopy() => MutableDocument._(
        _key,
        _documentType,
        _version,
        _value.clone(),
        _documentState,
        _readTime,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! MutableDocument) return false;

    if (_key != other.key) return false;
    if (_version != other.version) return false;
    if (_documentType != other._documentType) return false;
    if (_documentState != other._documentState) return false;
    return _value == other._value;
  }

  // We only use the key for the hashcode as all other document properties are mutable.
  // While mutable documents should not be uses as keys in collections, the hash code is used
  // in DocumentSet, which tracks Documents that are no longer being mutated but which are
  // backed by this class.
  @override
  int get hashCode => _key.hashCode;

  @override
  String toString() => "Document{key= $_key,"
      " version= $_version,"
      " readTime= $_readTime,"
      " type= $_documentType,"
      " documentState= $_documentState,"
      " value= $_value}";
}

enum _DocumentType {
  /// Represents the initial state of a MutableDocument when only the document key is known.
  /// Invalid documents transition to other states as mutations are applied. If a document remains
  /// invalid after applying mutations, it should be discarded.
  invalid,

  /// Represents a document in Firestore with a key, version, data and whether the data has local
  /// mutations applied to it.
  foundDocument,

  /// Represents that no documents exists for the key at the given version.
  noDocument,

  /// Represents an existing document whose data is unknown (e.g. a document that was updated
  /// without a known base document).
  unknownDocument,
}

/// Describes the `hasPendingWrites` state of a document.
enum _DocumentState {
  /// Local mutations applied via the mutation queue. Document is potentially inconsistent.
  hasLocalMutations,

  /// Mutations applied based on a write acknowledgment. Document is potentially inconsistent.
  hasCommittedMutations,

  /// No mutations applied. Document was sent to us by Watch.
  synced
}
