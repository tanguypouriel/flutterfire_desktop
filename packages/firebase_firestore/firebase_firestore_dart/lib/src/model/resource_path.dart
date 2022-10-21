import 'base_path.dart';

/// A slash separated path for navigating resources (documents and collections) within Firestore. */
class ResourcePath extends BasePath<ResourcePath> {
  final ResourcePath empty = ResourcePath([]);

  ResourcePath(List<String> segments) : super(segments);

  @override
  ResourcePath createPathWithSegments(List<String> segments) =>
      ResourcePath(segments);

  factory ResourcePath.fromSegments(List<String> segments) =>
      ResourcePath(segments);

  factory ResourcePath.fromString(String path) {
    // NOTE: The client is ignorant of any path segments containing escape
    // sequences (e.g. __id123__) and just passes them through raw (they exist
    // for legacy reasons and should not be used frequently).

    if (path.contains("//")) {
      throw Exception(
          "Invalid path ($path). Path must not contain // in them.");
    }
    // We may still have an empty segment at the beginning or end if they had a
    // leading or trailing slash (which we allow).
    List<String> segments = path
        .split('/')
        .where((segment) => segment.isNotEmpty)
        .toList(growable: false);

    return ResourcePath(segments);
  }

  @override
  String canonicalString() => segments.join("/");

}
