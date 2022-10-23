
import 'package:firebase_firestore_dart/src/model/mutation/mutation.dart';
import 'package:firebase_firestore_dart/src/model/object_value.dart';

/// A mutation that creates or replaces the document at the given key with the object value contents.
class SetMutation extends Mutation {

  final ObjectValue _value;


  SetMutation(super._key, this._value, super._precondition, []);


}