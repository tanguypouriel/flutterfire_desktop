import 'package:firebase_firestore_dart/src/model/field_path.dart';
import 'package:firebase_firestore_dart/src/model/mutation/transform_operation.dart';

/// A field path and the operation to perform upon it.
class FieldTransform {
  final FieldPath _fieldPath;
  final TransformOperation _operation;

  FieldTransform(this._fieldPath, this._operation);

  FieldPath get fieldPath => _fieldPath;

  TransformOperation get operation => _operation;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FieldTransform &&
          other._operation == _operation &&
          other._fieldPath == _fieldPath;

  @override
  int get hashCode {
    int result = _fieldPath.hashCode;
    result = 31 * result + operation.hashCode;
    return result;
  }
}
