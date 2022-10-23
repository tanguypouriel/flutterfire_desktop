import 'package:firebase_firestore_dart/src/model/field_path.dart';
import 'package:firebase_firestore_dart/src/model/values.dart';

import '../../generated/google/firestore/v1/document.pb.dart' as pb;
import '../model/document.dart';
import 'field_filter.dart';

class NotInFilter extends FieldFilter {

  NotInFilter(FieldPath field, pb.Value value)
      : assert(Values.isArray(value), "NotInFilter expects an ArrayValue"),
        super(field, Operator.notIn, value);

  @override
  bool matches(Document doc) {
    if (Values.contains(value.arrayValue, Values.nullValue)) {
      return false;
    }

    pb.Value? other = doc.getField(field);
    return other != null && !Values.contains(value.arrayValue, other);
  }
}
