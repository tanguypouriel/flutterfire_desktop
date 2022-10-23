import 'package:firebase_firestore_dart/src/model/document_key.dart';
import 'package:firebase_firestore_dart/src/model/mutable_document.dart';
import 'package:firebase_firestore_dart/src/model/mutation/delete_mutation.dart';
import 'package:firebase_firestore_dart/src/model/mutation/field_mask.dart';
import 'package:firebase_firestore_dart/src/model/mutation/field_transform.dart';
import 'package:firebase_firestore_dart/src/model/mutation/mutation_result.dart';
import 'package:firebase_firestore_dart/src/model/mutation/precondition.dart';
import 'package:firebase_firestore_dart/src/model/mutation/set_mutation.dart';

import '../../timestamp.dart';

/// Represents a Mutation of a document. Different subclasses of Mutation will perform different
/// kinds of changes to a base document. For example, a SetMutation replaces the value of a document
/// and a DeleteMutation deletes a document.
///
/// <p>In addition to the value of the document mutations also operate on the version. For local
/// mutations (mutations that haven't been committed yet), we preserve the existing version for Set
/// and Patch mutations. For local deletes, we reset the version to 0.
///
/// <p>Here's the expected transition table.
///
/// <table>
/// <th><td>MUTATION</td><td>APPLIED TO</td><td>RESULTS IN</td></th>
/// <tr><td>SetMutation</td><td>Document(v3)</td><td>Document(v3)</td></tr>
/// <tr><td>SetMutation</td><td>NoDocument(v3)</td><td>Document(v0)</td></tr>
/// <tr><td>SetMutation</td><td>null</td><td>Document(v0)</td></tr>
/// <tr><td>PatchMutation</td><td>Document(v3)</td><td>Document(v3)</td></tr>
/// <tr><td>PatchMutation</td><td>NoDocument(v3)</td><td>NoDocument(v3)</td></tr>
/// <tr><td>PatchMutation</td><td>null</td><td>null</td></tr>
/// <tr><td>DeleteMutation</td><td>Document(v3)</td><td>NoDocument(v0)</td></tr>
/// <tr><td>DeleteMutation</td><td>NoDocument(v3)</td><td>NoDocument(v0)</td></tr>
/// <tr><td>DeleteMutation</td><td>null</td><td>NoDocument(v0)</td></tr>
/// </table>
///
/// For acknowledged mutations, we use the updateTime of the WriteResponse as the resulting version
/// for Set and Patch mutations. As deletes have no explicit update time, we use the commitTime of
/// the WriteResponse for acknowledged deletes.
///
/// <p>If a mutation is acknowledged by the backend but fails the precondition check locally, we
/// return an `UnknownDocument` and rely on Watch to send us the updated version.
///
/// <p>Field transforms are used only with Patch and Set Mutations. We use the `updateTransforms`
/// field to store transforms, rather than the `transforms` message.
abstract class Mutation {
  final DocumentKey _key;

  /// The precondition for the mutation.
  final Precondition _precondition;

  late final List<FieldTransform> _fieldTransforms;

  Mutation(
    this._key,
    this._precondition, [
    List<FieldTransform>? fieldTransforms,
  ]) : _fieldTransforms = fieldTransforms ?? [];

  /// A utility method to calculate an [Mutation] representing the overlay from the final state
  /// of the document, and a [FieldMask] representing the fields that are mutated by the local
  /// mutations.
  static Mutation? calculateOverlayMutation(
      MutableDocument doc, FieldMask? mask) {
    if ((!doc.hasLocalMutations) || (mask != null && mask.mask.isEmpty)) {
      return null;
    }
    // mask == null when there are Set or Delete being applied to get to the current document.
    if (mask == null) {
      if (doc.isNoDocument) {
        return DeleteMutation(doc.key, Precondition.none);
      } else {
        return SetMutation(doc.key, doc.getData(), Precondition.none);
      }
      // TODO
    }
  }

  DocumentKey get key => _key;

  Precondition get precondition => _precondition;

  List<FieldTransform> get fieldTransforms => _fieldTransforms;

  /// Helper for derived classes to implement operator ==().
  bool hasSameKeyAndPrecondition(Mutation other) =>
      _key == other._key && _precondition == other._precondition;

  /// Helper for derived classes to implement .hashCode().
  int get keyAndPreconditionHashCode =>
      _key.hashCode * 31 + _precondition.hashCode;

  String keyAndPreconditionToString() => "key= $_key, precondition= $_precondition";

  void verifyKeyMatches(MutableDocument document) {
    assert(document.key == _key,
        "Can only apply a mutation to a document with the same key");
  }

  /// Applies this mutation to the given Document for the purposes of computing a new remote document
  /// If the input document doesn't match the expected state (e.g. it is invalid or outdated), the
  /// document state may transition to unknown.
  ///
  /// [document] The document to mutate.
  /// [mutationResult] The result of applying the mutation from the backend.
  void applyToRemoteDocument(
      MutableDocument document, MutationResult mutationResult);

  /// Applies this mutation to the given Document for the purposes of computing the new local view of
  /// a document. If the input document doesn't match the expected state, the document is not
  /// modified.
  ///
  /// [document] The document to mutate.
  /// [previousMask] The fields that have been updated before applying this mutation.
  /// [localWriteTime] A timestamp indicating the local write time of the batch this mutation is
  ///     a part of.
  /// Returns a [FieldMask] representing the fields that are changed by applying this mutation.
  FieldMask? applyToLocalView(MutableDocument document, FieldMask? previousMask,
      Timestamp localWriteTime);

  /// Returns a [FieldMask] representing the fields that will be changed by applying this
  /// mutation. Returns [null] if the mutation will overwrite the entire document.
  FieldMask? get fieldMask;
}
