import 'package:firebase_firestore_dart/src/model/field_path.dart';

/// Provides a set of fields that can be used to partially patch a document. The FieldMask is used in
/// conjunction with ObjectValue.
///
/// <p>Examples: foo - Overwrites foo entirely with the provided value. If foo is not present in the
/// companion ObjectValue, the field is deleted. foo.bar - Overwrites only the field bar of the
/// object foo. If foo is not an object, foo is replaced with an object containing foo.
class FieldMask {
  static FieldMask empty = fromSet({});

  static FieldMask fromSet(Set<FieldPath> mask) => FieldMask._(mask);

  final Set<FieldPath> _mask;

  FieldMask._(this._mask);

  /// Verifies that 'fieldPath' is included by at least one field in this field mask.
  ///
  /// <p>This is an O(n) operation, where 'n' is the size of the field mask.
  bool covers(FieldPath fieldPath) =>
      _mask.any((fieldMaskPath) => fieldMaskPath.isPrefixOf(fieldPath));

  Set<FieldPath> get mask => _mask;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FieldMask &&
          runtimeType ==
          other.runtimeType &&
          _mask == other.mask;

  @override
  int get hashCode => _mask.hashCode;

  @override
  String toString() => "FieldMask{mask= $_mask}";

}
