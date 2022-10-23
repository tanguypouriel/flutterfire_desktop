import 'package:firebase_firestore_dart/src/model/mutable_document.dart';
import 'package:firebase_firestore_dart/src/model/mutation/field_mask.dart';
import 'package:firebase_firestore_dart/src/model/mutation/mutation.dart';
import 'package:firebase_firestore_dart/src/model/mutation/mutation_result.dart';
import 'package:firebase_firestore_dart/src/timestamp.dart';

/// Represents a delete operation
class DeleteMutation extends Mutation {
  DeleteMutation(super._key, super._precondition);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeleteMutation &&
          runtimeType == other.runtimeType &&
          hasSameKeyAndPrecondition(other);

  @override
  int get hashCode => keyAndPreconditionHashCode;

  @override
  String toString() => "DeleteMutation{${keyAndPreconditionToString()}}";

  @override
  void applyToRemoteDocument(
      MutableDocument document, MutationResult mutationResult) {
    verifyKeyMatches(document);

    assert(
      mutationResult.transformResults.isEmpty,
      "Transform results received by DeleteMutation.",
    );

    // Unlike applyToLocalView, if we're applying a mutation to a remote document the server has
    // accepted the mutation so the precondition must have held.

    // We store the deleted document at the commit version of the delete. Any document version
    // that the server sends us before the delete was applied is discarded
    document
        .convertToNoDocument(mutationResult.version)
        .setHasCommittedMutations();
  }

  @override
  FieldMask? applyToLocalView(
    MutableDocument document,
    FieldMask? previousMask,
    Timestamp localWriteTime,
  ) {
    verifyKeyMatches(document);

    if (precondition.isValidFor(document)) {
      document.convertToNoDocument(document.version).setHasLocalMutations();
      return null;
    }

    return previousMask;
  }

  @override
  // TODO: implement fieldMask
  FieldMask? get fieldMask => throw UnimplementedError();
}
