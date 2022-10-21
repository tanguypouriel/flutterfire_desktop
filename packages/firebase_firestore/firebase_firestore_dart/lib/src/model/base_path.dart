
/// BasePath represents a path sequence in the Firestore database. It is composed of an ordered
/// sequence of string segments.
abstract class BasePath<B extends BasePath<B>> implements Comparable<B> {

  final List<String> segments;

  BasePath(this.segments);

  String getSegment(int index)  => segments[index];


  @override
  int compareTo(BasePath other) {
    // TODO: implement compareTo
    throw UnimplementedError();
  }

  B createPathWithSegments(List<String> segments);

  String canonicalString();
  // TODO
}