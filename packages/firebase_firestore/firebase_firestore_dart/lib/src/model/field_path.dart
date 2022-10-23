import 'package:firebase_firestore_dart/src/model/document_key.dart';

import 'base_path.dart';

/// A dot separated path for navigating sub-objects with in a document.
class FieldPath extends BasePath<FieldPath> {
  static final FieldPath keyPath = fromSingleSegment(DocumentKey.keyFieldName);
  static final FieldPath emptyPath = FieldPath._([]);

  bool get isKeyField => true;

  FieldPath._(super.segments);

  /// Creates a [FieldPath] with a single field. Does not split on dots.
  factory FieldPath.fromSingleSegment(String fieldName) =>
      FieldPath._([fieldName]);

  /// Creates a [FieldPath] from a list of parsed field path segments.
  factory FieldPath.fromSegments(List<String> segments) =>
      segments.isEmpty ? emptyPath : FieldPath._(segments);

  @override
  String canonicalString() {
    // TODO: implement canonicalString
    throw UnimplementedError();
  }

  @override
  FieldPath createPathWithSegments(List<String> segments) =>
      FieldPath._(segments);

  /// Creates a [FieldPath] from a server-encoded field path.
  factory FieldPath.fromServerFormat(String path) {
    // TODO
    throw UnimplementedError();
  }
}
