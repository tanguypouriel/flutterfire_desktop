
import 'package:firebase_firestore_dart/src/timestamp.dart';

import '../../../generated/google/firestore/v1/document.pb.dart' as document_pb;

/// Used to represent a field transform on a mutation.
abstract class TransformOperation {

  /// Computes the local transform result against the provided previousValue, optionally using the
  /// provided localWriteTime.
  document_pb.Value applyToLocalView(document_pb.Value? previousValue, Timestamp localWriteTime);

  /// Computes a final transform result after the transform has been acknowledged by the server,
  /// potentially using the server-provided transformResult.
  document_pb.Value applyToRemoteDocument(document_pb.Value? previousValue, document_pb.Value transformResult);

  /// If applicable, returns the base value to persist for this transform. If a base value is
  /// provided, the transform operation is always applied to this base value, even if document has
  /// already been updated.
  ///
  /// <p>Base values provide consistent behavior for non-idempotent transforms and allow us to return
  /// the same latency-compensated value even if the backend has already applied the transform
  /// operation. The base value is null for idempotent transforms, as they can be re-played even if
  /// the backend has already applied them.
  ///
  /// Returns a base value to store along with the mutation, or null for idempotent transforms.
  document_pb.Value? computeBaseValue(document_pb.Value? previousValue);
}