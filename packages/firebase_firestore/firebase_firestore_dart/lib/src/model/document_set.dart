
import 'dart:collection';

import 'package:firebase_firestore_dart/src/model/document_key.dart';

import 'document.dart';

/// An immutable set of documents (unique by key) ordered by the given comparator or ordered by key
/// by default if no document is present.
class DocumentSet implements Iterable<Document> {

  /// An index of the documents in the DocumentSet, indexed by document key. The index exists to
  /// guarantee the uniqueness of document keys in the set and to allow lookup and removal of
  /// documents by key.
  final SplayTreeMap<DocumentKey, Document> _keyIndex;

  /// The main collection of documents in the DocumentSet. The documents are ordered by the provided
  /// comparator. The collection exists in addition to the index to allow ordered traversal of the
  /// DocumentSet.
  final SplayTreeSet<Document> _sortedSet;

  DocumentSet._(this._keyIndex, this._sortedSet);


  int get size => _keyIndex.length;

  @override
  bool get isEmpty => _keyIndex.isEmpty;

  /// Returns true iff this set contains a document with the given key.
  bool containsKey(DocumentKey key) => _keyIndex.containsKey(key);

  /// Returns the document from this set with the given key if it exists or null if it doesn't.
  Document? getDocument(DocumentKey key) => _keyIndex[key];

  /// Returns the first document in the set according to the set's ordering, or null if the set is
  /// empty.
  Document? get firstDocument => _sortedSet.isEmpty ? null : _sortedSet.first;

  /// Returns the last document in the set according to the set's ordering, or null if the set is
  /// empty.
  Document? get lastDocument => _sortedSet.isEmpty ? null : _sortedSet.last;

  /// Returns the document previous to the document associated with the given key in the set
  /// according to the set's ordering. Returns null if the document associated with the given key is
  /// the first document.
  ///
  /// [key] - A key that must be present in the set
  /// Throws Exception if the set does not contain the key
  Document? getPredecessor(DocumentKey key) {
    Document? document = _keyIndex[key];
    if (document == null) throw Exception("Key not contained in DocumentSet: $key");

    // TODO validate
    return _sortedSet.toList()[_sortedSet.toList(growable: false).indexOf(document) - 1];
  }

  /// Returns the index of the provided key in the document set, or -1 if the document key is not
  /// present in the set;
  int indexOf(DocumentKey key) {
    Document? document = _keyIndex[key];
    if (document == null) return -1;
    return _sortedSet.toList(growable: false).indexOf(document);
  }

  /// Returns a new DocumentSet that contains the given document, replacing any old document with the
  /// same key.
  DocumentSet add(Document document) {
    // Remove any prior mapping of the document's key before adding, preventing sortedSet from
    // accumulating values that aren't in the index.
    DocumentSet removed = remove(document.key);

    SplayTreeMap<DocumentKey, Document> newKeyIndex = SplayTreeMap.of({...removed._keyIndex, document.key : document});
    SplayTreeSet<Document> newSortedSet = SplayTreeSet.of([...removed._sortedSet, document]);

    return DocumentSet._(newKeyIndex, newSortedSet);
  }

  /// Returns a new DocumentSet with the document for the provided key removed.
  DocumentSet remove(DocumentKey key) {
    Document? document = _keyIndex[key];
    if (document == null) return this;

    SplayTreeMap<DocumentKey, Document> newKeyIndex = SplayTreeMap.of(_keyIndex..remove(key));
    SplayTreeSet<Document> newSortedSet = SplayTreeSet.of(_sortedSet..remove(document));
    return DocumentSet._(newKeyIndex, newSortedSet);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other is! DocumentSet) return false;

    return _sortedSet.toList(growable: false) == other.toList();
  }

  @override
  int get hashCode {
    int result = 0;
    for (Document document in this) {
      result = 31 * result + document.key.hashCode;
      result = 31 * result + document.getData().hashCode;
    }

    return result;
  }

  @override
  String toString() => toList().toString();

  // TODO validate this part

  @override
  List<Document> toList({bool growable = false}) => _sortedSet.toList(growable: growable);

  @override
  bool any(bool Function(Document element) test) => _sortedSet.any(test);

  @override
  Iterable<R> cast<R>() => _sortedSet.cast<R>();

  @override
  bool contains(Object? element) => _sortedSet.contains(element);

  @override
  Document elementAt(int index) => _sortedSet.elementAt(index);

  @override
  bool every(bool Function(Document element) test) => _sortedSet.every(test);

  @override
  Iterable<T> expand<T>(Iterable<T> Function(Document element) toElements) =>
      _sortedSet.expand(toElements);

  @override
  Document get first => _sortedSet.first;

  @override
  Document firstWhere(bool Function(Document element) test, {Document Function()? orElse}) =>
      _sortedSet.firstWhere(test, orElse: orElse);

  @override
  T fold<T>(T initialValue, T Function(T previousValue, Document element) combine) =>
      _sortedSet.fold(initialValue, combine);

  @override
  Iterable<Document> followedBy(Iterable<Document> other) =>
      _sortedSet.followedBy(other);

  @override
  void forEach(void Function(Document element) action) =>
      _sortedSet.forEach(action);

  @override
  bool get isNotEmpty => _sortedSet.isNotEmpty;

  @override
  Iterator<Document> get iterator => _sortedSet.iterator;

  @override
  String join([String separator = ""]) =>
      _sortedSet.join(separator);

  @override
  Document get last => _sortedSet.last;

  @override
  Document lastWhere(bool Function(Document element) test, {Document Function()? orElse}) =>
      _sortedSet.lastWhere(test, orElse: orElse);

  @override
  int get length => _sortedSet.length;

  @override
  Iterable<T> map<T>(T Function(Document e) toElement) =>
      _sortedSet.map(toElement);

  @override
  Document reduce(Document Function(Document value, Document element) combine) =>
      _sortedSet.reduce(combine);

  @override
  Document get single => _sortedSet.single;

  @override
  Document singleWhere(bool Function(Document element) test, {Document Function()? orElse}) =>
      _sortedSet.singleWhere(test, orElse: orElse);

  @override
  Iterable<Document> skip(int count) => _sortedSet.skip(count);

  @override
  Iterable<Document> skipWhile(bool Function(Document value) test) =>
      _sortedSet.skipWhile(test);

  @override
  Iterable<Document> take(int count) => _sortedSet.take(count);

  @override
  Iterable<Document> takeWhile(bool Function(Document value) test) =>
      _sortedSet.takeWhile(test);

  @override
  Set<Document> toSet() => _sortedSet;

  @override
  Iterable<Document> where(bool Function(Document element) test) =>
      _sortedSet.where(test);

  @override
  Iterable<T> whereType<T>() => _sortedSet.whereType<T>();

}
