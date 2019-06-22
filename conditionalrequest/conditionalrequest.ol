include "conditionalrequest.iol"
include "console.iol"
include "message_digest.iol"
include "converter.iol"
include "../config.iol"
include "../Calculator/calculator.iol"

execution { concurrent }

outputPort Calculator {Interfaces: CalculatorInterface}
embedded {Jolie: "../Calculator/calculator.ol" in Calculator}

inputPort ConditionalRequest {
    Location: ConditionalRequest_Location
    Protocol: http { .statusCode -> statusCode, .format = "json"}
    Interfaces: ConditionalRequestInterface
    Aggregates: Calculator with ConditionalRequestInterface_Extender // Important: has to be of same interface type
}

define isNewData {
    stringToRaw@Converter( string(request) )( covertedOutput );
    println@Console( "" + convertedOutput + "" )();
    md5@MessageDigest( { .radix = covertedOutput } )( newResponse );
    println@Console( newResponse )();
    println@Console( "Checksum: " + checksum )()
}

courier ConditionalRequest {
    [calculator( request )( response )] {
        isNewData
    }
}

init {
    println@Console( "Conditional Request Service has started!" )();
    install ( Aborted => nullProcess )
}

main {
    [conditionalrequest( response )] {
        println@Console("This is the response")()
    }
}