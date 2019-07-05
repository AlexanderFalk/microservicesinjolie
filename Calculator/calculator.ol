include "console.iol"
include "calculator.iol"
include "operations.iol"
include "../config.iol"


execution { concurrent }

outputPort Operations { Interfaces: OperationsInterface }
embedded {Jolie: "operations.ol" in Operations}

inputPort Calculator {
    Location: Calculator_Location
    Interfaces: CalculatorInterface
}


init {
    println@Console("Calculator Service Started")()
}

main {
    [calculator( request )( response ) {
        install( ZeroDivisionError => println@Console("Error: ZERO_DIVISION_ERROR")() );
        with( values ) { .x = double(request.values.x); .y = double(request.values.y) };

        if(request.operator == "+") sum@Operations( values )( response )
        else if(request.operator == "*") mul@Operations( values )( response )
        else if(request.operator == "/") div@Operations( values )( response )
        else if(request.operator == "-") {
            if( values.y == 0 ) {
                //statusCode = 422;
                throw( ZeroDivisionError, "You can't divide with 0. Try again")
            };
            sub@Operations( values )( response ) 
        }
        else {
            println@Console("Please enter numbers...")()
        }
    }] { nullProcess }
}