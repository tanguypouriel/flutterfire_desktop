import 'dart:js_util';

/// BasePath represents a path sequence in the Firestore database. It is composed of an ordered
/// sequence of string segments.
abstract class BasePath<B extends BasePath<B>> implements Comparable<B> {
  final List<String> segments;

  BasePath(this.segments);

  String getSegment(int index) => segments[index];

  late final int length = segments.length;

  /// Returns a new path whose segments are the current path plus the passed in path
  ///
  /// [segment] - the segment to add.
  /// Returns a new path with this path's segment plus the new one.
  B append(String segment) => createPathWithSegments([...segments, segment]);

  /// Returns a new path whose segments are the current path plus another's
  ///
  /// [path] - the path whose segments to concatenate to the current path.
  /// Returns a new path with this segments path plus the new one
  B appendFromPath(B path) =>
      createPathWithSegments([...segments, ...path.segments]);

  /// Returns a new path with the current path's first [count] segments removed.
  B popFirst([int count = 1]) {
    assert(length >= count,
        "Can't call popFirst with count > length() ($count > $length)");
    return createPathWithSegments(segments.sublist(count, length));
  }

  /// Returns a new path with the current path's last segment removed.
  B popLast() => createPathWithSegments(segments.sublist(0, length - 1));

  /// Returns a new path made up of the first count segments of the current path.
  B keepFirst(int count) => createPathWithSegments(segments.sublist(0, count));

  @override
  int compareTo(B other) {
    int myLength = length;
    int theirLength = other.length;
    int i = 0;

    while (i < myLength && i < theirLength) {
      int localCompare = getSegment(i).compareTo(other.getSegment(i));
      if (localCompare != 0) return localCompare;
      i++;
    }
    return myLength.compareTo(theirLength);
  }

  /// Returns the last segment of the path.
  String get lastSegment => segments.last;

  /// Returns the first segment of the path/
  String getFirstSegment() => segments.first;

  bool get isEmpty => segments.isEmpty;

  /// Checks to see if this path is a prefix of (or equals) another path.
  ///
  /// [path] - the path to check against
  /// Returns true if current path is a prefix of the other path.
  bool isPrefixOf(B path) {
    if (length > path.length) return false;
    return segments == path.keepFirst(length);
  }

  /// Returns true if the given argument is a direct child of this path.
  ///
  /// Empty path is a parent of any path that consists of a single segment.
  bool isImmediateParentOf(B potentialChild) {
    if (length + 1 != potentialChild.length) return false;
    return segments == potentialChild.keepFirst(length);
  }

  B createPathWithSegments(List<String> segments);

  String canonicalString();

  @override
  String toString() => canonicalString();

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is BasePath && compareTo(other as B) == 0;

  @override
  int get hashCode => segments.hashCode;
}
