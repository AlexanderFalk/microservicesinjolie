include "console.iol"
include "operations.iol"

execution { concurrent }

inputPort Operations {
    Location: "local"
    Interfaces: OperationsInterface
}

define logOperation {
    println@Console(request.x + " " + _op + " " + request.y + " = " + response)()
}

main{
    [ sum( request )( response ) {
        response = request.x + request.y
        _op = "+"; logOperation
    }]
    [ mul( request )( response ) {
        response = request.x * request.y
        _op = "*"; logOperation
    }]
    [ div( request )( response ) {
        response = request.x / request.y
        _op = "/"; logOperation
    }]
    [ sub( request )( response ) {
        response = request.x - request.y
        _op = "-"; logOperation
    }]
}