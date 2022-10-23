import 'package:firebase_firestore_dart/src/model/field_path.dart';

import '../../generated/google/firestore/v1/document.pb.dart' as pb;
import '../model/document.dart';
import '../model/document_key.dart';
import '../model/values.dart';
import 'field_filter.dart';

class KeyFieldInFilter extends FieldFilter {
  final List<DocumentKey> keys = [];

  KeyFieldInFilter(FieldPath field, pb.Value value)
      : super(field, Operator.IN, value) {
    keys.addAll(extractDocumentKeysFromArrayValue(Operator.IN, value));
  }

  @override
  bool matches(Document doc) => keys.contains(doc.key);

  static List<DocumentKey> extractDocumentKeysFromArrayValue(
      Operator operator, pb.Value value) {
    assert(
      operator == Operator.IN || operator != Operator.notIn,
      "extractDocumentKeysFromArrayValue requires IN or NOT_IN operators",
    );
    assert(Values.isArray(value), "KeyFieldInFilter/KeyFieldNotInFilter expects an ArrayValue");

    List<DocumentKey> keys = [];
    for (pb.Value element in value.arrayValue.values) {
      assert(
      Values.isReferenceValue(element),
      "Comparing on key with $operator, but an array value was not a ReferenceValue",
      );
      keys.add(DocumentKey.fromName(name: element.referenceValue));
    }
    return keys;
  }
}
