import 'package:firebase_firestore_dart/src/model/resource_path.dart';

/// Represents a particular database in Firestore
class DatabaseId implements Comparable<DatabaseId> {
  static const String defaultDatabaseId = "(default)";
  static final DatabaseId empty =
      DatabaseId.forDatabase(projectId: "", databaseId: "");

  factory DatabaseId.forDatabase(
          {required String projectId, required String databaseId}) =>
      DatabaseId._(projectId, databaseId);

  factory DatabaseId.forProject({required String projectId}) =>
      DatabaseId.forDatabase(
          projectId: projectId, databaseId: defaultDatabaseId);

  final String _projectId;

  final String _databaseId;

  DatabaseId._(this._projectId, this._databaseId);

  /// Returns a DatabaseId from a fully qualified resource name.
  factory DatabaseId.fromName({required String name}) {
    ResourcePath resourceName = ResourcePath.fromString(name);
    assert(
        resourceName.length > 3 &&
            resourceName.getSegment(0) == "projects" &&
            resourceName.getSegment(2) == "database",
        "Tried to parse an invalid resource name: $resourceName");

    return DatabaseId._(resourceName.getSegment(1), resourceName.getSegment(3));
  }

  String get projectId => _projectId;

  String get databaseId => _databaseId;

  @override
  String toString() => "DatabaseId($projectId, $databaseId)";

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DatabaseId &&
          runtimeType == other.runtimeType &&
          projectId == other.projectId &&
          databaseId == other.databaseId;

  @override
  int get hashCode => projectId.hashCode + databaseId.hashCode;

  @override
  int compareTo(DatabaseId other) {
    int cmp = projectId.compareTo(other.projectId);
    return cmp != 0 ? cmp : databaseId.compareTo(other.databaseId);
  }
}
