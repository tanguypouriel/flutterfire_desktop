import 'package:firebase_firestore_dart/src/model/resource_path.dart';

/// DocumentKey represents the location of a document in the Firestore database.
class DocumentKey implements Comparable<DocumentKey> {
  static const String keyFieldName = '__name__';

  /// The path to the document
  final ResourcePath _path;

  // TODO comparator ?

  /// Returns a document key for the empty path.
  factory DocumentKey.empty() => DocumentKey.fromSegments([]);

  /// Returns a DocumentKey from a fully qualified resource name.
  factory DocumentKey.fromName({required String name}) {
    ResourcePath resourceName = ResourcePath.fromString(name);
    assert(
      resourceName.length > 4 &&
          resourceName.getSegment(0) == "projects" &&
          resourceName.getSegment(2) == "databases" &&
          resourceName.getSegment(4) == "documents",
      "Tried to parse an invalid key: $resourceName",
    );
    return DocumentKey.fromPath(resourceName.popFirst(5));
  }

  /// Creates and returns a new document key with the given path.
  ///
  /// [path] - The path to the document
  /// Returns a new instance of [DocumentKey]
  factory DocumentKey.fromPath(ResourcePath path) => DocumentKey._(path);

  /// Creates and returns a new document key with the given segments.
  ///
  /// [segments] - The segments of the path to the document
  /// Returns a new instance of [DocumentKey]
  factory DocumentKey.fromSegments(List<String> segments) =>
      DocumentKey._(ResourcePath.fromSegments(segments));

  /// Creates and returns a new document key using '/' to split the string into segments.
  ///
  /// [path] - The slash-separated path string to the document
  /// Returns a new instance of [DocumentKey]
  factory DocumentKey.fromPathString(String path) =>
      DocumentKey._(ResourcePath.fromString(path));

  /// Returns true if the given path is a path to a document.
  static bool isDocumentKey(ResourcePath path) => path.length.isEven;

  DocumentKey._(this._path)
      : assert(isDocumentKey(_path), "Not a document key path: $_path");

  /// Returns the path to the document
  ResourcePath get path => _path;

  /// Returns the collection group (i.e. the name of the parent collection) for this key.
  String getCollectionGroup() => _path.getSegment(path.length - 2);

  /// Returns the fully qualified path to the parent collection.
  ResourcePath getCollectionPath() => _path.popLast();

  /// Returns the ID for this document key (i.e. the last path segment).
  String get documentId => _path.lastSegment;

  /// Returns true if the document is in the specified collectionId.
  bool hasCollectionId(String collectionId) =>
      _path.length >= 2 && _path.segments[_path.length - 2] == collectionId;

  @override
  int compareTo(DocumentKey other) => path.compareTo(other.path);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DocumentKey &&
          runtimeType == other.runtimeType &&
          _path == other.path;

  @override
  int get hashCode => _path.hashCode;

  @override
  String toString() => _path.toString();
}
