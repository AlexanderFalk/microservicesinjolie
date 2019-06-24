type OperationType: void {
    .x: double
    .y: double
}

type ResponseType: void {
    .result: double
}

interface OperationsInterface {
        RequestResponse:
            sum( OperationType )( ResponseType ),
            mul( OperationType )( ResponseType ),
            div( OperationType )( ResponseType ),
            sub( OperationType )( ResponseType )
}