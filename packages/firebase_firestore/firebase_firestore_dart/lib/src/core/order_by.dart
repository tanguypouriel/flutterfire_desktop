import 'package:firebase_firestore_dart/src/model/document.dart';
import 'package:firebase_firestore_dart/src/model/field_path.dart';
import 'package:firebase_firestore_dart/src/model/values.dart';

import '../../generated/google/firestore/v1/document.pb.dart' as pb;

/// Represents a sort order for a Firestore Query */
class OrderBy {
  final Direction _direction;

  Direction get direction => _direction;

  final FieldPath field;

  factory OrderBy.getInstance({
    required Direction direction,
    required FieldPath path,
  }) =>
      OrderBy._(direction, path);

  OrderBy._(this._direction, this.field);

  int compare(Document d1, Document d2) {
    if (field == FieldPath.keyPath) {
      return direction.comparisonModifier * d1.key.compareTo(d2.key);
    } else {
      pb.Value? v1 = d1.getField(field);
      pb.Value? v2 = d2.getField(field);

      assert(
        v1 != null && v2 != null,
        "Trying to compare documents on fields that don't exists.",
      );

      return direction.comparisonModifier * Values.compare(v1, v2);
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderBy &&
          runtimeType == other.runtimeType &&
          direction == other.direction &&
          field == other.field;

  @override
  int get hashCode {
    int result = 29;
    result = 31 * result + direction.hashCode;
    result = 31 * result + field.hashCode;
    return result;
  }

  @override
  String toString() =>
      "${direction == Direction.ascending ? "" : "-"} ${field.canonicalString()}";
}

/// The direction of the ordering
enum Direction {
  ascending(comparisonModifier: 1),
  descending(comparisonModifier: -1);

  final int comparisonModifier;

  const Direction({required this.comparisonModifier});
}
