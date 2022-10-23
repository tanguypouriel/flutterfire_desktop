
import 'dart:collection';

import 'package:firebase_firestore_dart/src/core/document_view_change.dart';

import '../model/document_key.dart';

/// A set of changes to documents with respect to a view. This set is mutable.
class DocumentViewChangeSet {

  final SplayTreeMap<DocumentKey, DocumentViewChange> _changes;

  DocumentViewChangeSet() :
      _changes = SplayTreeMap();

  void addChange(DocumentViewChange change) {
    DocumentKey key = change.document.key;
    DocumentViewChange? old = _changes[key];
    if (old == null) {
      _changes.putIfAbsent(key, () => change);
      return;
    }

    Type oldType = old.type;
    Type newType = change.type;

    if (newType != Type.added && oldType == Type.metadata) {
      _changes.putIfAbsent(key, () => change);
    }
    else if (newType == Type.metadata && oldType != Type.removed) {
      DocumentViewChange newChange = DocumentViewChange(oldType, change.document);
      _changes.putIfAbsent(key, () => newChange);
    }
    else if (newType == Type.modified && oldType == Type.modified) {
      DocumentViewChange newChange = DocumentViewChange(Type.modified, change.document);
      _changes.putIfAbsent(key, () => newChange);
    }
    else if (newType == Type.modified && oldType == Type.added) {
      DocumentViewChange newChange = DocumentViewChange(Type.added, change.document);
      _changes.putIfAbsent(key, () => newChange);
    }
    else if (newType == Type.removed && oldType == Type.added) {
      _changes.remove(key);
    }
    else if (newType == Type.removed && oldType == Type.modified) {
      DocumentViewChange newChange = DocumentViewChange(Type.removed, change.document);
      _changes.putIfAbsent(key, () => newChange);
    }
    else if (newType == Type.added && oldType == Type.removed) {
      DocumentViewChange newChange = DocumentViewChange(Type.modified, change.document);
      _changes.putIfAbsent(key, () => newChange);
    } else {
      // This includes these cases, which don't make sense:
      // Added -> Added
      // Removed -> Removed
      // Modified -> Added
      // Removed -> Modified
      // Metadata -> Added
      // Removed -> Metadata
      throw Exception("Unsupported combination of changes $newType after $oldType");
    }
  }

  List<DocumentViewChange> get changes => _changes.values.toList(growable: false);
}