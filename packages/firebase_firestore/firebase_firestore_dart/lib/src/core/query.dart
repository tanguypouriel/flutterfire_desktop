import 'package:firebase_firestore_dart/src/model/resource_path.dart';

/// Encapsulates all the query attributes we support in the SDK.
/// It can be run against the LocalStore, as well as be converted
/// to a [Target] to query the RemoteStore results.
class Query {
  factory Query.atPath(ResourcePath path) => Query(path, null);

  final List<OrderBy> _explicitSortOrder;
  late List<OrderBy> _memoizedOrderBy;

  Target? memoizedTarget;

  final List<Filter> _filters;

  final ResourcePath _path;

  final String? _collectionGroup;

  final int _limit;
  final LimitType _limitType;

  final Bound? _startAt;
  final Bound? _endAt;

  /// Initializes a Query with all of its components directly. */
  Query(
    this.path,
    this._collectionGroup,
    this._filters,
    this._explicitSortOrder,
    this._limit,
    this._limitType,
    this._startAt,
    this._endAt,
  );

  // TODO other query constructor

  ResourcePath get path => _path;

}
