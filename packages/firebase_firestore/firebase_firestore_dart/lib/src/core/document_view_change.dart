
import '../model/document.dart';

/// A change to a single document's state within a view.
class DocumentViewChange {

  final Type _type;

  final Document _document;

  DocumentViewChange(this._type, this._document);

  Document get document => _document;

  Type get type => _type;
}

/// The types of changes that can happen to a document with respect to a view. NOTE: We sort
/// document changes by their type, so the ordering of this enum is significant.
enum Type {
  removed,
  added,
  modified,
  metadata
}