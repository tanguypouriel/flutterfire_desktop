import 'package:firebase_firestore_dart/generated/google/protobuf/struct.pb.dart';

import '../../generated/google/firestore/v1/document.pb.dart' as document_pb;

class Values {
  static final document_pb.Value nanValue = document_pb.Value.create()
    ..doubleValue = double.nan;
  static final document_pb.Value nullValue = document_pb.Value.create()
    ..nullValue = NullValue.NULL_VALUE;

  static final document_pb.Value minValue = nullValue;
  static final document_pb.Value _maxValueType = document_pb.Value.create()
    ..stringValue = "__max__";
  static final document_pb.Value maxValue = document_pb.Value.create()
    ..mapValue = document_pb.MapValue(fields: {"__type__": _maxValueType});

  /// The order of types in Firestore. This order is based on the backend's ordering, but modified to
  /// support server timestamps and [maxValue].
  static final int typeOrderNull = 0;

  static final int typeOrderBoolean = 1;
  static final int typeOrderNumber = 2;
  static final int typeOrderTimestamp = 3;
  static final int typeOrderServerTimestamp = 4;
  static final int typeOrderString = 5;
  static final int typeOrderBlob = 6;
  static final int typeOrderReference = 7;
  static final int typeOrderGeoPoint = 8;
  static final int typeOrderArray = 9;
  static final int typeOrderMap = 10;

  static final int typeOrderMaxValue = double.maxFinite.toInt();

  /// Returns the backend's type order of the given Value type.
  static int typeOrder(document_pb.Value value) {
    switch (value.whichValueType()) {
      case document_pb.Value_ValueType.nullValue:
        return typeOrderNull;
      case document_pb.Value_ValueType.booleanValue:
        return typeOrderBoolean;
      case document_pb.Value_ValueType.integerValue:
        return typeOrderNumber;
      case document_pb.Value_ValueType.doubleValue:
        return typeOrderNumber;
      case document_pb.Value_ValueType.referenceValue:
        return typeOrderReference;
      case document_pb.Value_ValueType.mapValue:
        if (isServerTimestamp(value)) {
          return typeOrderServerTimestamp;
        } else if (isMaxValue(value)) {
          return typeOrderMaxValue;
        } else {
          return typeOrderMap;
        }
      case document_pb.Value_ValueType.geoPointValue:
        return typeOrderGeoPoint;
      case document_pb.Value_ValueType.arrayValue:
        return typeOrderArray;
      case document_pb.Value_ValueType.timestampValue:
        return typeOrderTimestamp;
      case document_pb.Value_ValueType.stringValue:
        return typeOrderString;
      case document_pb.Value_ValueType.bytesValue:
        return typeOrderBlob;
      default:
        throw Exception("Invalid value type: $value");
    }
  }

  // TODO

  /// Returns true if the Value list contains the specified element. */
  static bool contains(
          document_pb.ArrayValue haystack, document_pb.Value needle) =>
      haystack.values.contains(needle);

  /// Return true if [value] is an integerValue
  static bool isInteger(document_pb.Value? value) =>
    value != null && value.whichValueType() == document_pb.Value_ValueType.integerValue;

  /// Return true if [value] is an doubleValue
  static bool isDouble(document_pb.Value? value) =>
    value != null && value.whichValueType() == document_pb.Value_ValueType.doubleValue;

  /// Returns true if [value] is either an integerValue or a doubleValue
  static bool isNumber (document_pb.Value? value) =>
    Values.isInteger(value) || Values.isDouble(value);

  /// Returns true if [value] is an arrayValue.
  static bool isArray(document_pb.Value? value) =>
      value != null &&
      value.whichValueType() == document_pb.Value_ValueType.arrayValue;

  static bool isReferenceValue(document_pb.Value? value) =>
      value != null && value.whichValueType() == document_pb.Value_ValueType.referenceValue;

  static bool isNullValue(document_pb.Value? value) =>
      value != null && value.whichValueType() == document_pb.Value_ValueType.nullValue;

  static bool isNanValue(document_pb.Value? value) =>
      value != null && double.nan == value.doubleValue;

  static bool isMapValue(document_pb.Value? value) =>
      value != null && value.whichValueType() == document_pb.Value_ValueType.mapValue;

  static bool isMaxValue(document_pb.Value value) =>
      _maxValueType == value.mapValue.fields["__type__"];
}
