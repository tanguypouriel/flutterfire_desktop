import '../model/document.dart';
import '../model/field_path.dart';
import 'field_filter.dart';

abstract class Filter {
  /// Returns true if a document matches the filter.
  bool matches(Document doc);

  /// A unique ID identifying the filter; used when serializing queries.
  String getCanonicalId();

  /// Returns a list of all field filters that are contained within this filter.
  List<FieldFilter> getFlattenedFilters();

  /// Returns a list of all filters that are contained within this filter.
  List<Filter> getFilters();

  /// Returns the field of the first filter that's an inequality, or null if none.
  FieldPath? getFirstInequalityField();
}
