import '../../generated/google/firestore/v1/document.pb.dart' as pb;
import '../model/document.dart';
import '../model/field_path.dart';
import '../model/values.dart';
import 'field_filter.dart';

/// A Filter that implements the IN operator.
class InFilter extends FieldFilter {
  InFilter(FieldPath field, pb.Value value) : super(field, Operator.IN, value) {
    assert(Values.isArray(value), "InFilter expects an ArrayValue");
  }

  @override
  bool matches(Document doc) {
    pb.Value? other = doc.getField(field);

    return other != null && Values.contains(value.arrayValue, other);
  }
}
