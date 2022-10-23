
import 'package:firebase_firestore_dart/src/model/database_id.dart';

class RemoteSerializer {

  final DatabaseId _databaseId;
  final String _databaseName;

  RemoteSerializer(this._databaseId) :
      _databaseName = encodeDatabaseId(_databaseId).canonicalString();

}