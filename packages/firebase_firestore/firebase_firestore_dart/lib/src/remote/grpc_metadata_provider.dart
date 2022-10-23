
import 'package:grpc/grpc.dart';

/// Class updates the headers for the request to the backend.
///
/// <p>UpdateMetadata updates the metadata object with some custom headers which will be sent along
/// with the default headers to the backend.
abstract class GrpcMetadataProvider {

  void updateMetadata(GrpcMetadata metadata);
}