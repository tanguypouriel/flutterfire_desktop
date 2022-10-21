/// Represents a sort order for a Firestore Query */
class OrderBy {
  final Direction _direction;

  Direction get direction => _direction;

  final FieldPath field;

  factory OrderBy.getInstance({
    required Direction direction,
    required FieldPath path,
  }) =>
      OrderBy._(direction, path);

  OrderBy._(this._direction, this.field);

  int compare(Document d1, Document d2) {
    // TODO
    return 1;
  }
}

/// The direction of the ordering
enum Direction {
  ascending(comparisonModifier: 1),
  descending(comparisonModifier: -1);

  final int comparisonModifier;

  const Direction({required this.comparisonModifier});
}
