
import 'package:firebase_firestore_dart/generated/google/firestore/v1/document.pb.dart' as pb;
import 'package:firebase_firestore_dart/src/model/document.dart';

import 'package:firebase_firestore_dart/src/model/field_path.dart';

import 'filter.dart';
import 'in_filter.dart';
import 'key_field_filter.dart';
import 'key_field_in_filter.dart';
import 'not_in_filter.dart';

class FieldFilter extends Filter {

  final Operator _operator;

  final pb.Value _value;

  final FieldPath _field;

  /// Creates a new filter that compares fields and values. Only intended to be called from
  /// Filter.create().
   FieldFilter(this._field, this._operator, this._value);

   Operator get operator => _operator;

   FieldPath get field => _field;

   pb.Value get value => _value;

  /// Gets a Filter instance for the provided path, operator, and value.
  ///
  /// <p>Note that if the relation operator is EQUAL and the value is null or NaN, this will return
  /// the appropriate NullFilter or NaNFilter class instead of a FieldFilter.
  factory FieldFilter.create(FieldPath path, Operator operator, pb.Value value) {
    if (path.isKeyField) {
     if (operator == Operator.IN) {
       return KeyFieldInFilter(path, value);
     } else if (operator == Operator.notIn) {
       return KeyFieldNotInFilter(path, value);
     } else {
       assert(operator != Operator.arrayContains && operator != Operator.arrayContainsAny,
       "$operator queries don't make sense on document keys",
       );
       return KeyFieldFilter(path, operator, value);
     }
    } else if (operator == Operator.arrayContains) {
      return ArrayContainsFilter(path, value);
    } else if (operator == Operator.IN) {
      return InFilter(path, value);
    } else if (operator == Operator.arrayContainsAny) {
      return ArrayContainsAnyFilter(path, value);
    } else if (operator == Operator.notIn) {
      return NotInFilter(path, value);
    } else {
      return FieldFilter(path, operator, value);
    }

  }

  @override
  String getCanonicalId() {
    // TODO: implement getCanonicalId
    throw UnimplementedError();
  }

  @override
  List<Filter> getFilters() {
    // TODO: implement getFilters
    throw UnimplementedError();
  }

  @override
  FieldPath? getFirstInequalityField() {
    // TODO: implement getFirstInequalityField
    throw UnimplementedError();
  }

  @override
  List<FieldFilter> getFlattenedFilters() {
    // TODO: implement getFlattenedFilters
    throw UnimplementedError();
  }

  @override
  bool matches(Document doc) {
    // TODO: implement matches
    throw UnimplementedError();
  }

}

enum Operator {
  lessThan(text: "<"),
  lessThanOrEqual(text: "<="),
  equal(text: "=="),
  notEqual(text: "!="),
  greaterThan(text: ">"),
  greaterThanOrEqual(text: ">="),
  arrayContains(text: 'array_contains'),
  arrayContainsAny(text: "array_contains_any"),
  IN(text: "in"),
  notIn(text: "not_in");

  final String text;

  const Operator({required this.text});

  @override
  String toString() => text;
}