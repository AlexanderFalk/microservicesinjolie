type OperationType: void {
    .x: double
    .y: double
}

type CalculatorRequestType: void {
    .values: OperationType
    .operator: string
}

type CalculatorResponseType: void {
   .result: double
}

interface CalculatorInterface {
    RequestResponse:
        calculator( CalculatorRequestType ) ( CalculatorResponseType ) throws ZeroDivisionError ( string )
}