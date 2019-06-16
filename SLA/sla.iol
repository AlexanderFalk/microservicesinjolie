type RequestType: void {
    .values: OperationType
    .operator: string
}
type ResponseType: void {
    .result: double
    .servicelevel: double
}

interface ServiceLevelInterface {
    RequestResponse:
        timeToRespond( RequestType )( ResponseType )
}