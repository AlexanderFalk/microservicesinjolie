include "conditionalrequest.iol"
include "console.iol"
include "time.iol"
include "json_utils.iol"
//include "message_digest.iol"
//include "converter.iol"
include "../config.iol"
include "../Calculator/calculator.iol"

execution { concurrent }

outputPort Calculator {Interfaces: CalculatorInterface}
embedded {Jolie: "../Calculator/calculator.ol" in Calculator}

inputPort ConditionalRequest {
    Location: ConditionalRequest_Location
    Protocol: http { 
            //debug = true
            //debug.showContent = true
            headers.lastModified = "lastModified"
            statusCode -> statusCode
            format = "json" 
            addHeader.header[0] << "lastModified" { .value -> lastModified }
    }
    Interfaces: ConditionalRequestInterface
    Aggregates: Calculator with ConditionalRequestInterface_Extender // Important: has to be of same interface type
}

/*define renewData {
    stringToRaw@Converter( string(request) )( covertedOutput );
    println@Console( "" + convertedOutput + "" )();
    md5@MessageDigest( { .radix = covertedOutput } )( newResponse );
    println@Console( newResponse )();
    println@Console( "Checksum: " + checksum )()
} */

courier ConditionalRequest {
    [calculator( request )( response )] {

        if ( is_defined( request.lastModified ) ) {

            request.lastModified.format = "dd-MM-YYYY HH:mm:ss";
            println@Console(request.lastModified.format)();
            request.lastModified.language = "GMT+02:00";
            getTimestampFromString@Time( "06-24-2019 21:00:00" {.format = "dd-MM-YYYY HH:mm:ss"} )( timestampFromString );
            println@Console("Old: " + timestampFromString)();
            getCurrentTimeMillis@Time( void )( currentTimestamp );
            println@Console("New: " + currentTimestamp)()
        }
        if ( (currentTimestamp - timestampFromString) > 300000 ) { // Because it is milliseconds
            println@Console("Difference: " + (currentTimestamp - timestampFromString) )();
            getCurrentDateTime@Time( {.format = "dd-MM-YYYY HH:mm:ss"} )( lastModified )
        }

        forward( request )( response )
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