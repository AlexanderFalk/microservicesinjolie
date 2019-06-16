type OperationType: void {
    .x: double
    .y: double
}

//type ResponseType: void {
//    .result: double
//}

interface OperationsInterface {
        RequestResponse:
            sum( OperationType )( double ),
            mul( OperationType )( double ),
            div( OperationType )( double ),
            sub( OperationType )( double )
}