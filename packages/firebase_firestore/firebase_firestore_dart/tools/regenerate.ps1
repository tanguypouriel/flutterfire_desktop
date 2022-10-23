
$PROTOBUF='C:\Users\pouri\workspace\github\protobuf'
$GOOGLEAPIS='C:\Users\pouri\workspace\github\googleapis'

$PROTOC="protoc --dart_out=grpc:lib\generated -I$PROTOBUF\src -I$GOOGLEAPIS"


Invoke-Expression "$PROTOC $GOOGLEAPIS\google\rpc\status.proto"

Invoke-Expression "$PROTOC $PROTOBUF\src\google\protobuf\any.proto"
Invoke-Expression "$PROTOC $PROTOBUF\src\google\protobuf\empty.proto"
Invoke-Expression "$PROTOC $PROTOBUF\src\google\protobuf\struct.proto"
Invoke-Expression "$PROTOC $PROTOBUF\src\google\protobuf\timestamp.proto"

Invoke-Expression "$PROTOC $PROTOBUF\src\google\protobuf\wrappers.proto"

Invoke-Expression "$PROTOC $GOOGLEAPIS\google\firestore\v1\common.proto"
Invoke-Expression "$PROTOC $GOOGLEAPIS\google\firestore\v1\write.proto"
Invoke-Expression "$PROTOC $GOOGLEAPIS\google\firestore\v1\query.proto"
Invoke-Expression "$PROTOC $GOOGLEAPIS\google\firestore\v1\firestore.proto"
Invoke-Expression "$PROTOC $GOOGLEAPIS\google\firestore\v1\document.proto"
Invoke-Expression "$PROTOC $GOOGLEAPIS\google\firestore\v1\aggregation_result.proto"

Invoke-Expression "$PROTOC $GOOGLEAPIS\google\type\latlng.proto"

dart format lib\generated
