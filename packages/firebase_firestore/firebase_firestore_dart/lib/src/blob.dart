

import 'dart:typed_data';

/// Immutable class representing an array of bytes in Cloud Firestore.
class Blob implements Comparable<Blob> {

  final ByteString bytes;

  Blob(this.bytes);

  factory Blob.fromBytes(List<int> bytes) => Blob(ByteData(bytes.length));

  @override
  int compareTo(Blob other) {
    // TODO: implement compareTo
    throw UnimplementedError();
  }

}