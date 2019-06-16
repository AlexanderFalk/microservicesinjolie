type OperationType: void {
    .x: double
    .y: double
}

type RequestType: void {
    .values: OperationType
    .operator: string
}

type ResponseType: void {
    .result: double
}

interface CalculatorInterface {
    RequestResponse:
        calculator( RequestType ) ( ResponseType ) throws ZeroDivisionError ( string )
}