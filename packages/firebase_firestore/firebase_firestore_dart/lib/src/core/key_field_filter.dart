
import 'package:firebase_firestore_dart/src/core/field_filter.dart';
import 'package:firebase_firestore_dart/src/model/document_key.dart';

import '../model/document.dart';

class KeyFieldFilter extends FieldFilter {

  final DocumentKey _key;

  KeyFieldFilter(super.field, super.operator, super.value) :
      _key = DocumentKey.fromName(name: value.referenceValue),
      assert(Values.isReferenceValue(value), "KeyFieldFilter expects a ReferenceValue");

  @override
  bool matches(Document doc) {
    int comparator = doc.key.compareTo(_key);
    return this.matchesComparison(comparator);
  }
}